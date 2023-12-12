import 'package:flutter_getx_boilerplate/modules/faq/faq_controller.dart';
import 'package:get/get.dart';

class FaqBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(() => FaqController());
  }
}
