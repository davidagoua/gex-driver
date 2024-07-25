import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:mealup_driver/apiservice/ApiHeader.dart';
import 'package:mealup_driver/apiservice/api_service.dart';
import 'package:mealup_driver/localization/lang_localizations.dart';
import 'package:mealup_driver/localization/localization_constant.dart';
import 'package:mealup_driver/screen/homescreen.dart';
import 'package:mealup_driver/screen/login_screen.dart';
import 'package:mealup_driver/screen/selectlocationscreen.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  await PreferenceUtils.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    debugPrint(PreferenceUtils.getString(Constants.currentLanguageCode));
    print(_locale != null ? _locale!.toString() : "Not Set");
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    print(PreferenceUtils.getString(Constants.currentLanguageCode));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    PreferenceUtils.putBool(Constants.isGlobalDriver, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
      theme: ThemeData(useMaterial3: false),
      title: 'Multi Language',
      locale: _locale,
      home: SplashScreen(),
      supportedLocales: [
        Locale(ENGLISH, 'US'),
        Locale(SPANISH, 'ES'),
        Locale(ARABIC, 'AE'),
//*     Uncomment Below Code If you are adding new language
//      Locale(YOUR_LANGUAGE, 'LANGUAGE_CODE'),                    
      ],
      localizationsDelegates: [
        LanguageLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(milliseconds: 1500);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
      if (PreferenceUtils.getverify(Constants.isverified) == true) {
        if (PreferenceUtils.getString(Constants.driverdeliveryzoneid)
                .toString() ==
            "0") {
          print("doc true");

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SelectLocation()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(initalindex: 0)),
              (route) => false);
        }
      } else {
        //go to verify
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }
    } else {
      // go to login
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    PreferenceUtils.getBool(Constants.disclaimer) == true
        ? checkforpermission()
        : startTime();
  }

  void checkforpermission() async {
    final Location location = Location();
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    } else if (_permissionGranted == PermissionStatus.granted) {
      startTime();
      return;
    }
    Constants.currentlatlong()
        .whenComplete(() => Constants.currentlatlong().then((value) {
              print("origin123:$value");
              startTime();
            }));
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenheight = MediaQuery.of(context).size.height;

    dynamic screenwidth = MediaQuery.of(context).size.width;

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (BuildContext context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new SafeArea(
          child: Scaffold(
            body: new Container(
              width: screenwidth,
              height: screenheight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/back_img.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Constants.bgcolor, BlendMode.color))),
              alignment: Alignment.center,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "images/splash_logo.png",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void callApiForSetting() {
    RestClient(ApiHeader().dioData()).driverSetting().then((response) {
      if (response.success == true) {
        PreferenceUtils.setString(
            Constants.driversetvehicaltype, response.data!.driverVehicalType!);
        PreferenceUtils.setString(Constants.driver_auto_refrese,
            response.data!.driverAutoRefrese.toString());
        PreferenceUtils.setString(
            Constants.one_signal_app_id, response.data!.driverAppId.toString());
        PreferenceUtils.setString(
            Constants.cancel_reason, response.data!.cancelReason!);
        response.data!.currency != null
            ? PreferenceUtils.setString(
                Constants.currency, response.data!.currency!)
            : PreferenceUtils.setString(Constants.currency, 'USD');
        response.data!.currency_symbol != null
            ? PreferenceUtils.setString(
                Constants.currencySymbol, response.data!.currency_symbol!)
            : PreferenceUtils.setString(Constants.currencySymbol, '\$');

        // if (PreferenceUtils
        //     .getString(Constants.one_signal_app_id)
        //     .isNotEmpty) {
        //   getDeviceToken(PreferenceUtils.getString(Constants.one_signal_app_id));
        // }
      }
      navigationPage();
    }).catchError((obj) {
      print(obj.runtimeType);

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
