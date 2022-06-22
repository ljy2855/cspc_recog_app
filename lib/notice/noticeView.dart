import 'dart:io';

import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:cspc_recog/notice/models/notice.dart';
import 'package:cspc_recog/providers/userData.dart';

import 'package:cspc_recog/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeView extends StatefulWidget {
  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  final GlobalKey<AnimatedListState> _noticeListKey =
      GlobalKey<AnimatedListState>();
  double height;
  double width;

  List<NoticeModel> notices;
  @override
  Widget build(BuildContext context) {
    MyLoginUser myLogin = Provider.of<MyLoginUser>(context, listen: false);
    int profileId = myLogin.getProfile().profileId;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: _removeAllNotices,
              child: Text(
                "모두 지우기",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ))
        ],
      ),
      backgroundColor: Color(0xFBF2F2F2),
      body: Container(
        child: FutureBuilder<List<NoticeModel>>(
          future: getNoticeList(context, profileId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              notices = snapshot.data;

              return AnimatedList(
                key: _noticeListKey,
                initialItemCount: notices.length,
                itemBuilder: (context, index, animation) =>
                    _buildNotice(notices[index], animation, index),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotice(NoticeModel notice, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: noticeBox(height, width, notice, index),
    );
  }

  _removeNotice(int index) async {
    NoticeModel removeNotice = notices.removeAt(index);
    AnimatedListRemovedItemBuilder builder =
        (context, animation) => _buildNotice(removeNotice, animation, index);
    _noticeListKey.currentState.removeItem(index, builder);
    await deleteNotice(removeNotice.id);
  }

  _removeAllNotices() async {
    int length = notices.length;
    for (int i = length - 1; i >= 0; i--) {
      _removeNotice(i);
      await Future.delayed(Duration(milliseconds: 100));
    }
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.of(context).pop();
  }

  Widget noticeBox(double height, double width, NoticeModel notice, int index) {
    return SizedBox(
      height: height * 0.14,
      width: width * 0.8,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      // padding: EdgeInsets.all(0),
                      iconSize: 15,
                      onPressed: () => _removeNotice(index),
                      constraints: BoxConstraints(maxHeight: 15),
                      icon: Icon(
                        Icons.close,
                        size: 15,
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: height * 0.01)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: width * 0.05)),
                  notice.type == "callendar"
                      ? Icon(
                          CustomIcons.calendar,
                          color: colorMain,
                          size: 24,
                        )
                      : Icon(
                          CustomIcons.community,
                          color: colorMain,
                          size: 24,
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
                            fontSize: 15,
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
                            fontSize: 12,
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
      ),
    );
  }
}
