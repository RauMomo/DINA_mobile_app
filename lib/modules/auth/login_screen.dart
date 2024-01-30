import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/dropdown_field.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/mrt_bg.png',
            height: Get.height * 1,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox.shrink(),
            ),
            body: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 35.0),
              child: _buildForms(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForms(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Get.window.physicalSize.height > 320.0
          ? _fullScreenForm(context)
          : _scrollForm(context),
    );
  }

  _fullScreenForm(context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(
            flex: 2,
          ),
          Expanded(
            child: Image.asset('assets/images/mrt_main_logo.png'),
          ),
          Spacer(
            flex: 1,
          ),
          DropdownField(
            onChanged: (p0) {
              controller.selectedRole.value = p0!;
            },
            placeholder: 'Device Name',
            labelText: 'Device Role',
            dropdownValue: controller.selectedRole.value,
          ),
          // DropdownButton<String>(
          //   menuMaxHeight: 200,
          //   items: [
          //     DropdownMenuItem(
          //       value: 'Operator',
          //       child: Text('Operator'),
          //     ),
          //     DropdownMenuItem(
          //       value: 'Client',
          //       child: Text('Client'),
          //     ),
          //   ],
          //   value: controller.selectedRole.value,
          //   onChanged: (value) {
          //     controller.selectedRole.value = value!;
          //   },
          // ),
          InputField(
            controller: controller.loginEmailController,
            keyboardType: TextInputType.text,
            labelText: 'Device Name',
            placeholder: 'Enter Device Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Device Name is Required';
              }
              return null;
            },
          ),
          CommonWidget.rowHeight(height: Get.context!.isTablet ? 24 : 12),
          BorderButton(
            text: 'Connect',
            backgroundColor: Colors.white,
            onPressed: () {
              controller.login(context);
            },
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  _scrollForm(context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(
            flex: 2,
          ),
          Expanded(
            child: Image.asset('assets/images/mrt_main_logo.png'),
          ),
          Spacer(
            flex: 1,
          ),
          // InputField(
          //   controller: controller.loginEmailController,
          //   keyboardType: TextInputType.text,
          //   labelText: 'Server Link',
          //   placeholder: 'Enter Email Address',
          //   validator: (value) {
          //     if (!Regex.isEmail(value!)) {
          //       return 'Email format error.';
          //     }

          //     if (value.isEmpty) {
          //       return 'Email is required.';
          //     }
          //     return null;
          //   },
          // ),
          DropdownButton<String>(
            items: [
              DropdownMenuItem(
                child: Text('Operator'),
              ),
              DropdownMenuItem(
                child: Text('Client'),
              ),
            ],
            value: controller.selectedRole.value,
            onChanged: (value) {
              controller.selectedRole.value = value!;
            },
          ),
          InputField(
            controller: controller.loginEmailController,
            keyboardType: TextInputType.text,
            labelText: 'Device Name',
            placeholder: 'Enter Device Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Device Name is Required';
              }
              return null;
            },
          ),
          CommonWidget.rowHeight(height: context.isTablet ? 24 : 12),
          BorderButton(
            text: 'Connect',
            backgroundColor: Colors.white,
            onPressed: () {
              controller.login(context);
            },
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
