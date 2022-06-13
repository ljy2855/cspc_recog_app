import 'package:cspc_recog/notice/models/notice.dart';
import 'package:cspc_recog/notice/widget/noticeBox.dart';
import 'package:flutter/material.dart';

class NoticeView extends StatefulWidget {
  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  @override
  Widget build(BuildContext context) {
    int profileId = 1;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder<List<NoticeModel>>(
          future: getNoticeList(context, profileId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<NoticeModel> notices = snapshot.data;

              return ListView(
                children: notices
                    .map((notice) => noticeBox(height, width, notice))
                    .toList(),
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
}
