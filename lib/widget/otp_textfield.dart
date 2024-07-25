import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealup_driver/util/constants.dart';

class OTPTextField extends StatelessWidget {
  const OTPTextField({
    super.key,
    required this.editingController,
    required this.textInputAction,
    required this.focus,
  });
  
  
  final TextEditingController editingController;
  final TextInputAction textInputAction;
  final Function focus;



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(70),
        // width: 35,
        height: ScreenUtil().setHeight(70),
        alignment: Alignment.center,
        margin: EdgeInsets.all(2.0),
        child: Card(
          color: Constants.light_black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2.0,
          child: Center(
            child: TextFormField(
              onFieldSubmitted: focus as void Function(String)?,
              controller: editingController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: textInputAction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (str) {
                if (str.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              style: TextStyle(
                  fontFamily: Constants.app_font,
                  fontSize: ScreenUtil().setSp(25),
                  color: Constants.color_gray),
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Constants.color_hint,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
    // );
  }
}
