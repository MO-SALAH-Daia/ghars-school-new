import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/models/inv_group_stage_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/services_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/widgets/service_grid_item.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with TickerProviderStateMixin {
  final ServicesManager _manager = locator<ServicesManager>();

  List<AnimationController> _controllers = [];
  List<Animation<double>> _scaleAnimations = [];
  List<Animation<double>> _fadeAnimations = [];
  bool _animationsInitialized = false;

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

  void _initAnimations(int itemCount) {
    for (var controller in _controllers) {
      controller.dispose();
    }

    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeIn),
      );
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted && i < _controllers.length) {
          _controllers[i].forward();
        }
      });
    }

    _animationsInitialized = true;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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

      items.add(ServiceItem(
        icon: _dynamicIcons[i % _dynamicIcons.length],
        titleKey: title,
        color: _dynamicColors[i % _dynamicColors.length],
        onTap: () {
          // TODO: Navigate to ProductsMainPage with stageModel
        },
        dynamicIndex: i,
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Observer<ManagerState>(
      stream: _manager.state$,
      onSuccess: (context, state) {
        return StreamBuilder<List<INVGroupStageModel>>(
          stream: _manager.stages$,
          initialData: const [],
          builder: (context, snapshot) {
            final stages = snapshot.data ?? [];
            final serviceItems = _getServiceItems(stages);

            if (!_animationsInitialized || _controllers.length != serviceItems.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _initAnimations(serviceItems.length);
                  });
                }
              });
            }

            return Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: serviceItems.length,
                itemBuilder: (context, index) {
                  if (index >= _controllers.length) {
                    return ServiceGridItem(item: serviceItems[index]);
                  }
                  return AnimatedBuilder(
                    animation: _controllers[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimations[index].value,
                        child: Opacity(
                          opacity: _fadeAnimations[index].value,
                          child: ServiceGridItem(item: serviceItems[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
      onRetryClicked: () {
        _manager.initServices();
      },
    );
  }
}
