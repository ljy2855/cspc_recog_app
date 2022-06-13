import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:cspc_recog/notice/models/notice.dart';
import 'package:cspc_recog/settings.dart';
import 'package:flutter/material.dart';

Widget noticeBox(double height, double width, NoticeModel notice) {
  return SizedBox(
    height: height * 0.15,
    width: width * 0.5,
    child: Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: height * 0.05)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: width * 0.1)),
              notice.type == "callendar"
                  ? Icon(
                      CustomIcons.calendar,
                      color: colorMain,
                      size: 30,
                    )
                  : Icon(
                      CustomIcons.community,
                      color: colorMain,
                      size: 30,
                    ),
              Padding(padding: EdgeInsets.only(left: width * 0.05)),
              SizedBox(
                width: width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 7)),
                    Text(
                      notice.content,
                      overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
