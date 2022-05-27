import 'package:cspc_recog/attendance/widget/profile_image_view.dart';
import 'package:cspc_recog/settings.dart';
import 'package:flutter/material.dart';

import '../../common/custom_icons_icons.dart';
import '../models/profile.dart';

Widget userListView(final List<ProfileModel> profileList, double height,
    double width, BuildContext context) {
  return GestureDetector(
    onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: colorSub,
              title: Container(
                child: Text(
                  "우리",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: 30.0,
              ),
              content: SizedBox(
                height: height * 0.6,
                width: width * 0.7,
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    decoration: BoxDecoration(color: Colors.white70),
                    child: ListView(
                      children: profileList
                          .map(
                            (profile) => Container(
                              padding: EdgeInsets.only(bottom: 7),
                              child: Row(
                                children: [
                                  profileImageView(
                                      profile.profileImageUrl, height * 0.05),
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  Text(
                                    profile.nickName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )),
              ),
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
