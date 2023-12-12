import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/vidcall/vidcall_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/utils/common_widget.dart';
import 'package:get/get.dart';

class VidcallScreen extends GetView<VidcallController> {
  var controller = Get.find<VidcallController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/cs_women.png',
            cacheHeight: Get.height.toInt(),
            cacheWidth: Get.width.toInt(),
            scale: .9,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTimerTicker(),
                  CommonWidget.rowHeight(height: context.isTablet ? 36 : 24),
                  _buildEndCallButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTimerTicker() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(6),
        child: Text(controller.currentTime.value,
            style: Get.textTheme.displaySmall),
      ),
    );
  }

  _buildEndCallButton() {
    return GestureDetector(
      onTap: () async {
        await Get.deleteAll().whenComplete(
          () => Get.toNamed(
            Routes.RATING,
          ),
        );
      },
      child: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Image.asset(
          'assets/icons/end_button.png',
          height: 100,
          width: 150,
        ),
      ),
    );
  }
}
