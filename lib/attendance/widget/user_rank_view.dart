import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/attendance/widget/profile_image_view.dart';
import 'package:flutter/material.dart';

Widget userRankView(final ProfileModel profile, double height, double width) {
  return Container(
    //alignment: Alignment.center,
    child: SizedBox(
      height: 0.13,
      width: width * 0.56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: width * 0.06)),
                Text(
                  "이달의\n옹동이",
                  style: TextStyle(
                    height: 1.32,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: width * 0.1)),
                SizedBox(
                  height: height * 0.1,
                  width: width * 0.28,
                  child: Stack(
                    children: [
                      profileImageView(profile.profileImageUrl, height * 0.09),
                      Positioned(
                        left: height * 0.05,
                        bottom: 0,
                        child: Text(
                          profile.nickName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: height * 0.01)),
          Text(
            "이번 주에 가장 많이 출석한 사람은 누구일까요?",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
  );
}
