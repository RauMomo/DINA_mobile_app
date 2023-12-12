// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  final RxList<ChipOption> feedbackChips = [
    ChipOption(isSelected: false, name: 'Informasi yang akurat'),
    ChipOption(isSelected: false, name: 'Penyampaian sangat jelas'),
    ChipOption(isSelected: false, name: 'Ketepatan waktu'),
    ChipOption(isSelected: false, name: 'Video Call lancar'),
    ChipOption(
      isSelected: false,
      name: 'Proses sangat cepat',
    ),
    ChipOption(
      isSelected: false,
      name: 'Kualitas pelayanan baik',
    ),
    ChipOption(
      isSelected: false,
      name: 'Empati dan Daya Tanggap yang cepat',
    ),
  ].obs;

  late final FocusNode focusNode;
  late final TextEditingController feedbackController;
  RxDouble rating = 5.0.obs;

  @override
  onInit() {
    super.onInit();
    focusNode = FocusNode();
    feedbackController = TextEditingController();
  }

  setSelected(bool value, ChipOption option) {
    var index = feedbackChips.indexOf(option);
    feedbackChips[index].isSelected = value;

    feedbackChips.refresh();
  }

  onRatingChange(double value) {
    print(value.toString());
    rating.value = value;
    update();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}

class ChipOption {
  bool isSelected;
  String name;

  ChipOption({
    required this.isSelected,
    required this.name,
  });
}
