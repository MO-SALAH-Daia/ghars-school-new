import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/auth/login/login_manager.dart';
import 'package:ghars_school/features/auth/login/login_request.dart';
import 'package:ghars_school/shared/input_form_field/input_password.dart';
import 'package:ghars_school/shared/input_form_field/input_text.dart';
import 'package:ghars_school/shared/main_button/main_button_widget.dart';
import 'package:ghars_school/shared/remove_focus/remove_focus.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _showRoleSelectionDialog(
    BuildContext context,
    LoginManager loginManager,
    LoginResult result,
    String username,
    String password,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            context.translate(AppStrings.gharsSchool) ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppStyle.appColor,
            ),
          ),
          content: Text(
            context.translate(AppStrings.areYouWantContinueAsParentOrEmployee) ?? '',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                // Login as Employee
                final state = await loginManager.login(
                  request: LoginRequest(
                    username: username,
                    password: password,
                    loginAsEmp: true,
                  ),
                );
                if (state.state == ManagerState.success) {
                  locator<NavigationService>().pushNamedAndRemoveUntil(
                    AppRoutesNames.mainTabsWidget,
                  );
                }
              },
              child: Text(
                context.translate(AppStrings.continueAsEmployee) ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Save the session as Parent
                final user = result.user;
                if (user != null) {
                  loginManager.saveUserSession(user, username, password);
                  locator<NavigationService>().pushNamedAndRemoveUntil(
                    AppRoutesNames.mainTabsWidget,
                  );
                }
              },
              child: Text(
                context.translate(AppStrings.continueAsParent) ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginManager = context.use<LoginManager>();
    final prefs = context.use<PrefsService>();

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
                  color: AppStyle.blueCyan.withOpacity(0.08),
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
                  color: AppStyle.appColor.withOpacity(0.06),
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
                stream: loginManager.state$,
                builder: (context, AsyncSnapshot<ManagerState> stateSnapshot) {
                  return FormsStateHandling(
                    managerState: stateSnapshot.data,
                    errorMsg: loginManager.errorDescription,
                    onClickCloseErrorBtn: () {
                      loginManager.inState.add(ManagerState.idle);
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
                                SizedBox(height: 30.h),
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
                                    context.translate(AppStrings.login) ?? 'Login',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppStyle.twilight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                // Login Card Container
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
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 20,
                                            offset: const Offset(0, -6),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10.h),
                                          // Username Label
                                          Text(
                                            context.translate(AppStrings.userName) ?? '',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppStyle.twilight,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          InputText(
                                            autofillHints: const [AutofillHints.username],
                                            textInputType: TextInputType.text,
                                            controller: _usernameController,
                                            fillColor: const Color(0xfffcfdfe),
                                            topMargin: 8.h,
                                            borderRadius: 12.r,
                                            borderColor: AppStyle.appColor.withOpacity(0.15),
                                            prefixIconWidget: Icon(
                                              Icons.person_outline_rounded,
                                              color: AppStyle.appColor,
                                            ),
                                            hint: context.translate(AppStrings.userName) ?? '',
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 14.h,
                                            ),
                                            currentFocusNode: _usernameFocus,
                                            nextFocusNode: _passwordFocus,
                                            validator: (value) {
                                              if (value == null || value.trim().isEmpty) {
                                                return context.translate(AppStrings.required) ?? '';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 20.h),
                                          // Password Label
                                          Text(
                                            context.translate(AppStrings.password) ?? '',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppStyle.twilight,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          InputPassword(
                                            autofillHints: const [AutofillHints.password],
                                            prefixIconWidget: Icon(
                                              Icons.lock_outline_rounded,
                                              color: AppStyle.appColor,
                                            ),
                                            fillColor: const Color(0xfffcfdfe),
                                            topMargin: 8.h,
                                            borderRadius: 12.r,
                                            borderColor: AppStyle.appColor.withOpacity(0.15),
                                            hint: context.translate(AppStrings.password) ?? '',
                                            controller: _passwordController,
                                            currentFocusNode: _passwordFocus,
                                            validator: (value) {
                                              if (value == null || value.trim().isEmpty) {
                                                return context.translate(AppStrings.required) ?? '';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 10.h),
                                          // Forgot Password Link
                                          Align(
                                            alignment: prefs.appLanguage == 'en'
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: TextButton(
                                              child: Text(
                                                context.translate(AppStrings.forgotYourPassword) ?? '',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppStyle.appColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  AppRoutesNames.forgotPasswordPage,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 25.h),
                                          // Submit Button
                                          MainButtonWidget(
                                            title: context.translate(AppStrings.login) ?? '',
                                            buttonHeight: 48.h,
                                            color: AppStyle.appColor,
                                            borderColor: AppStyle.appColor,
                                            onClick: () async {
                                              removeFocus(context);
                                              if (_formKey.currentState!.validate()) {
                                                _formKey.currentState!.save();
                                              } else {
                                                setState(() {
                                                  _autoValidateMode = AutovalidateMode.always;
                                                });
                                                return;
                                              }

                                              final username = _usernameController.text;
                                              final password = _passwordController.text;

                                              final result = await loginManager.login(
                                                request: LoginRequest(
                                                  username: username,
                                                  password: password,
                                                  loginAsEmp: false,
                                                ),
                                              );

                                              if (result.state == ManagerState.success) {
                                                if (result.isEmployeeSelectionRequired) {
                                                  _showRoleSelectionDialog(
                                                    context,
                                                    loginManager,
                                                    result,
                                                    username,
                                                    password,
                                                  );
                                                } else {
                                                  locator<NavigationService>().pushNamedAndRemoveUntil(
                                                    AppRoutesNames.mainTabsWidget,
                                                  );
                                                }
                                              }
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
          ],
        ),
      ),
    );
  }
}
