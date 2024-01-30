import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/api/websockets/websocket_provider.dart';
import 'package:flutter_getx_boilerplate/models/response/users_response.dart';
import 'package:flutter_getx_boilerplate/modules/home/home.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CallState { idle, calling, fullOperator, videoCall, failed }

class HomeController extends GetxController {
  final ApiRepository apiRepository;
  HomeController({required this.apiRepository});

  var currentTab = MainTabs.home.obs;
  var users = Rxn<UsersResponse>();
  var user = Rxn<Datum>();
  Timer timer = Timer.new(
    Duration(seconds: 0),
    () => '',
  );
  Rx<CallState> callState = CallState.idle.obs;
  var isCalling = false.obs;
  var currentTime = ''.obs;
  var count = 0.obs;

  late ScrollController faqController;

  late TextEditingController faqSearchController;

  late MainTab mainTab;
  late DiscoverTab discoverTab;
  late ResourceTab resourceTab;
  late InboxTab inboxTab;
  late MeTab meTab;

  late String role;

  final websocketProvider = Get.find<WebsocketProvider>();

  @override
  void onInit() async {
    super.onInit();

    mainTab = MainTab();
    late var client;
    // loadUsers();

    role = (Get.arguments as List).first;

    if (role == 'client') {
      client = DeviceRequest(
        type: 'new',
        data: DeviceData(
            id: WebsocketProvider.clientDeviceId,
            station: 'Senayan',
            name: 'Testing Saja',
            role: 'Client',
            userAgent: "android"),
      );
    } else {
      client = DeviceRequest(
        type: 'new',
        data: DeviceData(
            id: WebsocketProvider.operatorDefaultId,
            station: 'Senayan',
            name: 'Testing Saja',
            role: 'Operator',
            userAgent: "android"),
      );
    }

    await websocketProvider.init(client);

    discoverTab = DiscoverTab();
    resourceTab = ResourceTab();
    inboxTab = InboxTab();
    meTab = MeTab();

    faqController = ScrollController();
    faqSearchController = TextEditingController();

    count.listen((p0) {
      if (p0 == 300) {
        callState.value = CallState.fullOperator;
      }
      if (p0 == 360) {
        callState.value = CallState.videoCall;
        Get.toNamed(
          Routes.VIDCALL,
          arguments: [timer, currentTime],
        );
      }
    });
  }

  @override
  onClose() async {
    super.onClose();
    timer.cancel();
  }

  endCall() {
    count.value = 0;
    callState.value = CallState.idle;
    currentTime.value = '00:00';
    isCalling.value = false;
    timer.cancel();
  }

  setCall() async {
    callState.value = CallState.calling;

    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        count++;
        var minutes = (count / 60).floor();
        var seconds = count % 60;

        var parsedMinutes = minutes < 10 ? '0$minutes' : minutes.toString();
        var parsedSeconds = seconds < 10 ? '0$seconds' : seconds.toString();
        currentTime.value = '$parsedMinutes:$parsedSeconds';
      },
    );
    await websocketProvider.initiateCall();
    isCalling.value = true;
  }

  void signout() {
    var prefs = Get.find<SharedPreferences>();
    prefs.clear();

    // Get.back();
    NavigatorHelper.popLastScreens(popCount: 2);
  }

  void _saveUserInfo(UsersResponse users) {
    var random = new Random();
    var index = random.nextInt(users.data!.length);
    user.value = users.data![index];
    var prefs = Get.find<SharedPreferences>();
    prefs.setString(StorageConstants.userInfo, users.data![index].toRawJson());
  }

  void switchTab(index) {
    var tab = _getCurrentTab(index);
    currentTab.value = tab;
  }

  int getCurrentIndex(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return 0;
      case MainTabs.discover:
        return 1;
      case MainTabs.resource:
        return 2;
      case MainTabs.inbox:
        return 3;
      case MainTabs.me:
        return 4;
      default:
        return 0;
    }
  }

  String get descriptionStatus {
    switch (callState.value) {
      case CallState.idle:
        return '';
      case CallState.calling:
        return 'Menghubungkan';
      case CallState.fullOperator:
        return 'Menunggu Operator';
      case CallState.videoCall:
        return 'Video Call';
      case CallState.failed:
        return 'Gagal Menghubungkan';
    }
  }

  MainTabs _getCurrentTab(int index) {
    switch (index) {
      case 0:
        return MainTabs.home;
      case 1:
        return MainTabs.discover;
      case 2:
        return MainTabs.resource;
      case 3:
        return MainTabs.inbox;
      case 4:
        return MainTabs.me;
      default:
        return MainTabs.home;
    }
  }
}
