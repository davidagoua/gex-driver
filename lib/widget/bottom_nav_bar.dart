import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealup_driver/localization/lang_constant.dart';
import 'package:mealup_driver/localization/localization_constant.dart';
import 'package:mealup_driver/screen/myprofilescreen.dart';
import 'package:mealup_driver/screen/notificationlist.dart';
import 'package:mealup_driver/screen/orderlistscreen.dart';
import 'package:mealup_driver/util/constants.dart';
import 'package:mealup_driver/util/preferenceutils.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.index});

  int index;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}


class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _children = [
    OrderList(),
    NotificationList(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: _children[widget.index],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          selectedItemColor: Constants.color_theme,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
              color: Constants.color_theme,
              fontSize: 12,
              fontFamily: Constants.app_font),
          unselectedLabelStyle: TextStyle(
              color: Constants.whitetext,
              fontSize: 12,
              fontFamily: Constants.app_font),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constants.itembgcolor,
          currentIndex: widget.index,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset("images/orders.svg"),
                activeIcon: SvgPicture.asset("images/order_green.svg"),
                label: getTranslated(context, LangConst.orderslable).toString()),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("images/notification.svg"),
                activeIcon: SvgPicture.asset("images/notification_green.svg"),
                label: getTranslated(context, LangConst.notificationlable).toString()),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                      PreferenceUtils.getString(Constants.driverimage)),
                  backgroundColor: Colors.transparent,
                ),
                activeIcon: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                      PreferenceUtils.getString(Constants.driverimage)),
                  backgroundColor: Constants.color_theme,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Constants.color_theme),
                    ),
                  ),
                ),
                label: getTranslated(context, LangConst.profilelable).toString())
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      widget.index = index;
    });
  }
}
