import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/article/bindings/article_binding.dart';
import '../modules/article/views/articel_view.dart';
import '../modules/article/views/article_detail_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_checkemail_view.dart';
import '../modules/auth/forgot_password/views/forgot_password_email_view.dart';
import '../modules/auth/forgot_password/views/forgot_password_newpassword_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/verify_email/bindings/verify_email_binding.dart';
import '../modules/auth/verify_email/views/verify_email_view.dart';
import '../modules/education/bindings/education_binding.dart';
import '../modules/education/views/education_detail_view.dart';
import '../modules/education/views/education_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_logs/bindings/login_logs_binding.dart';
import '../modules/login_logs/views/login_logs_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/mood_check/bindings/mood_check_binding.dart';
import '../modules/mood_check/views/epds_onboarding_view.dart';
import '../modules/mood_check/views/epds_test_view.dart';
import '../modules/mood_check/views/mood_check_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_edit_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/program/bindings/program_binding.dart';
import '../modules/program/views/program_view.dart';
import '../modules/reminder/bindings/reminder_binding.dart';
import '../modules/reminder/views/reminder_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/stretching/bindings/stretching_binding.dart';
import '../modules/stretching/views/stretching_cam_view.dart';
import '../modules/stretching/views/stretching_detail_view.dart';
import '../modules/stretching/views/stretching_view.dart';
import '../modules/visualization/bindings/visualization_binding.dart';
import '../modules/visualization/views/visualization_view.dart';

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
      name: _Paths.VERIFY_EMAIL,
      page: () => VerifyEmailView(),
      binding: VerifyEmailBinding(),
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
      name: _Paths.STRETCHING_CAM,
      page: () => StretchingCamView(),
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
      name: _Paths.PROFILE_EDIT,
      page: () => ProfileEditView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION,
      page: () => EducationView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION_DETAIL,
      page: () => EducationDetailView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.MOOD_CHECK,
      page: () => MoodCheckView(),
      binding: MoodCheckBinding(),
    ),
    GetPage(
      name: _Paths.EPDS_ONBOARD,
      page: () => EpdsOnboardingView(),
      binding: MoodCheckBinding(),
    ),
    GetPage(
      name: _Paths.EPDS_TEST,
      page: () => EpdsTestView(),
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
    GetPage(
      name: _Paths.REMINDER,
      page: () => ReminderView(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE,
      page: () => ArticleView(),
      binding: ArticleBinding(),
    ),
    GetPage(
      name: Routes.ARTICLE_DETAIL,
      page: () => ArticleDetailView(),
      binding: ArticleBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.VISUALIZATION,
      page: () => VisualizationView(),
      binding: VisualizationBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_LOGS,
      page: () => LoginLogsView(),
      binding: LoginLogsBinding(),
    ),
  ];
}
