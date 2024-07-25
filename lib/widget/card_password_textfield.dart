import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:mealup_driver/util/constants.dart';

// class CardPasswordTextFieldWidget extends StatefulWidget {
//   CardPasswordTextFieldWidget(
//       {required this.hintText,
//       required this.isPasswordVisible,
//       this.textEditingController,
//       this.validator,
//       this.readOnly});

//   final String hintText;
//   bool isPasswordVisible;
//   final Function? validator;
//   final bool? readOnly;
//   final TextEditingController? textEditingController;

//   @override
//   _CardTextFieldWidgetState createState() => _CardTextFieldWidgetState();
// }

// class _CardTextFieldWidgetState extends State<CardPasswordTextFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Constants.light_black,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 3.0,
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 25.0,
//         ),
//         child: TextFormField(
//           validator: widget.validator as String? Function(String?)?,
//           controller: widget.textEditingController,
//           obscureText: widget.isPasswordVisible,
//           readOnly: widget.readOnly ?? false,
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontFamily: Constants.app_font_bold),
//           decoration: InputDecoration(
//               hintStyle: TextStyle(color: Constants.color_hint),
//               hintText: widget.hintText,
//               suffixIcon: IconButton(
//                   icon: SvgPicture.asset(
//                     // Based on passwordVisible state choose the icon
//                     widget.isPasswordVisible
//                         ? 'images/ic_eye_hide.svg'
//                         : 'images/ic_eye.svg',
//                     height: 15,
//                     width: 15,
//                     color: Constants.color_hint,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       widget.isPasswordVisible = !widget.isPasswordVisible;
//                     });
//                   }),
//               errorStyle: TextStyle(
//                   fontFamily: Constants.app_font_bold, color: Colors.red),
//               border: InputBorder.none),
//         ),
//       ),
//     );
//   }
// }

class CardPasswordTextFieldWidget extends StatelessWidget {
  const CardPasswordTextFieldWidget({
    super.key, 
    required this.hintText, 
    this.validator, 
    this.readOnly, 
    required this.textEditingController, 
    this.suffixIcon, 
    this.obscureText,
  });

  final String hintText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final TextEditingController? textEditingController;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constants.light_black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
        ),
        child: TextFormField(
          validator: validator,
          controller: textEditingController,
          obscureText: obscureText ?? false,
          readOnly: readOnly ?? false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: Constants.app_font_bold,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Constants.color_hint),
            hintText: hintText,
            suffixIcon: suffixIcon,
            errorStyle: TextStyle(
              fontFamily: Constants.app_font_bold, 
              color: Colors.red,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
