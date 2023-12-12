import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/home/home_controller.dart';
import 'package:flutter_getx_boilerplate/modules/rating/rating_controller.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/shared/utils/common_widget.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/star_rating.dart';
import 'package:get/get.dart';

import '../../shared/constants/colors.dart';

class RatingScreen extends GetView<RatingController> {
  final controller = Get.find<RatingController>();

  @override
  Widget build(BuildContext context) {
    final textStyle = Get.textTheme.titleLarge;

    return Scaffold(
      backgroundColor: ColorConstants.mainColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
        children: [
          Container(
            height: Get.height,
            child: SingleChildScrollView(
              primary: true,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonWidget.rowHeight(
                        height: Get.context!.isTablet
                            ? kToolbarHeight / 2
                            : kToolbarHeight),
                    Text(
                      'Bagaimana Kepuasan Anda?',
                      style: textStyle,
                    ),
                    CommonWidget.rowHeight(
                        height: Get.context!.isTablet ? 24 : 16),
                    Obx(
                      () => StarRating(
                        rating: controller.rating.value,
                        onRatingChange: (rating) {
                          controller.onRatingChange(rating);
                        },
                        starCount: 5,
                      ),
                    ),
                    _buildRatingFeedback(),
                    _buildSuggestionBox(context),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildButton(),
            ),
          ),
        ],
      )),
    );
  }

  _buildRatingFeedback() {
    var textStyle = Get.textTheme.bodyMedium!.copyWith(color: Colors.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonWidget.rowHeight(height: Get.context!.isTablet ? 24 : 16),
        Text('Apa yang anda suka dari kami?', style: textStyle),
        CommonWidget.rowHeight(height: Get.context!.isTablet ? 24 : 16),
        Obx(
          () => Flexible(
            fit: FlexFit.loose,
            child: Wrap(
              runSpacing: 0,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              textDirection: TextDirection.ltr,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ...controller.feedbackChips
                    .map(
                      (e) => ChoiceChip(
                        label: Text(e.name),
                        labelStyle: e.isSelected == true
                            ? textStyle.copyWith(color: ColorConstants.white)
                            : textStyle.copyWith(
                                color: ColorConstants.darkGray),
                        onSelected: (value) {
                          controller.setSelected(value, e);
                        },
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -1),
                        selected: e.isSelected,
                        color:
                            MaterialStatePropertyAll(ColorConstants.lightGray),
                        selectedColor: Colors.grey[850],
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
        CommonWidget.rowHeight(height: Get.context!.isTablet ? 24 : 16),
      ],
    );
  }

  _buildSuggestionBox(context) {
    var textStyle = Get.textTheme.bodyMedium!.copyWith(color: Colors.white);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Kritik dan Saran', style: textStyle),
        CommonWidget.rowHeight(height: Get.context!.isTablet ? 16 : 8),
        TextField(
          focusNode: controller.focusNode,
          controller: controller.feedbackController,
          maxLength: 240,
          maxLines: 6,
          buildCounter: null,
          minLines: 6,
          onTap: () {
            controller.focusNode.requestFocus();
          },
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          decoration: InputDecoration(
              enabled: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(16),
              ),
              counterText: ''),
        )
      ],
    );
  }

  _buildButton() {
    final textStyle = Get.textTheme.labelLarge;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: textStyle,
        backgroundColor: ColorConstants.primaryVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        minimumSize: Size.fromHeight(Get.height * .075),
      ),
      onPressed: () {
        Get.delete<HomeController>();
        Get.offAllNamed(
          Routes.HOME,
          predicate: (route) => false,
        );
      },
      child: Text('Selesai'),
    );
  }
}
