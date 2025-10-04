import 'package:flutter/material.dart';

import '../../global.dart' show Global;

class ReturnInstruction extends StatefulWidget {
  const ReturnInstruction({super.key});

  @override
  State<ReturnInstruction> createState() => _ReturnInstructionState();
}

class _ReturnInstructionState extends State<ReturnInstruction> {

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
        title: Text("Add Driver Instructions ( Optional ) ",style: TextStyle(color: Colors.white,),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          on?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 100,),
          Text("     Instruction",style: TextStyle(color: Color(0xff252520),fontSize: 19,fontWeight: FontWeight.w800),),
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
                  minLines: 4,maxLines: 10,
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
                    hintText:"Write Instruction",
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
            Navigator.pop(context,controller.text);
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
                color:  Global.black
            ),
            child: Center(child: Text("Confirm Instruction",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),)),
          ),
        )
      ],
    );
  }

  bool on = false;
}
