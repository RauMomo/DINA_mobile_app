import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularPulseWidget extends StatefulWidget {
  const CircularPulseWidget({super.key});

  @override
  State<CircularPulseWidget> createState() => _CircularPulseWidgetState();
}

class _CircularPulseWidgetState extends State<CircularPulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: Get.height * .6,
        width: Get.width * .8,
        child: AvatarGlow(
          shape: BoxShape.circle,
          repeatPauseDuration: Duration(milliseconds: 100),
          endRadius: 500,
          glowColor: Colors.black,
          repeat: true,
          showTwoGlows: true,
          animate: true,
          curve: Curves.easeInCirc,
          startDelay: Duration(milliseconds: 500),
          child: Material(
            // Replace this child with your own
            elevation: 8.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Image.asset(
                'assets/images/mrt_main_logo.png',
                height: 60,
              ),
              radius: 120.0,
            ),
          ),
        ),
      ),
    );
  }
}
