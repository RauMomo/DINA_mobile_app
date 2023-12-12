import 'package:get/get.dart';

import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      fenix: false,
      () => HomeController(
        apiRepository: Get.find(),
      ),
    );
  }
}
