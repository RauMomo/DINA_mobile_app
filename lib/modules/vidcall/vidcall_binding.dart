import 'package:flutter_getx_boilerplate/modules/vidcall/vidcall_controller.dart';
import 'package:get/get.dart';

class VidcallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VidcallController>(() => VidcallController());
  }
}
