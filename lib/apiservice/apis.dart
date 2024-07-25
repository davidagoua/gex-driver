// Class for api tags
class Apis {

  /// TODO Setup: Enter your base url here, Make sure you have added a "/" at the end of the URL
  /// Make sure wether you are using http or https
  /// Make sure wether you need /public/ in the base URL or not
  /// After changing here, also change in the [api_client.g.dart] file
  /// if that file doesn't exist, run the following command in the project terminal
  /// flutter pub run build_runner build --delete-conflicting-outputs
  /// Please don't remove "/api/driver/".
  static const String baseUrl = 'https://zone0.cloud/api/driver/';

  static const String login = 'driver_login';
  static const String register = 'driver_register';
  static const String checkOTP = 'driver_check_otp';
  static const String resendOTP = 'driver_resendOtp';
  static const String driverSetting = 'driver_setting';
  static const String updateDocument = 'update_document';
  static const String deliveryZone = 'delivery_zone';
  static const String setLocation = 'set_location';
  static const String updateDriver = 'update_driver';
  static const String driver = 'driver';
  static const String cashBalance = 'cash_balance';
  static const String updateDriverImage = 'update_driver_image';
  static const String deliveryPersonChangePassword = 'delivery_person_change_password';
  static const String earning = 'earning';
  static const String driverOrder = 'driver_order';
  static const String currentOrder = 'current_order';
  static const String orderHistory = 'order_history';
  static const String orderEarning = 'order_earning';
  static const String notification  = 'notification';
  static const String driverFaq  = 'driver_faq';
  static const String statusChange  = 'status_change';
  static const String updateLatLang  = 'update_lat_lang';
  static const String forgotPasswordOtp  = 'forgot_password_otp';
  static const String forgotPasswordCheckOtp  = 'forgot_password_check_otp';
  static const String forgotPassword  = 'forgot_password';
}