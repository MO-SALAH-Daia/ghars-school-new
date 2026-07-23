import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/auth/forgot_password/forgot_password_manager.dart';
import 'package:ghars_school/shared/input_form_field/input_text.dart';
import 'package:ghars_school/shared/main_button/main_button_widget.dart';
import 'package:ghars_school/shared/remove_focus/remove_focus.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final _usernameFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordManager = context.use<ForgotPasswordManager>();
    final prefs = context.use<PrefsService>();
    final isArabic = prefs.appLanguage == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xfff8faf6), // Soft organic background
      body: GestureDetector(
        onTap: () => removeFocus(context),
        child: Stack(
          children: [
            // Background organic gradient with soft glows
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffedf4e8), // Soft brand green tint
                    Color(0xfff5f8f3), // Very light organic tint
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Floating ambient glows
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.blueCyan.withValues(alpha: 0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              top: 150.h,
              left: -150.w,
              child: Container(
                width: 350.w,
                height: 350.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.appColor.withValues(alpha: 0.06),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: StreamBuilder<ManagerState>(
                initialData: ManagerState.idle,
                stream: forgotPasswordManager.state$,
                builder: (context, AsyncSnapshot<ManagerState> stateSnapshot) {
                  return FormsStateHandling(
                    managerState: stateSnapshot.data,
                    errorMsg: forgotPasswordManager.errorDescription,
                    onClickCloseErrorBtn: () {
                      forgotPasswordManager.inState.add(ManagerState.idle);
                    },
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              children: [
                                SizedBox(height: 50.h),
                                // Brand Logo (Full SVG with typography)
                                FadeInDown(
                                  duration: const Duration(milliseconds: 700),
                                  child: Hero(
                                    tag: 'logo',
                                    child: Container(
                                      height: 140.h,
                                      padding: EdgeInsets.all(10.r),
                                      child: SvgPicture.asset(
                                        AppAssets.logoSvg,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                FadeInDown(
                                  duration: const Duration(milliseconds: 800),
                                  child: Text(
                                    context.translate(
                                          AppStrings.forgotYourPassword,
                                        ) ??
                                        'Forgot Password',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppStyle.twilight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                // Content Card Container
                                Expanded(
                                  child: FadeInUp(
                                    duration: const Duration(milliseconds: 800),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(24.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.r),
                                          topRight: Radius.circular(30.r),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.04,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, -6),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10.h),
                                          // Title inside the Card
                                          Text(
                                            context.translate(
                                                  AppStrings.resetPassword,
                                                ) ??
                                                'Reset Password',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppStyle.twilight,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          // Description Text
                                          Text(
                                            isArabic
                                                ? 'يرجى إدخال اسم المستخدم أو البريد الإلكتروني لإرسال رمز التحقق وإعادة تعيين كلمة المرور.'
                                                : 'Please enter your username or email to send the verification code and reset your password.',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppStyle.lightGrey,
                                              height: 1.4,
                                            ),
                                          ),
                                          SizedBox(height: 30.h),
                                          // Username/Email Label
                                          Text(
                                            context.translate(
                                                  AppStrings.userName,
                                                ) ??
                                                'Username / Email',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppStyle.twilight,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          InputText(
                                            autofillHints: const [
                                              AutofillHints.username,
                                              AutofillHints.email,
                                            ],
                                            textInputType: TextInputType.text,
                                            controller: _usernameController,
                                            fillColor: const Color(0xfffcfdfe),
                                            topMargin: 8.h,
                                            borderRadius: 12.r,
                                            borderColor: AppStyle.appColor
                                                .withValues(alpha: 0.15),
                                            prefixIconWidget: Icon(
                                              Icons.person_outline_rounded,
                                              color: AppStyle.appColor,
                                            ),
                                            hint:
                                                context.translate(
                                                  AppStrings.userName,
                                                ) ??
                                                'Username / Email',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 14.h,
                                                ),
                                            currentFocusNode: _usernameFocus,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return context.translate(
                                                      AppStrings.required,
                                                    ) ??
                                                    'Field is required';
                                              }
                                              return null;
                                            },
                                          ),
                                          const Spacer(),
                                          SizedBox(height: 20.h),
                                          // Submit Button
                                          MainButtonWidget(
                                            title:
                                                context.translate(
                                                  AppStrings.send,
                                                ) ??
                                                'Send',
                                            buttonHeight: 48.h,
                                            color: AppStyle.appColor,
                                            borderColor: AppStyle.appColor,
                                            onClick: () async {
                                              removeFocus(context);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                              } else {
                                                setState(() {
                                                  _autoValidateMode =
                                                      AutovalidateMode.always;
                                                });
                                                return;
                                              }

                                              // final username =
                                              //     _usernameController.text
                                              //         .trim();
                                              // final success =
                                              //     await forgotPasswordManager
                                              //         .forgotPassword(
                                              //           request:
                                              //               ForgotPasswordRequest(
                                              //                 username:
                                              //                     username,
                                              //               ),
                                              //         );
                                              //
                                              // if (success && context.mounted) {
                                              //   locator<ToastTemplate>().show(
                                              //     isArabic
                                              //         ? 'تم إرسال رمز التحقق بنجاح'
                                              //         : 'Verification code sent successfully',
                                              //     backGroundColor:
                                              //         AppStyle.appColor,
                                              //   );
                                              //   Navigator.of(context).pop();
                                              // }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Back Button (Placed at the bottom of the Stack children list so it sits on top and receives touch events)
            Positioned(
              top: 20.h,
              left: isArabic ? null : 16.w,
              right: isArabic ? 16.w : null,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppStyle.appColor,
                      size: 20.sp,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
