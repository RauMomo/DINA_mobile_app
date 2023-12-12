import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChange;
  final Color color;

  const StarRating(
      {super.key,
      this.starCount = 5,
      this.rating = 4,
      this.onRatingChange,
      this.color = ColorConstants.goldenColor});

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        starCount,
        (index) => _buildStar(
          index,
        ),
      ),
    );
  }

  _buildStar(
    int index,
  ) {
    var icon = index + 1 <= rating
        ? Icon(
            Icons.star,
            color: ColorConstants.goldenColor,
            size: Get.context!.isTablet ? 48 : 64,
          )
        : Icon(
            Icons.star_border,
            size: 48,
          );
    return InkResponse(
      onTap: onRatingChange == null ? null : () => onRatingChange!(index + 1.0),
      child: icon,
    );
  }
}
