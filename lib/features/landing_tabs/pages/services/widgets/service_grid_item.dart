import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceItem {
  final IconData icon;
  final String titleKey;
  final Color color;
  final VoidCallback? onTap;
  final int? dynamicIndex;

  const ServiceItem({
    required this.icon,
    required this.titleKey,
    required this.color,
    this.onTap,
    this.dynamicIndex,
  });
}

class ServiceGridItem extends StatefulWidget {
  final ServiceItem item;

  const ServiceGridItem({super.key, required this.item});

  @override
  State<ServiceGridItem> createState() => _ServiceGridItemState();
}

class _ServiceGridItemState extends State<ServiceGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverController.reverse();
        widget.item.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? widget.item.color.withValues(alpha: 0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.item.color.withValues(
                      alpha: _isPressed ? 0.3 : 0.15,
                    ),
                    blurRadius: _isPressed ? 15.r : 10.r,
                    offset: Offset(0, _isPressed ? 8.h : 5.h),
                  ),
                ],
                border: Border.all(
                  color: widget.item.color.withValues(alpha: 0.3),
                  width: 1.5.w,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.item.color,
                          widget.item.color.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: widget.item.color.withValues(alpha: 0.4),
                          blurRadius: 8.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: Colors.white,
                      size: 32.w,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      widget.item.titleKey,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
