import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/faq/faq_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/input_field.dart';
import 'package:get/get.dart';

class FaqScreen extends GetView<FaqController> {
  var controller = Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainColor,
      appBar: AppBar(
        flexibleSpace: SizedBox(height: Get.height * .1),
        elevation: 0,
        backgroundColor: ColorConstants.mainColor,
        leadingWidth: Get.width * .3,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                backgroundColor: ColorConstants.white),
            onPressed: () {
              Get.back();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: Colors.black,
                ),
                Text(
                  'Kembali',
                  style: Get.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text('FAQ'),
      ),
      body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.color,
            color: Colors.black.withOpacity(.5),
            borderRadius: BorderRadius.circular(38),
          ),
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                width: Get.width,
                margin: EdgeInsets.only(bottom: 16),
                child: InputField(
                  controller: controller.faqSearchController,
                  placeholder: 'Cari...',
                  bgInputColor: Colors.white,
                  labelText: '',
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    height: 8,
                                    width: 8,
                                    decoration: ShapeDecoration(
                                        shape: CircleBorder(),
                                        color: ColorConstants.primaryVariant),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor?',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }, childCount: 30, addAutomaticKeepAlives: true),
                    ),
                  ],
                ),
              ),
            ],
          )
          // child: Column(
          //   mainAxisSize: MainAxisSize.max,
          //   children: <Widget>[
          //     Text('Hey'),
          //     SizedBox(
          //       height: 200,
          //       child: ListView.builder(
          //         itemCount: 30,
          //         padding: EdgeInsets.zero,
          //         semanticChildCount: 0,
          //         scrollDirection: Axis.vertical,
          //         shrinkWrap: true,
          //         controller: controller.faqController,
          //         itemExtent: Get.height * .08,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: EdgeInsets.symmetric(vertical: 4),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: ListTile(
          //               tileColor: Colors.white,
          //               minLeadingWidth: 12,
          //               leading: Container(
          //                 height: 8,
          //                 width: 8,
          //                 decoration: ShapeDecoration(
          //                     shape: CircleBorder(),
          //                     color: ColorConstants.primaryVariant),
          //               ),
          //               title: Text(
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor?',
          //                 style: Get.textTheme.bodyMedium,
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
