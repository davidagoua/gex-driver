import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealup_driver/localization/lang_constant.dart';
import 'package:mealup_driver/localization/language_class.dart';
import 'package:mealup_driver/localization/localization_constant.dart';
import 'package:mealup_driver/main.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  State<LanguagesScreen> createState() => _LanguagesScreen();
}

class _LanguagesScreen extends State<LanguagesScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> languageData = <String>[];

  bool arrowdown = true;
  bool arrowup = false;
  bool reason = false;
  int? value = 0;
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  int radioindex = 0;

  void changeIndex(int index) {
    setState(() {
      radioindex = index;
    });
  }

  BoxDecoration myBoxDecorationChecked(bool isBorder, Color color) {
    return BoxDecoration(
      color: color,
      border: isBorder ? Border.all(width: 1.0) : null,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    );
  }

  Widget getChecked() {
    return Container(
      width: 25,
      height: 25,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'images/ic_check.svg',
          width: 15,
          height: 15,
        ),
      ),
      decoration: myBoxDecorationChecked(false, Constants.color_theme),
    );
  }

  Widget getunChecked() {
    return Container(
      width: 25,
      height: 25,
      decoration: myBoxDecorationChecked(true, Constants.whitetext),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back_img.png'),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Constants.bgcolor, BlendMode.color))),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  getTranslated(context, LangConst.languagelable).toString(),
                  maxLines: 1,
                  style: TextStyle(
                    color: Constants.whitetext,
                    fontFamily: Constants.app_font_bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                automaticallyImplyLeading: true,
              ),
              body: new Stack(
                children: <Widget>[
                  new SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: Language.languageList().length,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                    onTap: () async {
                                      changeIndex(index);
                                      Locale local = await setLocale(
                                          Language.languageList()[index]
                                              .languageCode);
                                      setState(() {
                                        MyApp.setLocale(context, local);
                                        PreferenceUtils.setString(
                                            Constants.currentLanguageCode,
                                            Language.languageList()[index]
                                                .languageCode);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(20),
                                          bottom: ScreenUtil().setHeight(10),
                                          top: ScreenUtil().setHeight(20)),
                                      child: Row(
                                        children: [
                                          PreferenceUtils.getString(Constants
                                                              .currentLanguageCode) ==
                                                          'N/A' &&
                                                      index == 0 ||
                                                  PreferenceUtils.getString(
                                                          Constants
                                                              .currentLanguageCode) ==
                                                      Language.languageList()[
                                                              index]
                                                          .languageCode
                                              ? getChecked()
                                              : getunChecked(),
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: ScreenUtil().setWidth(10),
                                              ),
                                            child: Text(
                                              Language.languageList()[index]
                                                  .name,
                                              style: TextStyle(
                                                color: Constants.whitetext,
                                                fontFamily: Constants.app_font,
                                                fontWeight: FontWeight.w900,
                                                fontSize: ScreenUtil().setSp(14),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}