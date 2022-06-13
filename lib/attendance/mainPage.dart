import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/attendance/widget/circle_group.dart';
import 'package:cspc_recog/attendance/widget/profile_image_view.dart';
import 'package:cspc_recog/attendance/widget/user_list_view.dart';
import 'package:cspc_recog/attendance/widget/user_rank_view.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:cspc_recog/settings.dart';
import 'package:flutter/material.dart';
import '../urls.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  ProfileModel myProfile;
  double height;
  double width;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<ProfileModel>>(
            future: getProfileList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<ProfileModel> profileList = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Container(
                    child: Column(
                      children: [
                        topLayout(profileList),
                        onlineProfileView(profileList),
                      ],
                    ),
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget topLayout(final List<ProfileModel> profileList) {
    profileList.sort((b, a) => a.visitTimeSum.compareTo(b.visitTimeSum));
    final ProfileModel winnerProfile = profileList.first;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: SizedBox(
        height: height * 0.2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.61,
              height: height * 0.16,
              child: Container(
                decoration: BoxDecoration(
                  color: colorMain,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: userRankView(winnerProfile, height, width),
              ),
            ),
            SizedBox(
              height: height * 0.16,
              width: width * 0.24,
              child: Container(
                decoration: BoxDecoration(
                  color: colorSub,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: userListView(profileList, height, width, context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget onlineProfileView(final List<ProfileModel> profileList) {
    //final onlineProfileList = profileList;
    final onlineProfileList = profileList.where((e) => e.isOnline);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
              height: height * 0.5,
              width: width * 0.9,
              child: CircleGroup(
                outPadding: width * 0.1,
                childPadding: width * 0.06,
                children: onlineProfileList.map((profile) {
                  final ValueNotifier<bool> isClicked =
                      ValueNotifier<bool>(false);

                  return ValueListenableBuilder(
                      valueListenable: isClicked,
                      builder:
                          (BuildContext context, bool value, Widget widget) {
                        return GestureDetector(
                            child: value == false
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: profile.profileImageUrl ==
                                            null
                                        ? AssetImage(
                                            'assets/images/profile_default.png')
                                        : NetworkImage(UrlPrefix.urls.substring(
                                                0, UrlPrefix.urls.length - 1) +
                                            profile.profileImageUrl),
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Opacity(
                                        opacity: 0.2,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: profile
                                                        .profileImageUrl ==
                                                    null
                                                ? AssetImage(
                                                    'assets/images/profile_default.png')
                                                : NetworkImage(UrlPrefix.urls
                                                        .substring(
                                                            0,
                                                            UrlPrefix.urls
                                                                    .length -
                                                                1) +
                                                    profile.profileImageUrl)),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          profile.nickName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            onTap: () {
                              isClicked.value = !isClicked.value;
                              print(isClicked.value);
                            });
                      });
                }).toList(),
              )),
        ),
        Positioned(
          right: height * 0.01,
          bottom: width * 0.01,
          child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.replay_circle_filled_sharp,
                color: colorMain,
                size: height * 0.05,
              )),
        )
      ],
    );
  }
}
