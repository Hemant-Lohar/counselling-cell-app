import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
class Call extends StatefulWidget {
  const Call({Key? key}) : super(key: key);


  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Session in Progress"),
          leading: const BackButton(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: buildMeetConfig(),
        ),
      );


  }

  Widget buildMeetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "Server URL",
          //   controller: serverText,
          //   hintText: "Hint: Leave empty for meet.jitsi.si",
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Room", controller: roomText),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Subject", controller: subjectText),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Token", controller: tokenText),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Display Name",
          //   controller: userDisplayNameText,
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Email",
          //   controller: userEmailText,
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Avatar URL",
          //   controller: userAvatarUrlText,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Audio Muted"),
          //   value: isAudioMuted,
          //   onChanged: _onAudioMutedChanged,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Audio Only"),
          //   value: isAudioOnly,
          //   onChanged: _onAudioOnlyChanged,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Video Muted"),
          //   value: isVideoMuted,
          //   onChanged: _onVideoMutedChanged,
          // ),
          // const Divider(height: 48.0, thickness: 2.0),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                // if(kIsWeb){
                  // html.window.open("https://meet.jit.si/CounsellingCell", "Ongoing Session");
                // }
                // else{
                  _joinMeeting();
                // }
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  _joinMeeting() async {

    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isConferenceTimerEnabled: false,
      FeatureFlag.isCalendarEnabled: false,
      FeatureFlag.isAddPeopleEnabled: false,
      FeatureFlag.isCloseCaptionsEnabled: false,
      FeatureFlag.areSecurityOptionsEnabled: false,
      FeatureFlag.isNotificationsEnabled: false,
      FeatureFlag.isRaiseHandEnabled: false
    };
    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl:"CounsellingCell",
      subject: "Agenda",
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName:"counsellor",
      userEmail: "counsellor@gmail.com",
      featureFlags: featureFlags,
    );

    log("JitsiMeetingOptions: $options");
    try{
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => log("onOpened"),
          onConferenceWillJoin: (url) {
            log("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            log("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            log("onConferenceTerminated: url: $url, error: $error");
            JitsiMeetWrapper.hangUp();
          },
          onAudioMutedChanged: (isMuted) {
            log("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            log("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            log(
              "onScreenShareToggled: participantId: $participantId, "
                  "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            log(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
                  "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            log("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            log(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                  "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            log(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
                  "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => log("onChatToggled: isOpen: $isOpen"),
          onClosed: () => log("onClosed"),
        ),
      );
    }
    catch(error){
      log(error.toString());
    }

  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText),
    );
  }


}
