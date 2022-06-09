import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/model/live_chat.dart';
import 'package:note_app_teachers/src/pages/call_controler.dart';
import 'package:note_app_teachers/src/pages/live_chat_item.dart';

import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallPage({Key? key, required this.channelName, required this.role})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  var _engine;

  CallController callController = Get.put(CallController());

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  UserService userService = Get.put(UserService());

  String currentNum = "";

  FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    // clear users
    callController.users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();

    getCurrentNumOfUser();
  }

  getCurrentNumOfUser() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("LiveStream")
        .child(widget.channelName)
        .child("numOfUser");

    ref.onValue.listen((event) {
      setState(() {
        currentNum = event.snapshot.value.toString();
      });
    });
  }

  speak(String text) async {
    var result = await flutterTts.speak(text);
    print(result);
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      
        callController.infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        callController.infoStrings.add('Agora Engine is not starting');
      
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(
        await getToken(widget.channelName), widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      
        final info = 'onError: $code';
        callController.infoStrings.add(info);
     
    }, joinChannelSuccess: (channel, uid, elapsed) {
      
        final info = 'onJoinChannel: $channel, uid: $uid';
        callController.infoStrings.add(info);
     
    }, leaveChannel: (stats) {
      
        callController.infoStrings.add('onLeaveChannel');
        callController.users.clear();
      
    }, userJoined: (uid, elapsed) {
      
        final info = 'userJoined: $uid';
        callController.infoStrings.add(info);
        callController.users.add(uid);
     
    }, userOffline: (uid, elapsed) {
      
        final info = 'userOffline: $uid';
        callController.infoStrings.add(info);
        callController.users.remove(uid);
      
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        callController.infoStrings.add(info);
      
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(const RtcLocalView.SurfaceView());
    }
    callController.users.forEach((int uid) =>
        list.add(RtcRemoteView.SurfaceView(channelId: "", uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  currentNum,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(()=>
             IconButton(
                onPressed: _onToggleMute,
                icon: Icon(
                  callController.muted.value ? Icons.mic_off : Icons.mic,
                  color: callController.muted.value ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: _onSwitchCamera,
              icon: const Icon(
                Icons.switch_camera,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(()=> IconButton(
                onPressed: _onSwitchChatEnabled,
                icon: Icon(
                  !callController.isChatEnabled.value
                      ? Icons.chat_bubble_outline_sharp
                      : Icons.chat_bubble,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () => _onCallEnd(context),
              icon: const Icon(
                FontAwesomeIcons.times,
                color: Colors.red,
                size: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return StreamBuilder(
        stream: ref.child("LiveStreamChat").child(widget.channelName).onValue,
        builder: (context, snapshot) {
          List<LiveChat> list = [];
          if (snapshot.hasData) {
            if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
              final map = Map<String, Object>.from(
                  (snapshot.data as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
              map.forEach((key, value) {
                final chatItem =
                    Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
                final LiveChat liveChat = LiveChat.fromFirebase(chatItem);
                list.add(liveChat);
              });
              list.sort(((a, b) => b.cid.compareTo(a.cid)));
              speak(list[0].text);
            }
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return LiveChatItem(liveChat: list[index]);
              },
            ),
          );
        });
  }

  void _onCallEnd(BuildContext context) async {
    userService.stopLive(widget.channelName);
    Navigator.pop(context);
  }

  void _onToggleMute() {
    
      callController.muted.value = !callController.muted.value;
  
    _engine.muteLocalAudioStream(callController.muted.value);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onSwitchChatEnabled() {
   
      callController.isChatEnabled.value = !callController.isChatEnabled.value;
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            Obx(()=>
              callController.isChatEnabled.value ? _panel() : const SizedBox(),
            ),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
