import 'package:flutter/material.dart';

class ShimmerArrow extends StatefulWidget {
  @override
  _ShimmerArrowState createState() {
    return _ShimmerArrowState();
  }
}

class _ShimmerArrowState extends State<ShimmerArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController.unbounded(
      vsync: this,
    )..repeat(
        min: -.5,
        max: 1.5,
        period: Duration(seconds: 1),
      );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
                    transform: _CustomGradientTransform(
                        percent: _animationController.value),
                    colors: [Colors.green.shade100, Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)
                .createShader(bounds);
          },
          child: child),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            heightFactor: .8,
            child: Icon(
              Icons.keyboard_double_arrow_right,
              size: 60,
            ),
          ),
          Align(
            heightFactor: .4,
            child: Icon(
              Icons.keyboard_double_arrow_right,
              size: 60,
            ),
          )
        ],
      ),
    );
  }
}

class _CustomGradientTransform extends GradientTransform {
  final double percent;

  _CustomGradientTransform({required this.percent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}
