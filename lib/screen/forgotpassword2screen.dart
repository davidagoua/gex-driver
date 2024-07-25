import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mealup_driver/apiservice/ApiHeader.dart';
import 'package:mealup_driver/apiservice/api_service.dart';
import 'package:mealup_driver/localization/lang_constant.dart';
import 'package:mealup_driver/localization/localization_constant.dart';
import 'package:mealup_driver/screen/login_screen.dart';
import 'package:mealup_driver/util/app_toolbar.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';
import 'package:mealup_driver/widget/app_lable_widget.dart';
import 'package:mealup_driver/widget/card_password_textfield.dart';
import 'package:mealup_driver/widget/hero_image_app_logo.dart';
import 'package:mealup_driver/widget/rounded_corner_app_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordNextScreen extends StatefulWidget {
  const ForgotPasswordNextScreen({this.driver_id});
  
  final int? driver_id;

  @override
  _ForgotPasswordNextScreen createState() => _ForgotPasswordNextScreen();
}

class _ForgotPasswordNextScreen extends State<ForgotPasswordNextScreen> {
  final _new_text_Password = TextEditingController();
  final _confirm_text_Password = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _passwordVisible = true;

  final _formKey = new GlobalKey<FormState>();
  // bool _autoValidate = false;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();

    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/back_img.png'),
          fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Constants.bgcolor,BlendMode.color)
        )),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: ApplicationToolbar(
            appbarTitle: getTranslated(context, LangConst.forgotpasswordlabel1).toString(),
          ),
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator:
                SpinKitFadingCircle(color: Constants.color_theme),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeroImage(),
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                            child: SvgPicture.asset(
                              'images/email.svg',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),
                                right: ScreenUtil().setWidth(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppLableWidget(
                                  title: getTranslated(context, LangConst.newpasswordlable).toString(),
                                ),
                                CardPasswordTextFieldWidget(
                                    textEditingController: _new_text_Password,
                                    validator: Constants.kvalidatePassword,
                                    hintText: getTranslated(context, LangConst.enternewpasswordlable).toString(),
                                    obscureText: _passwordVisible,
                                    suffixIcon: IconButton(
                                      icon: SvgPicture.asset(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? 'images/ic_eye_hide.svg'
                                            : 'images/ic_eye.svg',
                                        height: 15,
                                        width: 15,
                                        // color: Constants.color_hint,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                ),
                                AppLableWidget(
                                  title: getTranslated(context, LangConst.confirmpasslable).toString(),
                                ),
                                CardPasswordTextFieldWidget(
                                  textEditingController:
                                      _confirm_text_Password,
                                  validator: validateConfPassword,
                                  hintText: getTranslated(context, LangConst.enterpasswordlabel).toString(),
                                  obscureText: _passwordVisible,
                                  suffixIcon: IconButton(
                                    icon: SvgPicture.asset(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? 'images/ic_eye_hide.svg'
                                          : 'images/ic_eye.svg',
                                      height: 15,
                                      width: 15,
                                      // color: Constants.color_hint,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                RoundedCornerAppButton(
                                    btn_lable:
                                        getTranslated(context, LangConst.submitlable).toString(),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        Constants.CheckNetwork().whenComplete(
                                            () => CallChangePasswordApi(
                                                _new_text_Password.text,
                                                _confirm_text_Password.text,
                                                context));
                                      } 
                                      // else {
                                      //   setState(() {
                                      //     _autoValidate = true;
                                      //   });
                                      // }
                                    }),
                                SizedBox(
                                  height: ScreenUtil().setHeight(15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                            child: Text(
                              getTranslated(context, LangConst.checkemailotplable).toString(),
                              style: TextStyle(
                                color: Constants.color_gray,
                                fontSize: ScreenUtil().setSp(10),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String? validateConfPassword(String? value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return getTranslated(context, LangConst.passwordrequiredlable).toString();
    } else if (value.length < 6) {
      return getTranslated(context, LangConst.passwordsixcharlable).toString();
    } else if (_new_text_Password.text != _confirm_text_Password.text)
      return getTranslated(context, LangConst.passwordnotmatchlable).toString();
    else if (!regex.hasMatch(value))
      return getTranslated(context, LangConst.passwordrequiredlable).toString();
    else
      return null;
  }

  CallChangePasswordApi(
      String newpassword, String confirmpassword, BuildContext context) {
    setState(() {
      showSpinner = true;
    });

    RestClient(ApiHeader().dioData())
        .driverForgotPassword(
            newpassword, confirmpassword, widget.driver_id.toString())
        .then((response) {
      if (mounted) {
        print(response.toString());
        final body = json.decode(response!);

        bool? sucess = body['success'];
        print(sucess);

        if (sucess == true) {
          setState(() {
            showSpinner = false;
          });

          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Constants.color_theme);

          Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          setState(() {
            showSpinner = false;
          });

          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Constants.color_red);
        }
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text(getTranslated(context, LangConst.servererrorlable).toString()),
        backgroundColor: Constants.color_red,
      );
      Fluttertoast.showToast(msg: snackBar.toString());
      // _scaffoldKey.currentState!.showSnackBar(snackBar);
      setState(() {
        showSpinner = false;
      });
    });
  }
}
