// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketProvider {
  Rx<SignallingState> signallingState = SignallingState.idle.obs;
  final remoteVideoRenderer = RTCVideoRenderer();
  final localVideoRenderer = RTCVideoRenderer();
  Rx<RTCIceCandidate> sessionCandidate = RTCIceCandidate('', '', 0).obs;
  late RTCPeerConnection pc;
  late final IOWebSocketChannel channel;
  final wsUrl = Uri.parse("wss://textphone.jakartamrt.co.id:34208/ws");

  static final String clientDeviceId = "client_senayan_01";
  static final String operatorDefaultId = "operator_senayan_01";
  final RxString operatorDeviceId = "operator_senayan_01".obs;
  String currentRole = 'Client';
  var sdp = '';

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": {}
  };

  Future<void> init(DeviceRequest device) async {
    await remoteVideoRenderer.initialize();
    await localVideoRenderer.initialize();
    await WebRTC.initialize();

    Map<String, dynamic> configuration = {
      "bundlePolicy": "balanced",
      "encodedInsertableStreams": false,
      "iceCandidatePoolSize": 0,
      "iceServers": [
        {
          "url": "turn:147.139.198.62:53208?transport=udp",
          "username": "siddiq",
          "credential": "12345"
        },
      ],
      "iceTransportPolicy": "all",
      "rtcpMuxPolicy": "require",
      "sdpSemantics": "unified-plan"
    };

    pc = await createPeerConnection(configuration);

    await _getUserMedia();

    // pc.addStream(localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        sessionCandidate.value = e;
        createCandidate(sessionCandidate.value);
      }
    };

    pc.onSignalingState = (state) {
      print('currentState:' + state.toString());
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddTrack = (stream, streamTrack) {
      print('addTrack: ' + stream.id);
      remoteVideoRenderer.srcObject = stream;
    };

    pc.onAddStream = (stream) {
      print('addStream:' + stream.id);
      remoteVideoRenderer.srcObject = stream;
      print('hah' + pc.getConfiguration.toString());
    };

    pc.onIceConnectionState = (RTCIceConnectionState state) {
      print('onConnectionState:' + state.name);
    };

    pc.onDataChannel = (channel) {
      channel.messageStream.listen((event) {
        print('onMessage: ' + event.text);
      });
    };

    await pc.transceivers.then((value) => print(value.toString()));

    HttpOverrides.global = MyHttpOverrides();
    final channel = WebSocketChannel.connect(wsUrl, protocols: ['UDP', 'TCP']);

    await channel.ready;

    var deviceData = device;
    currentRole = deviceData.data.role;

    print(
      'send device data:' + deviceData.toJson(),
    );

    channel.sink.add(
      deviceData.toJson(),
    );

    // var sdpRes = {
    //   "sdp": {
    //     "type": description.type,
    //     "sdp": description.sdp,
    //   },
    // };

    // print(
    //   'send sdp:' + sdpRes.toString(),
    // );
    // channel.sink.add(sdpRes);

    channel.stream.listen((event) {
      Map<String, dynamic> eventText = jsonDecode(event);
      print('response' + eventText.toString());
      if (eventText.containsKey('type')) {
        setSignallingState(eventText['type']);
      }
      if (signallingState.value == SignallingState.onPeersUpdate) {
        try {
          // if (eventText['data'] != null) {
          //   PeersResponse peersResponse = PeersResponse.fromJson(eventText);
          //   var operatorDevice = peersResponse.data.firstWhere(
          //       (element) => element.role.toLowerCase() == 'operator');

          //   operatorDeviceId.value = operatorDevice.id;
          // }
          print('onPeersUpdate - response:' + eventText.toString());
        } catch (e) {
          throw e;
        }
      } else if (signallingState.value == SignallingState.offer) {
        transformResponse(eventText);
      }
    }, onDone: () {
      print('stream sudah selesai karena masalah teknis');
    }, onError: (Object obj) {
      print(obj);
    });

    // operatorDeviceId.listen((p0) async {
    //   //create offer
    //   RTCSessionDescription description =
    //       await pc.createOffer(offerSdpConstraints);
    //   var session = parse(description.sdp.toString());
    //   print('session' + json.encode(session));
    //   await pc.setRemoteDescription(description);

    //   var descriptionResponse = {
    //     'sdp': description.sdp,
    //     'type': description.type
    //   };

    //   // // channel.sink.add(descriptionResponse);

    //   // // //create answer
    //   // // final answer = await pc
    //   // //     .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});

    //   //remote description
    //   final String sdp = description.sdp!;
    //   print('tambahin lagi devicenya');

    //   // print('offer' + offerData.toString());
    //   // channel.sink.add({
    //   //   "calleeId": operatorDeviceId.value,
    //   //   "sdpOffer": descriptionResponse
    //   // });

    //   //session candidate once candidate found
    //   sessionCandidate.listen((p0) {
    //     if (sessionCandidate.value.candidate!.isNotEmpty) {
    //       print('punya candidate');
    //       var candidateRequest = {
    //         "type": "candidate",
    //         "data": {
    //           "to": operatorDeviceId.value,
    //           "from": clientDeviceId,
    //           "candidate": {
    //             "sdpMLineIndex": sessionCandidate.value.sdpMLineIndex,
    //             "sdpMid": sessionCandidate.value.sdpMid,
    //             "candidate": sessionCandidate.value.candidate
    //           },
    //           "session_id": "{$clientDeviceId-$operatorDeviceId}"
    //         }
    //       };
    //       // print(
    //       //   'send candidate:' + candidateRequest.toString(),
    //       // );
    //       channel.sink.add(candidateRequest);
    //     }
    //   });
    // });
    // var offerData = {
    //   "type": "offer",
    //   "data": {
    //     "to": operatorDeviceId,
    //     "from": clientDeviceId,
    //     "description": {
    //       "sdp": jsonEncode(sdp),
    //     }
    //   }
    // };
    // channel.sink.add(offerData);
  }

  transformResponse(Map<String, dynamic> eventText) {
    signallingState.listen((p0) async {
      switch (p0) {
        case SignallingState.offer:
        default:
          sdp = eventText['data']['description']['sdp'];
          await pc.setRemoteDescription(
            RTCSessionDescription(sdp, 'offer'),
          );
      }
    });
  }

  initiateCall() async {
    if (currentRole == 'Client') {
      RTCSessionDescription offer = await pc.createOffer(offerSdpConstraints);
      var session = parse(offer.sdp.toString());
      print('session' + json.encode(session));
      await pc.setLocalDescription(offer);

      var offerRequest = {
        "type": "offer",
        "data": {
          "to": operatorDeviceId.value,
          "from": clientDeviceId,
          "description": {
            "sdp":
                "v=0\r\no=- 3172302167408813250 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=extmap-allow-mixed\r\na=msid-semantic: WMS\r\n",
          }
        }
      };

      print(session);

      final channel =
          WebSocketChannel.connect(wsUrl, protocols: ['UDP', 'TCP']);

      await channel.ready;

      try {
        channel.sink.add(offerRequest);
        print('created offer');
      } catch (e) {
        throw e;
      }
    }
  }

  createCandidate(RTCIceCandidate candidate) async {
    sessionCandidate.value = candidate;
    print('buat candidate');
    await pc.addCandidate(sessionCandidate.value);
    // channel.sink.add({
    //   'candidate': candidate.candidate.toString(),
    //   'sdpMid': candidate.sdpMid.toString(),
    //   'sdpMlineIndex': candidate.sdpMLineIndex,
    // });
  }

  setSignallingState(String type) {
    switch (type) {
      case 'idle':
        signallingState.value = SignallingState.idle;
        break;
      case 'peers':
        signallingState.value = SignallingState.onPeersUpdate;
        break;
      case 'ping':
        signallingState.value = SignallingState.onPing;
        break;
      case 'offer':
        signallingState.value = SignallingState.offer;
        break;
      case 'bye':
      default:
        signallingState.value = SignallingState.onCallStateChange;
    }
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    stream.getTracks().forEach((track) {
      pc.addTrack(track, stream);
    });

    localVideoRenderer.srcObject = stream;
  }
}

enum SignallingState {
  idle,
  offer,
  onPing,
  onCallStateChange,
  onPeersUpdate,
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

class DeviceRequest {
  String type;
  DeviceData data;
  DeviceRequest({
    required this.type,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'data': data.toMap(),
    };
  }

  factory DeviceRequest.fromMap(Map<String, dynamic> map) {
    return DeviceRequest(
      type: map['type'] as String,
      data: DeviceData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }
  String toJson() => json.encode(toMap());

  factory DeviceRequest.fromJson(String source) =>
      DeviceRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DeviceData {
  String station;
  String role;
  String name;
  String id;
  String userAgent;
  DeviceData({
    required this.station,
    required this.role,
    required this.name,
    required this.id,
    required this.userAgent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'station': station,
      'role': role,
      'name': name,
      'id': id,
      'user_agent': userAgent,
    };
  }

  factory DeviceData.fromMap(Map<String, dynamic> map) {
    return DeviceData(
      station: map['station'] as String,
      role: map['role'] as String,
      name: map['name'] as String,
      id: map['id'] as String,
      userAgent: map['user_agent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceData.fromJson(String source) =>
      DeviceData.fromMap(json.decode(source) as Map<String, dynamic>);
}
