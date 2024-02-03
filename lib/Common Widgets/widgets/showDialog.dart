import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowDialog{
  Future<void> dialogWithButtons(BuildContext context,String message, VoidCallback callBackFunc){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title:  Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actionsPadding:
          EdgeInsets.symmetric(horizontal: 10),
          actions: <Widget>[
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    callBackFunc();
                  },
                  child: Container(
                    height: 44.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Color(0xffE6E6E6),
                      borderRadius:
                      BorderRadius.circular(15.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff373737),
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 44.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      borderRadius:
                      BorderRadius.circular(15.0),
                    ),
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff373737),
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }

  Future<void> generalMessageDialog(BuildContext context,String message,String subTitle, VoidCallback callBackFunc){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title:  Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actionsPadding:
          EdgeInsets.symmetric(horizontal: 10),
          content:   Text(subTitle, style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Color(0xff2d2d2d),
            // height: 92/16,
          ),),
        );
      },
    );
  }



}