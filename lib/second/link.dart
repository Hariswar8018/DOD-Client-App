import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  String link;String str;
   Link({super.key,required this.link,required this.str});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("$str",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
    );
  }
}
