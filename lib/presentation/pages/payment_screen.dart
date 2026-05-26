import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/config/brand_config.dart';
import '../../core/theme/app_theme.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/payment_content_cubit.dart';
import '../cubit/payment_content_state.dart';
import '../layout/section_registry.dart';
import '../widgets/root_warning_dialog.dart';
import '../widgets/security_scan_view_animation.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const _registry = SectionRegistry();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(context.read<BrandConfig>().appName)),
          // Content (summary + SDUI layout) is owned by PaymentContentCubit.
          body: BlocBuilder<PaymentContentCubit, PaymentContentState>(
            builder: (context, state) {
              switch (state.status) {
                case ContentStatus.initial:
                case ContentStatus.loading:
                  return Center(
                    child: CircularProgressIndicator(
                        color: context.colors.brandPrimary),
                  );
                case ContentStatus.failure:
                  return Center(
                    child:
                        Text(state.failure?.message ?? 'Something went wrong'),
                  );
                case ContentStatus.success:
                  return RefreshIndicator(
                    onRefresh: () => context.read<PaymentContentCubit>().load(),
                    child: ListView.separated(
                      padding: context.dimens.contentPadding,
                      itemCount: state.layout.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final block = state.layout[index];
                        return KeyedSubtree(
                          key: ValueKey(block.type),
                          child: _registry
                              .resolve(block.type)
                              .build(context, block),
                        );
                      },
                    ),
                  );
              }
            },
          ),
        ),
        // Checkout flow (scan -> processing) is owned by CheckoutCubit.
        BlocConsumer<CheckoutCubit, CheckoutPhase>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, phase) {
            final cubit = context.read<CheckoutCubit>();
            switch (phase) {
              case CheckoutPhase.blocked:
                showRootWarningDialog(context).then((_) => cubit.reset());
                break;
              case CheckoutPhase.done:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment processed')),
                );
                cubit.reset();
                break;
              case CheckoutPhase.idle:
              case CheckoutPhase.scanning:
              case CheckoutPhase.processing:
                break;
            }
          },
          builder: (context, phase) {
            final visible = phase == CheckoutPhase.scanning ||
                phase == CheckoutPhase.processing;
            if (!visible) return const SizedBox.shrink();
            return _CheckoutOverlay(phase: phase);
          },
        ),
      ],
    );
  }
}

class _CheckoutOverlay extends StatelessWidget {
  const _CheckoutOverlay({required this.phase});

  final CheckoutPhase phase;

  @override
  Widget build(BuildContext context) {
    final scanning = phase == CheckoutPhase.scanning;
    return Positioned.fill(
      child: AbsorbPointer(
        child: Material(
          type: MaterialType.transparency,
          child: ColoredBox(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Radar = the security-scan visual; processing shows progress.
                  if (scanning)
                    SecurityScanViewAnimation(
                        size: context.dimens.sizeSecurityScanView,
                        color: context.colors.brandPrimary)
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(scanning ? 'Security scan…' : 'Processing payment…',
                      style: context.typography.titleMedium.copyWith(
                        color: context.colors.onBrandPrimary,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
