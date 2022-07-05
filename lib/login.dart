import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gchat/otp_controlar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController _controlar = TextEditingController();
String dialCodeDigit = "+88";

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
          ),
          SizedBox(
            width: 400,
            height: 60,
            child: CountryCodePicker(
              onChanged: (country) {
                setState(() {
                  dialCodeDigit = country.dialCode!;
                });
              },
              initialSelection: 'It',
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              favorite: ['+1', "US", '+88', "BD"],
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(dialCodeDigit),
                  )),
              maxLength: 11,
              keyboardType: TextInputType.number,
              controller: _controlar,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTPControlarScreen(
                          phone:_controlar.text,
                          codeDigit:dialCodeDigit,
                        )));
              },
              child: Text('Login')),
        ],
      )),
    );
  }
}
