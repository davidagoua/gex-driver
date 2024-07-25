import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:mealup_driver/apiservice/ApiHeader.dart';
import 'package:mealup_driver/apiservice/api_service.dart';
import 'package:mealup_driver/localization/lang_constant.dart';
import 'package:mealup_driver/localization/localization_constant.dart';
// import 'package:mealup_driver/screen/myprofilescreen.dart';
// import 'package:mealup_driver/screen/notificationlist.dart';
// import 'package:mealup_driver/screen/orderlistscreen.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';

import '../widget/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.initalindex});

  final int? initalindex;

  @override
  _HomeScreen createState() =>  _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String name = "User";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    setState(() {
      Constants.CheckNetwork().whenComplete(() => callApiForsetting());
    });
  }

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
       GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child:  SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/background_image.png'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          // resizeToAvoidBottomPadding: true,
          key: _drawerscaffoldkey,
          bottomNavigationBar: BottomNavBar(index: widget.initalindex ?? 0),
        ),
      )),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title:  Text(getTranslated(context, LangConst.areyousurelable).toString()),
        content:  Text(getTranslated(context, LangConst.wanttoexitlable).toString()),
        actions: <Widget>[
           GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(getTranslated(context, LangConst.nolable).toString()),
          ),
          SizedBox(height: 16),
           GestureDetector(
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text(getTranslated(context, LangConst.yeslable).toString()),
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  void callApiForsetting() {
    RestClient(ApiHeader().dioData()).driverSetting().then((response) {
      if (response.success == true) {
        if (response.data!.globalDriver == "true") {
          setState(() {
            PreferenceUtils.putBool(Constants.isGlobalDriver, true);
          });
        }

        response.data!.driverAutoRefrese != null
            ? PreferenceUtils.setString(Constants.driver_auto_refrese,
                response.data!.driverAutoRefrese.toString())
            : PreferenceUtils.setString(Constants.driver_auto_refrese, '');

        response.data!.driverAppId != null
            ? PreferenceUtils.setString(Constants.one_signal_app_id,
                response.data!.driverAppId.toString())
            : PreferenceUtils.setString(Constants.one_signal_app_id, '');

        response.data!.cancelReason != null
            ? PreferenceUtils.setString(
                Constants.cancel_reason, response.data!.cancelReason.toString())
            : PreferenceUtils.setString(Constants.cancel_reason, '');

        response.data!.currency != null
            ? PreferenceUtils.setString(
                Constants.currency, response.data!.currency!)
            : PreferenceUtils.setString(Constants.currency, 'USD');
        response.data!.currency_symbol != null
            ? PreferenceUtils.setString(
                Constants.currencySymbol, response.data!.currency_symbol!)
            : PreferenceUtils.setString(Constants.currencySymbol, '\$');
      }
      else {}
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioException:
          final res = (obj as DioException).response!;
          print(res);

          var responsecode = res.statusCode;

          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
          }
          break;
        default:
      }
    });
  }
}