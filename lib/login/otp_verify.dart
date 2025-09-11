import 'dart:async';

import 'package:dod/global.dart';
import 'package:dod/main.dart';
import 'package:dod/main/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart' show SmartAuth;

class OTP_Verify extends StatefulWidget {
  final String phone;
   OTP_Verify({super.key,required this.phone});

  @override
  State<OTP_Verify> createState() => _OTP_VerifyState();
}

class _OTP_VerifyState extends State<OTP_Verify> {
  late Timer _timer;
  int _start = 60;

  void initState(){
    startTimer();
    super.initState();
    // On web, disable the browser's context menu since this example uses a custom
    // Flutter-rendered context menu.
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    pinController = TextEditingController();
    focusNode = FocusNode();


  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
    super.dispose();
  }
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Center(child: Text("Back",style: TextStyle(color: Colors.grey.shade200),))),
        title: Text("VERIFY NUMBER",style: TextStyle(color: Colors.grey.shade200),
        ),
        actions: [
          InkWell(
              onTap: (){
                print(pinController.text);
                if(pinController.text=="222222"){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>MyHomePage(title: "")));
                }else{
                  Send.message(context, "Wrong Pin", false);
                }
              },
              child: Text("Next",style: TextStyle(color: Colors.grey.shade200),)),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Container(
            width: w,
            height: 0.2,
            color: Colors.white,
          ),
          SizedBox(height: 35,),
          Center(
            child: Text("Enter the OTP sent to",style: TextStyle(color: Colors.grey.shade200),),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text("+91-${widget.phone}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 23),),
            ),
          ),
          SizedBox(height: 10,),
          Pinput(
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: (s) {
              return s == '222222' ? null : 'Pin is incorrect';
            },
            enableInteractiveSelection: true,
            controller: pinController,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,length: 6,
            onChanged: (pin)=>(){
              print(pin);
              if(pin=="222222"){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Navigation()));
              }else{
                Send.message(context, "Wrong Pin", false);
              }
            },
            onCompleted: (pin) => (){
              print(pin);
              if(pin=="222222"){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Navigation()));
              }else{
                Send.message(context, "Wrong Pin", false);
              }
            },
          ),
          SizedBox(height: 30,),
          Center(
            child: Text("Didn't get Sms?",style: TextStyle(color: Colors.grey.shade200),),
          ),SizedBox(height: 15,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
                width: 1
              )
            ),
            child: _start==0?InkWell(
              onTap: (){
                setState(() {
                  _start = 120;
                  startTimer();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0,vertical: 10),
                child: Text("RESEND A NEW OTP",style: TextStyle(fontSize:17,color: Colors.white,fontWeight: FontWeight.w700),),
              ),
            ):Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0,vertical: 10),
              child: Text("GET A NEW OTP IN : ${_start}",style: TextStyle(fontSize:17,color: Colors.white,fontWeight: FontWeight.w700),),
            ),
          )
        ],
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 49,
    height: 49,
    textStyle: TextStyle(fontSize: 18, color: Colors.greenAccent, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme =PinTheme(
    width: 49,
    height: 49,
    textStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final submittedPinTheme = PinTheme(
    width: 49,
    height: 49,
    textStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

}
