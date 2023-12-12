import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  late ScrollController faqController;
  late TextEditingController faqSearchController;

  @override
  void onInit() {
    faqController = ScrollController();
    faqSearchController = TextEditingController();
    super.onInit();
  }
}
