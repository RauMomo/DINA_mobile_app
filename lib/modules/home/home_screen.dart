import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/home/home.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/circular_pulse.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/shimmer_arrow.dart';
import 'package:get/get.dart';
import 'package:slide_action/slide_action.dart';

class HomeScreen extends GetView<HomeController> {
  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: controller.callState.value == CallState.calling ||
                  controller.callState.value == CallState.idle
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.context!.isTablet ? 24 : 12,
                  ),
                  child: Image.asset(
                    'assets/images/mrt_main_logo.png',
                    scale: 2,
                    height: 100,
                    width: 100,
                  ),
                )
              : SizedBox.shrink(),
          centerTitle: true,
          title: Text(
            controller.callState.value == CallState.fullOperator ? 'FAQ' : '',
          ),
          titleTextStyle: Get.textTheme.titleLarge,
          toolbarHeight: 100,
          leadingWidth: 100,
        ),
        body: Obx(
          () {
            switch (controller.callState.value) {
              case CallState.calling:
                return _buildCallingScreen();
              case CallState.fullOperator:
                return _buildFullOperatorScreen();
              case CallState.videoCall:
                return _buildCallingScreen();
              case CallState.failed:
                return _buildCallingScreen();
              case CallState.idle:
              default:
                return _buildIdleScreen();
            }
          },
        ),
      ),
    );
  }

  _buildIdleScreen() {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.antiAlias,
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            _buildContent(),
            Expanded(
              child: _buildFAQbutton(),
            )
          ],
        )
      ],
    );
  }

  _buildCallingScreen() {
    return Column(
      children: [
        _buildOnCallMode(),
        _buildEndCallButton(),
      ],
    );
  }

  _buildFullOperatorScreen() {
    return Column(
      children: [_buildOnFAQMode(), _buildEndCallButton()],
    );
  }

  Widget _buildOnCallMode() {
    return CustomPaint(
      painter: MyCustomPainter(),
      child: SizedBox(
        width: double.infinity,
        height: Get.height * .8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularPulseWidget(),
            Text(
              controller.descriptionStatus,
              style:
                  Get.textTheme.headlineMedium!.copyWith(color: Colors.white),
            ),
            Text(controller.currentTime.value,
                style: Get.textTheme.displaySmall),
          ],
        ),
      ),
    );
  }

  _buildOnFAQMode() {
    return CustomPaint(
      painter: MyCustomPainter(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        width: double.infinity,
        height: Get.height * .8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.color,
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.circular(38),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    InputField(
                      controller: controller.faqSearchController,
                      placeholder: 'Cari...',
                      bgInputColor: Colors.white,
                      labelText: '',
                    ),
                    CommonWidget.rowHeight(
                        height: Get.context!.isTablet ? 24 : 12),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 10.0,
                        trackVisibility: true,
                        controller: controller.faqController,
                        child: ListView.builder(
                          itemCount: 30,
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: controller.faqController,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                tileColor: Colors.white,
                                dense: true,
                                minLeadingWidth: 12,
                                leading: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: ColorConstants.primaryVariant),
                                ),
                                title: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor?',
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CommonWidget.rowHeight(height: Get.context!.isTablet ? 32 : 24),
            Flexible(
              flex: 1,
              child: Column(children: [
                Text(
                  controller.descriptionStatus,
                  style: Get.textTheme.headlineMedium!
                      .copyWith(color: Colors.white),
                ),
                Text(controller.currentTime.value,
                    style: Get.textTheme.displaySmall),
              ]),
            )
          ],
        ),
      ),
    );
  }

  _buildEndCallButton() {
    return GestureDetector(
      onTap: () {
        controller.endCall();
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

  Widget _buildContent() {
    return CustomPaint(
      painter: MyCustomPainter(),
      child: SizedBox(
        width: double.infinity,
        height: Get.height * .8,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                height: Get.height * .6,
                width: Get.width * .8,
                child: Transform.translate(
                  offset: Offset(0, -16),
                  child: DecoratedBox(
                    position: DecorationPosition.background,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/images/mrt_main_logo.png',
                        ),
                        opacity: .2,
                        alignment: AlignmentDirectional.center,
                        colorFilter:
                            ColorFilter.mode(Colors.black, BlendMode.dst),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Ini adalah Deskripsi tentang MRT',
                        style: Get.textTheme.labelMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildSlider()
          ],
        ),
      ),
    );
  }

  _buildFAQbutton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.FAQ);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/faq.png',
            height: 100,
            width: 150,
          ),
          Text('FAQ')
        ],
      ),
    );
  }

  _buildSlider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SlideAction(
        trackBuilder: (context, currentState) {
          return Padding(
            padding: EdgeInsets.only(left: 32, right: 16),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 60,
                  width: double.infinity,
                  child: ShimmerArrow(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1.2,
                  child: Text('Geser Untuk Hubungi',
                      style: Get.textTheme.displayMedium!),
                )
              ],
            ),
          );
        },
        thumbBuilder: (context, currentState) {
          return Image.asset('assets/icons/call_button.png');
        },
        action: () {
          controller.setCall();
        },
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  const MyCustomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.mainColor
      ..style = PaintingStyle.fill;

    final path = Path()
      // ..moveTo(0, 0)
      // ..quadraticBezierTo(size.width / 2, size.height / 4, size.width, 0)
      // ..lineTo(size.width, size.height)
      // ..lineTo(0, size.height)
      ..relativeLineTo(0, size.height / 1.1)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height / 1.1)
      ..relativeLineTo(
        0,
        -(size.height),
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
