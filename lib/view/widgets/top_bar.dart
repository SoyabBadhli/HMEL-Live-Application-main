import 'package:flutter/material.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/screens/pend_comp.dart';

class TopBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? route;
  final Widget titleText;
  const TopBar(
      {Key? key,
      required this.scaffoldKey,
      this.route,
      required this.titleText})
      : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: const BoxDecoration(
          // color: AppColors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Home(
                //               isDeviceConnected: true,
                //             )),
                //     ModalRoute.withName(AppStrings.routeToHome));
              },
              icon: Icon(Icons.arrow_back_ios)),
          widget.titleText,
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const PendComp()),
                  ModalRoute.withName(AppStrings.routeToPendComp));
            },
            child: Container(
                height: 70,
                width: 150,
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/images/hmel_logo.png",
                  fit: BoxFit.contain,
                )),
          ),
        ],
      ),
    );
  }
}
