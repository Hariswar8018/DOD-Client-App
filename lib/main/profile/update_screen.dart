import 'package:dio/dio.dart';
import 'package:dod/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api.dart';

class Update extends StatefulWidget {

  final String name,email; bool isemail;

   Update({super.key,required this.email,required this.name,required this.isemail});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Global.black,
        automaticallyImplyLeading:true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Update ${widget.isemail?"Your Email Address":"Your Name"}",style: TextStyle(color: Colors.white,),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          on?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 100,),
          Text("     ${widget.isemail?"Your Email Address":"Your Name"}",style: TextStyle(color: Color(0xff252520),fontSize: 19,fontWeight: FontWeight.w800),),
          SizedBox(height: 10,),
          Center(
            child: Container(
              width: w-40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800
                    ),
                    hintText: widget.isemail?"Your New Email Address":"Your New Name",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            setState(() {
              on=true;
            });
            Dio dio = Dio();
            try {
              print("------------------------------------------------>");
              final response = await dio.post(
                  Api.apiurl + "profile-update",
                  data: {
                    "name":controller.text,
                    "email": "num${FirebaseAuth.instance.currentUser!
                        .phoneNumber}@gmail.com",
                    "mobile": "${FirebaseAuth.instance.currentUser!
                        .phoneNumber}",
                  },
                options: Options(
                  headers: {
                    "Authorization": "Bearer ${Api.token}",
                  },
                ),
              );
              print(response);
              if (response.statusCode == 201) {
                Send.message(
                    context, "Success", true);
                setState(() {
                  on=false;
                });
              } else {
                Send.message(
                    context, "Error ${response.statusMessage}", false);
                setState(() {
                  on=false;
                });
              }
            }catch(e){
              print(e);
              Send.message(
                  context, "Error ${e}", false);
              setState(() {
                on=false;
              });
            }
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
              color:  Global.black
            ),
            child: Center(child: Text("Update",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),)),
          ),
        )
      ],
    );
  }

  bool on = false;
}
