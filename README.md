# Hyper-Tenant Secure Payment Portal

A Flutter Payment Confirmation module with two brand flavors (Retail Shop /
Utility Pay), Android native security integration, and a 60/120 FPS
`CustomPainter` radar.

> **📝 README update — May 27, 2026**
>
> *Informational note only. No code changes were made — this section was
> added to the README for reviewer clarity. The project aims to track the
> latest stable versions, but since the task is already submitted for
> review, the upgrade is documented here rather than applied to the code.*
>
> Built and verified on **Flutter 3.27**. Newer Flutter SDKs or Android
> Studio releases may have raised their minimum supported AGP / Kotlin /
> Gradle versions; if the build refuses to start, bump AGP to `8.6`, Kotlin
> to `2.1`, Gradle to `8.7`, or pass
> `--android-skip-build-dependency-validation` to skip the dependency check.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor retail  -t lib/main_retail.dart
flutter run --flavor utility -t lib/main_utility.dart
```

Release APKs:

```bash
flutter build apk --flavor retail  -t lib/main_retail.dart  --release
flutter build apk --flavor utility -t lib/main_utility.dart --release
```

`minSdk 23`, `compileSdk 35`, `targetSdk 35` (Android 15).

## Architecture (three independent axes)

1. **Visual identity** — `ThemeExtension`s (`AppColors`, `AppDimens`,
   `AppTypography`) injected into `ThemeData.extensions`. Widgets read tokens
   through `context.colors / context.dimens / context.typography` — never
   `if (brand == ...)`.
2. **Functional config** — `BrandConfig` interface (`appName`, layout asset
   path) provided once at the app entrypoint via `get_it` +
   `RepositoryProvider`.
3. **Screen composition** — Server-Driven UI. The screen renders an ordered
   list of `LayoutBlock { type, data }` loaded from a per-brand JSON asset;
   `SectionRegistry` maps each id to a `PaymentSection`. Zero conditionals on
   the screen.

State is split by responsibility: `PaymentContentCubit` (load summary + SDUI
layout) and `CheckoutCubit` (scan → processing flow). DI in
`injection_container.dart`.

### Adding a 3rd brand

`BrandConfig` impl + theme tokens + `assets/layouts/<brand>.json` + entrypoint
+ Gradle flavor. No widget, screen, cubit, or registry changes.

## Android native (Kotlin)

- `MethodChannel com.hypertenant/security` — `isRooted`, `enableSecure /
  disableSecure` (FLAG_SECURE).
- `EventChannel com.hypertenant/screen_recording` —
  `WindowManager.addScreenRecordingCallback` (Android 15+). Requires
  `android.permission.DETECT_SCREEN_RECORDING` (API 35, install-time).
- `MethodChannel com.hypertenant/payment_service` — start/stop the
  `PaymentForegroundService` (`shortService`, `FOREGROUND_SERVICE_IMMEDIATE`,
  separate completion notification id).

UI guards: `RootGuard` (warning dialog), `SecureWindow` (FLAG_SECURE),
`ScreenRecordingGuard` (in-app blackout overlay).

## Performance

- vsync `AnimationController` → `CustomPainter(repaint: controller)` — no
  `setState`, no widget rebuilds.
- `RepaintBoundary` isolates the painter layer.
- `Paint` objects and the `SweepGradient` shader are reused; shader is rebuilt
  only when the canvas size changes.

## Layout

```
lib/
  core/         config, theme, error
  domain/       models, repositories, services (interfaces)
  data/         repository + service implementations
  presentation/ cubits, pages, widgets, sections (SDUI registry)
  main_retail.dart, main_utility.dart, injection_container.dart
```

## Known limitations

- Root check is a heuristic — production should use Play Integrity.
- Foreground-service completion is a stop-gap timer in `CheckoutCubit`. The
  real path is an `EventChannel` streaming `progress` / `done` from the
  service.
- Demo summary is hardcoded — `PaymentRepositoryImpl` does not hit a network.



https://github.com/user-attachments/assets/14be66c1-1cc2-4630-9ed9-2d1ac3e77ce2


