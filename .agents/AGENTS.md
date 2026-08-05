# Project Specific Rules & Standards (Ghars School App)

## 1. UI Layout & Scrolling Standards
- **Single Top-Level Scroll View**: Complex feature screens with multiple cards, headers, or sub-tabs must use a single top-level `SingleChildScrollView(physics: BouncingScrollPhysics())`. Child tabs or sub-views MUST use `Column` instead of nested `ListView`s to avoid nested scroll conflicts.
- **Floating Bottom Nav Bar Clearance**: Always append a safe bottom space (`SizedBox(height: 110.h)`) at the end of scrollable page bodies so that bottom cards/actions are never obscured by `FloatingBottomNavBar`.
- **Refined Typography & Compact Spacing**: Use `Cairo` font for Arabic UI, keep header avatars to responsive sizes (`72.r`), and use compact font scales (titles `11.sp`-`13.sp`, values `13.5.sp`-`15.sp`).

## 2. Model & Dropdown Safety
- **DropdownButton Instance Comparison**: Never pass a raw model object to `DropdownButton<T>(value: selectedObj)` if the items list is refreshed dynamically. Always resolve `actualSelected` by matching unique ID (`students.firstWhere((s) => s.id == selected.id, orElse: () => ...)`).
- **BaseRepository Response Unwrapping**: `BaseResponse.fromJson` unwraps the outer `"result"` field automatically. Repositories must pass the unwrapped inner JSON to `Model.fromJson(json as Map<String, dynamic>)`.

## 3. Drawer Navigation & Verification
- **ZoomDrawer Integration**: For features requiring a side menu, update `ContainerPageWithDrawer` to dynamically set `currentMenuScreen` when `tabIndex` matches the feature tab.
- **Strict Error Log Verification**: Before declaring a task finished, inspect `dart analyze` outputs for non-zero exit codes or compilation errors. Never rely solely on high-level log summaries.
