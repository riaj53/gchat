import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gchat/home_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPControlarScreen extends StatefulWidget {
  final phone;
  final codeDigit;
  const OTPControlarScreen(
      {Key? key, required this.phone, required this.codeDigit})
      : super(key: key);

  @override
  State<OTPControlarScreen> createState() => _OTPControlarScreenState();
}

class _OTPControlarScreenState extends State<OTPControlarScreen> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeControlar = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();
  String? verificationCode;
  final BoxDecoration pinOTPDecoration = BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.green));
  @override
  void initState() {
    super.initState();
    verifyPhonenumber();
  }

  verifyPhonenumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.codeDigit + widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ));
        },
        codeSent: (String vId, int? resendToken) {
          setState(() {
            verificationCode = vId;
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          setState(
            () {
              verificationCode = vId;
            },
          );
        },
        timeout: Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      key: _scaffolkey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhonenumber();
                },
                child: Text(
                  'Verify:${widget.codeDigit}-${widget.phone}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(fontSize: 25, color: Colors.green),
              eachFieldHeight: 55,
              eachFieldWidth: 40,
              focusNode: _pinOTPFocus,
              controller: _pinOTPCodeControlar,
              selectedFieldDecoration: pinOTPDecoration,
              submittedFieldDecoration: pinOTPDecoration,
              followingFieldDecoration: pinOTPDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode!, smsCode: pin))
                      .then((value) {
                    if (value.user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                  });
                } catch (e) {
                  Focus.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Invalit OTP'),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
