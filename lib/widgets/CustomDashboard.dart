import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDashboard extends StatelessWidget {

  String image;
  String title;
  String subTitle;
  String ?Url;

  void Function()? onTap;

  CustomDashboard({required this.image,required this.title,required this.subTitle, this.Url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0,5),
                  color: Colors.black45,
                  blurRadius: 5
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image!,height: 100,width:double.maxFinite,fit: BoxFit.fitWidth,),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text("$title",style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue.shade700),),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text("$subTitle",style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),),
            )
          ],
        ),
      ),
    );
  }
}
