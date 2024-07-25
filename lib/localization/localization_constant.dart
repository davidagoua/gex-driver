import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealup_driver/localization/lang_localizations.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';

String? getTranslated(BuildContext context, String key) {
  return LanguageLocalization.of(context)!.getTranslateValue(key);
}

const String ENGLISH = "en";
const String ARABIC = "ar";
const String SPANISH = "es";

//* TO ADD NEW LANGUAGE
//* For Example To add new language to your application, add new line, like this:
//* const String LANGUAGE_NAME = "LANGUAGE_CODE";

Future<Locale> setLocale(String languageCode) async {
  PreferenceUtils.setString(Constants.currentLanguageCode, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case ARABIC:
      _temp = Locale(languageCode, 'AE');
      break;
    case SPANISH:
      _temp = Locale(languageCode, 'ES');
      break;

//*  Uncomment Below Code If You Have Added New Language, And Replace
//*  LANGUGE_NAME and LANGUAGE_CODE With YOUR LANGUAGE_NAME and LANGUAGE_CODE
//    case LANGUAGE_NAME:
//      temp = Locale(languageCode, 'LANGUAGE_CODE');
//      break;


    
    default:
      _temp = Locale(ENGLISH, 'US');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  String? languageCode = PreferenceUtils.getString(Constants.currentLanguageCode);
  return _locale(languageCode);
}
