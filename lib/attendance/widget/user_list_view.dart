import 'package:flutter/material.dart';

import '../../common/custom_icons_icons.dart';
import '../models/profile.dart';

Widget userListView(final List<ProfileModel> profileList, double height,
    double width, BuildContext context) {
  return GestureDetector(
    onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text("Save successfully"),
            )),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CustomIcons.wori2,
            color: Colors.white,
            size: width * 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.06, top: height * 0.015),
            child: Text(
              "우리",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
