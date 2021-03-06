import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:videocall/models/meeting_details.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetails? meetingDetails;

  const JoinScreen({Key? key, this.meetingDetails}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Meeting'),
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
          SizedBox(
            height: 20,
            child: FormHelper.inputFieldWidget(
              context,
              "userId",
              "Enter Your Name",
              (val) {
                if (val.isEmpty) {
                  return "Name is required";
                }
                return null;
              },
              (onSaved) {
                userName = onSaved;
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
                child: FormHelper.submitButton("Join", () {
                  if (validateAndSave()) {
                    //Meeting
                  }
                }),
              ),
            ],
          )
        ],
      ),
    ));
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
