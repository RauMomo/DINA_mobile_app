import 'package:flutter_getx_boilerplate/modules/auth/auth.dart';
import 'package:flutter_getx_boilerplate/modules/faq/faq_binding.dart';
import 'package:flutter_getx_boilerplate/modules/faq/faq_screen.dart';
import 'package:flutter_getx_boilerplate/modules/home/home.dart';
import 'package:flutter_getx_boilerplate/modules/me/cards/cards_screen.dart';
import 'package:flutter_getx_boilerplate/modules/modules.dart';
import 'package:flutter_getx_boilerplate/modules/rating/rating_binding.dart';
import 'package:flutter_getx_boilerplate/modules/rating/rating_screen.dart';
import 'package:flutter_getx_boilerplate/modules/vidcall/vidcall_binding.dart';
import 'package:flutter_getx_boilerplate/modules/vidcall/vidcall_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
        name: Routes.VIDCALL,
        page: () => VidcallScreen(),
        binding: VidcallBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: Routes.RATING,
        page: () => RatingScreen(),
        binding: RatingBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      children: [
        GetPage(name: Routes.CARDS, page: () => CardsScreen()),
      ],
    ),
    GetPage(
        name: Routes.FAQ,
        page: () => FaqScreen(),
        binding: FaqBinding(),
        transition: Transition.fadeIn)
  ];
}
