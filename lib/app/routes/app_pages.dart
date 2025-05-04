import 'package:get/get.dart';

import '../modules/auth/forgot_password/views/forgot_password_checkemail_view.dart';
import '../modules/auth/forgot_password/views/forgot_password_newpassword_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/education/bindings/education_binding.dart';
import '../modules/education/views/education_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_email_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/mood_check/bindings/mood_check_binding.dart';
import '../modules/mood_check/views/mood_check_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/program/bindings/program_binding.dart';
import '../modules/program/views/program_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/stretching/bindings/stretching_binding.dart';
import '../modules/stretching/views/stretching_detail_view.dart';
import '../modules/stretching/views/stretching_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM,
      page: () => ProgramView(),
      binding: ProgramBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.STRETCHING,
      page: () => StretchingView(),
      binding: StretchingBinding(),
    ),
    GetPage(
      name: _Paths.STRETCHING_DETAIL,
      page: () => StretchingDetailView(),
      binding: StretchingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION,
      page: () => EducationView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.MOOD_CHECK,
      page: () => MoodCheckView(),
      binding: MoodCheckBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordEmailView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_OTP,
      page: () => ForgotPasswordCheckEmailView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_RESET,
      page: () => ForgotPasswordNewPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
  ];
}
