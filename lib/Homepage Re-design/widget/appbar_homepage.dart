// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:warehouse/utils/utils.dart'; // Import your TokenUtil class here

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.formattedDate,
    required this.appVersion,
    required this.scaffoldKey,
  });

  final String formattedDate;
  final String appVersion;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
          // bottomRight: Radius.circular(100.0),
        ),
      ),
      backgroundColor: biruImran, //keep this to have the batery icon white
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              // bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [biruImran, colorFirst],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  }, icon: Icon(Icons.menu, size: 40, color: white,),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/logo_wmsAmastWhite.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width >= 800 ? 370 : 300,
                    ),
                    AutoSizeText(
                      'V $appVersion',
                      maxLines: 1,
                      style: TextStyle(color: greyColor2, fontSize: 16),
                    ),
                  ],
                ),

                IconButton(onPressed: () {
                    // showNotificationDialog(context);
                    // FloatingSnackBar(
                    //     message: 'Coming soon', context: context,
                    // );
                  }, icon: Icon(Icons.notifications, size: 40, color: Colors.transparent,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
