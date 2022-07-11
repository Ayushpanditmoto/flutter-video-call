import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:videocall/models/meeting_details.dart';

import '../api/meeting_api.dart';
import 'joinscreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting App'),
          backgroundColor: Colors.blueAccent[700],
        ),
        body: Form(
          child: formUI(),
          key: globalKey,
        ));
  }

  formUI() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Welcome to WebRTC Meeting App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 50,
            child: FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "Enter Your Meeting ID",
              (val) {
                if (val.isEmpty) {
                  return "Meeting ID is required";
                }
                return null;
              },
              (onSaved) {
                meetingId = onSaved;
              },
              borderRadius: 10,
              borderFocusColor: Colors.blueAccent,
              borderColor: Colors.blueAccent,
              hintColor: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FormHelper.submitButton("Join Meeting", () {
                  if (validateAndSave()) {
                    validateMeeting(meetingId);
                  }
                }),
              ),
              const SizedBox(
                width: 30,
              ),
              Flexible(
                child: FormHelper.submitButton("Start Meeting", () async {
                  var response = await startMeeting();
                  final body = json.decode(response!.body);
                  final meetId = body["data"];
                  validateMeeting(meetId);
                }),
              ),
            ],
          )
        ],
      ),
    ));
  }

  void validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetails.fromJson(data["data"]);
      goToJoinScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid Meeting Id", "OK", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetails meetingDetails) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(meetingDetails: meetingDetails),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
