import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/shared/main_app_bar/main_app_bar.dart';
import 'package:video_player/video_player.dart';

class WhyGharsPage extends StatefulWidget {
  const WhyGharsPage({super.key});

  @override
  State<WhyGharsPage> createState() => _WhyGharsPageState();
}

class _WhyGharsPageState extends State<WhyGharsPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/vedios/Ghars.mp4');
    _controller
        .initialize()
        .then((_) {
          setState(() {
            _isInitialized = true;
          });
        })
        .catchError((error) {
          debugPrint("Video initialization failed: $error");
        });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = locator<PrefsService>().appLanguage == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xfff8faf6), // Soft organic background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: MainAppBar(title: context.translate('whyGhars') ?? 'Why Ghars?'),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with Logo or Thumbnail
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffedf4e8), Color(0xfff8faf6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.logoPng,
                  height: 100.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Video Player Card Section
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Card(
                elevation: 4,
                shadowColor: AppStyle.appColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      if (_isInitialized)
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_controller),
                              // Play/Pause button overlay when paused
                              if (!_controller.value.isPlaying)
                                GestureDetector(
                                  onTap: () {
                                    _controller.play();
                                  },
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    backgroundColor: AppStyle.appColor
                                        .withOpacity(0.8),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      else
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: Colors.black12,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppStyle.appColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Custom Controller Panel
                      if (_isInitialized)
                        Container(
                          color: AppStyle.twilight.withOpacity(0.9),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          child: Column(
                            children: [
                              // Video Progress Slider
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                colors: VideoProgressColors(
                                  playedColor: AppStyle.appColor,
                                  bufferedColor: AppStyle.appColor.withOpacity(
                                    0.2,
                                  ),
                                  backgroundColor: Colors.white30,
                                ),
                              ),
                              // Controls & Timer
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_filled_rounded,
                                      color: Colors.white,
                                      size: 32.sp,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_controller.value.isPlaying) {
                                          _controller.pause();
                                        } else {
                                          _controller.play();
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.replay_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _controller.seekTo(Duration.zero);
                                      _controller.play();
                                    },
                                  ),
                                  const Spacer(),
                                  // Time counter
                                  Text(
                                    "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Why Ghars Details Texts
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate('whyGhars') ?? 'Why Ghars?',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppStyle.twilight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      context.translate('whyGharsDesc') ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppStyle.twilight,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.translate('whatWEDo') ?? 'What Ghars Offers?',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppStyle.twilight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      context.translate('whyGharsDesc2') ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppStyle.twilight,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
