import 'package:flutter/services.dart';
import 'package:gr_zoom/gr_zoom_platform_interface.dart';

class MethodChannelZoom extends ZoomPlatform {
  final MethodChannel channel = MethodChannel('plugins.webcare/zoom_channel');

  /// The event channel used to interact with the native platform.
  final EventChannel eventChannel =
      EventChannel('plugins.webcare/zoom_event_stream');
  @override
  Future<List> initZoom(ZoomOptions options) async {
    var optionMap = new Map<String, String>();
    if (options.appKey != null) {
      optionMap.putIfAbsent("appKey", () => options.appKey!);
    }
    if (options.appSecret != null) {
      optionMap.putIfAbsent("appSecret", () => options.appSecret!);
    }
    if (options.jwtToken != null) {
      optionMap.putIfAbsent("jwtToken", () => options.jwtToken!);
    }
    if (options.disableInviteUrl != null) {
      optionMap.putIfAbsent(
          "disableInviteUrl", () => options.disableInviteUrl!);
    }
    optionMap.putIfAbsent("domain", () => options.domain);
    optionMap.putIfAbsent(
      'disableScreenshotAndRecording',
      () => options.disableScreenshotAndRecording.toString(),
    );

    return channel
        .invokeMethod<List>('init', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  @override
  Future<bool> startMeeting(ZoomMeetingOptions options) async {
    assert(options.zoomAccessToken != null);
    assert(options.displayName != null);
    var optionMap = new Map<String, String>();
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("displayName", () => options.displayName!);
    optionMap.putIfAbsent("meetingId", () => options.meetingId);
    optionMap.putIfAbsent("meetingPassword", () => options.meetingPassword);
    // optionMap.putIfAbsent("zoomToken", () => options.zoomToken);
    optionMap.putIfAbsent("zoomAccessToken", () => options.zoomAccessToken!);
    optionMap.putIfAbsent("disableDialIn", () => options.disableDialIn);
    optionMap.putIfAbsent("disableDrive", () => options.disableDrive);
    optionMap.putIfAbsent("disableInvite", () => options.disableInvite);
    optionMap.putIfAbsent("disableShare", () => options.disableShare);
    optionMap.putIfAbsent("noDisconnectAudio", () => options.noDisconnectAudio);
    optionMap.putIfAbsent("noAudio", () => options.noAudio);
    if (options.meetingViewOptions != null) {
      optionMap.putIfAbsent(
          "meetingViewOptions", () => options.meetingViewOptions!.toString());
    }

    return channel
        .invokeMethod<bool>('start', optionMap)
        .then<bool>((bool? value) => value ?? false);
  }

  @override
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    var optionMap = new Map<String, String>();
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("meetingId", () => options.meetingId);
    optionMap.putIfAbsent("meetingPassword", () => options.meetingPassword);
    optionMap.putIfAbsent("disableDialIn", () => options.disableDialIn);
    optionMap.putIfAbsent("disableDrive", () => options.disableDrive);
    optionMap.putIfAbsent("disableInvite", () => options.disableInvite);
    optionMap.putIfAbsent("disableShare", () => options.disableShare);
    optionMap.putIfAbsent("noDisconnectAudio", () => options.noDisconnectAudio);
    optionMap.putIfAbsent("noAudio", () => options.noAudio);
    if (options.meetingViewOptions != null) {
      optionMap.putIfAbsent(
          "meetingViewOptions", () => options.meetingViewOptions!.toString());
    }

    return channel
        .invokeMethod<bool>('join', optionMap)
        .then<bool>((bool? value) => value ?? false);
  }

  @override
  Future<List> meetingStatus(String meetingId) async {
    var optionMap = new Map<String, String>();
    optionMap.putIfAbsent("meetingId", () => meetingId);

    return channel
        .invokeMethod<List>('meeting_status', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  @override
  Stream<dynamic> onMeetingStatus() {
    return eventChannel.receiveBroadcastStream();
  }
}
