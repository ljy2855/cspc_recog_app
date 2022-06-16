import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cspc_recog/urls.dart';

class NoticeModel {
  final int id;
  final int profileId;
  final String type;
  final DateTime createTime;
  final String title;
  final String content;

  NoticeModel({
    this.id,
    this.profileId,
    this.type,
    this.createTime,
    this.title,
    this.content,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'],
      profileId: json['profile'],
      type: json['notice_type'],
      createTime: DateTime.parse(json['create_time']),
      title: json['title'],
      content: json['content'],
    );
  }
}

Future<List<NoticeModel>> getNoticeList(context, final int profileId) async {
  List<NoticeModel> noticeList = [];
  try {
    final res = await http.get(
      Uri.parse(
        UrlPrefix.urls + 'notice/profile=${profileId.toString()}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      final data = json.decode(utf8.decode(res.bodyBytes));
      noticeList = data
          .map<NoticeModel>((notice) => NoticeModel.fromJson(notice))
          .toList();
    }
  } catch (e) {
    print(e);
  }
  return noticeList;
}

deleteNotice(final int noticeId) async {
  try {
    final res = await http.delete(
      Uri.parse(
        UrlPrefix.urls + 'notice/id=${noticeId.toString()}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(res);
  } catch (e) {
    print(e);
  }
}
