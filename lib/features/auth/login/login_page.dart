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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: GestureDetector(
        onTap: () => removeFocus(context),
        child: Stack(
          children: [
            // Curated gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppStyle.appColor.withValues(alpha: 0.05),
                    AppStyle.appColor.withValues(alpha: 0.15),
                    AppStyle.appColor.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Background blur overlay card
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: double.infinity,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(AppAssets.authAppbarBackground),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              bottom: 0,
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
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Brand Logo
                          FadeInDown(
                            duration: const Duration(milliseconds: 800),
                            child: Hero(
                              tag: 'logo',
                              child: Container(
                                height: 120.h,
                                padding: EdgeInsets.all(10.r),
                                child: SvgPicture.asset(
                                  AppAssets.logoSvg,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Title Header
                          FadeInDown(
                            duration: const Duration(milliseconds: 900),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                context.translate(AppStrings.login) ?? '',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          // Username Input
                          FadeInDown(
                            duration: const Duration(milliseconds: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.translate(AppStrings.userName) ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InputText(
                                  autofillHints: const [AutofillHints.username],
                                  textInputType: TextInputType.text,
                                  controller: _usernameController,
                                  fillColor: Colors.white60,
                                  topMargin: 10.h,
                                  borderColor: AppStyle.appColor.withValues(alpha: 0.2),
                                  prefixIconWidget: const Icon(
                                    Icons.person_pin_rounded,
                                    color: Colors.black54,
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
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Password Input
                          FadeInDown(
                            duration: const Duration(milliseconds: 1100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.translate(AppStrings.password) ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InputPassword(
                                  autofillHints: const [AutofillHints.password],
                                  prefixIconWidget: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black54,
                                  ),
                                  fillColor: Colors.white60,
                                  topMargin: 10.h,
                                  borderColor: AppStyle.appColor.withValues(alpha: 0.2),
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
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Forgot Password link
                          FadeInDown(
                            duration: const Duration(milliseconds: 1200),
                            child: Align(
                              alignment: prefs.appLanguage == 'en'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: TextButton(
                                child: Text(
                                  context.translate(AppStrings.forgotYourPassword) ?? '',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppStyle.appColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  // Navigating to forgot password page
                                  Navigator.of(context).pushNamed(
                                    AppRoutesNames.forgotPasswordPage,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Submit Button
                          FadeInDown(
                            duration: const Duration(milliseconds: 1300),
                            child: MainButtonWidget(
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
