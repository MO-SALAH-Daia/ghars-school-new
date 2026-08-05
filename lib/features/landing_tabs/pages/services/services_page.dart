import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/models/inv_group_stage_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/services_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/widgets/service_grid_item.dart';
import 'package:ghars_school/shared/main_app_bar/main_app_bar.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ServicesManager _manager = locator<ServicesManager>();

  final List<Color> _dynamicColors = [
    const Color(0xFF673AB7), // purple
    const Color(0xFF2196F3), // blue
    const Color(0xFFFFEB3B), // yellow
    const Color(0xFF4CAF50), // green
    const Color(0xFF03A9F4), // light blue
    const Color(0xFF3F51B5), // indigo
    const Color(0xFFF44336), // red
    const Color(0xFF00BCD4), // cyan
  ];

  final List<IconData> _dynamicIcons = [
    Icons.checkroom_rounded,
    Icons.interests_rounded,
    Icons.sports_soccer_rounded,
    Icons.directions_bus_rounded,
    Icons.sports_gymnastics_rounded,
    Icons.child_care_rounded,
    Icons.school_rounded,
    Icons.celebration_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _manager.initServices();
  }

  List<ServiceItem> _getServiceItems(List<INVGroupStageModel> stages) {
    List<ServiceItem> items = [
      ServiceItem(
        icon: Icons.receipt_long_rounded,
        titleKey: 'Payment History', // Temporary fallback
        color: const Color(0xFF2196F3),
        onTap: () {
          // TODO: Navigate to Payment History
        },
      ),
      ServiceItem(
        icon: Icons.payment_rounded,
        titleKey: 'Due Installments', // Temporary fallback
        color: const Color(0xFFF44336),
        onTap: () {
          // TODO: Navigate to Due Installments
        },
      ),
    ];

    for (var i = 0; i < stages.length; i++) {
      final stageModel = stages[i];
      final title = locator<PrefsService>().appLanguage == "ar"
          ? stageModel.arabicName ?? ""
          : stageModel.englishName ?? "";

      items.add(
        ServiceItem(
          icon: _dynamicIcons[i % _dynamicIcons.length],
          titleKey: title,
          color: _dynamicColors[i % _dynamicColors.length],
          onTap: () {
            // TODO: Navigate to ProductsMainPage with stageModel
          },
          dynamicIndex: i,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: MainAppBar(
            hasDrawerBtn: true,
            hasCartBtn: true,
            title: '${context.translate(AppStrings.services)}',
          ),
        ),
        body: Observer<ManagerState>(
          stream: _manager.state$,
          onSuccess: (context, state) {
            return StreamBuilder<List<INVGroupStageModel>>(
              stream: _manager.stages$,
              initialData: const [],
              builder: (context, snapshot) {
                final stages = snapshot.data ?? [];
                final serviceItems = _getServiceItems(stages);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: serviceItems.length,
                      itemBuilder: (context, index) {
                        return ServiceGridItem(item: serviceItems[index]);
                      },
                    ),
                  ),
                );
              },
            );
          },
          onRetryClicked: () {
            _manager.initServices();
          },
        ),
      );
  }
}
