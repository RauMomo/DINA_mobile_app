import 'dart:async';

import 'package:get/get.dart';

class VidcallController extends GetxController {
  late Timer timer;
  var currentTime = ''.obs;

  @override
  void onInit() {
    timer = Get.arguments[0];
    currentTime = Get.arguments[1];
    super.onInit();

    interval(
      timer.tick.obs,
      (callback) {
        var minutes = (timer.tick / 60).floor();
        var seconds = timer.tick % 60;

        var parsedMinutes = minutes < 10 ? '0$minutes' : minutes.toString();
        var parsedSeconds = seconds < 10 ? '0$seconds' : seconds.toString();
        currentTime.value = '$parsedMinutes:$parsedSeconds';
      },
      time: Duration(seconds: 1),
    );
  }

  void endCall() {}
}
