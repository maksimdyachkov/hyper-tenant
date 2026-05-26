# AI Insight Report — Hyper-Tenant Secure Payment Portal

## 1. Multi-tenant configuration

A brand differs along three independent axes; no widget contains an
`if (brand == ...)` branch.

1. **Visual identity → `ThemeExtension`.** `AppColors`, `AppDimens`,
   `AppTypography` per brand, injected into `ThemeData.extensions`. Widgets
   read `context.colors / dimens / typography`. Spacing is a token too —
   `context.dimens.space(2)` is `16` on Retail (8pt grid), `8` on Utility
   (4pt grid).
2. **Functional config → `BrandConfig`.** Interface (`appName`, layout asset
   path) with one immutable impl per brand, provided via `get_it` +
   `RepositoryProvider`.
3. **Screen composition → Server-Driven UI.** Per-brand JSON describes an
   ordered list of `LayoutBlock { type, data }`. `SectionRegistry` maps ids
   → widgets. The screen iterates with zero conditionals; unknown types
   degrade to a no-op section.

Adding a 3rd brand: `BrandConfig` + token set + layout JSON + entrypoint +
Gradle flavor. No widget / screen / cubit / registry changes.

## 2. How I used AI

AI was a pair-programmer for the parts where speed beats originality:

- **Boilerplate** — `ThemeExtension` `copyWith` / `lerp`, `json_serializable`
  models for the SDUI blocks.
- **API-level correctness** — foreground-service rules across Android
  versions (channel on API 26, `POST_NOTIFICATIONS` on 33,
  `foregroundServiceType=shortService` + 5-second `startForeground` on 34,
  `FOREGROUND_SERVICE_IMMEDIATE` to avoid the 10s deferral).
- **Performance patterns** — `CustomPainter` radar with vsync `Listenable`
  repaint, `RepaintBoundary`, reused `Paint`s, GPU `SweepGradient`.
- **Architecture scaffolding** — Clean Architecture layering and the
  white-label engine, which I iterated on.

## 3. Prompt log (key interactions)

**(a) White-label theme.** *"Configuration-driven engine for two Flutter
brands using `ThemeExtension` — no `if/else` on the brand."* Refinement: I
derived `ColorScheme` from the same tokens and made spacing a `space(n)`
helper tied to the brand grid.

**(b) CustomPainter at 60/120 FPS.** *"Pulsating radar, no widget rebuilds."*
Refinement: moved `Paint`s to fields, cached the `SweepGradient` shader per
size.

**(c) Native bridge.** *"`MethodChannel` for root + `FLAG_SECURE`, plus a
foreground service with a progress notification."* Refinement: awaited the
notification permission (first version fire-and-forgot — first tap showed
nothing), separate id for the "done" notification (reusing the progress id
dropped it), `ServiceCompat.stopForeground` for `minSdk` compatibility.

## 4. Where AI was sub-optimal — and how I corrected it

**Sub-optimal:** the first white-label screen put per-feature booleans on the
config and branched on them in the UI:

```dart
bool get showPromoBanner;
bool get showBillBreakdown;

if (config.showPromoBanner) const PromoBanner(),
if (config.showBillBreakdown) BillBreakdown(...),
```

**Why it's wrong:** the widget still decides what to show based on the brand,
just via booleans. Violates ISP (every brand implements every flag) and OCP
(each new feature edits every config + adds an `if`).

**Fix:** I Decided implement  with SDUI. The brand supplies an ordered list of
block ids as data; `SectionRegistry` maps each id to a `PaymentSection`; the
screen iterates and renders. Zero conditionals. A new block is one section +
one registry entry + one line in the layout JSON.

**Second audit:** the initial `PaymentCubit` did both content loading and the
checkout flow (two state machines in one class). Split into
`PaymentContentCubit` and `CheckoutCubit`. The `_processSim` timer is a
stop-gap; the real path is an `EventChannel` streaming `progress` / `done`
from the service.

**Third audit (API-level):** for
`WindowManager.addScreenRecordingCallback` (Android 15), the AI initially
said no permission was required. Lint flagged
`android.permission.DETECT_SCREEN_RECORDING` — a new install-time permission
added in API 35 specifically for this API. Declared it in the manifest.

## 5. How I audit AI output

Every block goes through the same checks: compiles and passes lints, honors
explicit constraints (no `if/else` branding), correct on target API levels,
SRP/SOLID-clean. Placeholders (timers, stubbed repos, heuristic root checks)
are marked with `TODO`s and a real path forward (EventChannel, network repo,
Play Integrity). AI accelerates the first draft; the senior judgement is in
the review.
