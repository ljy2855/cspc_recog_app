import 'package:cspc_recog/attendance/profileDrawer.dart';
import 'package:cspc_recog/auth/auth.dart';
import 'package:cspc_recog/board/provider/post_provider.dart';
import 'package:cspc_recog/calendar/calendar.dart';
import 'package:cspc_recog/attendance/mainPage.dart';
import 'package:cspc_recog/board/screen/screen_home.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:cspc_recog/notice/noticeView.dart';
import 'package:cspc_recog/providers/userData.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

//Main App Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyLoginUser()),
        ChangeNotifierProvider(create: (_) => BoardProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Pretendard",
        scaffoldBackgroundColor: Color(0xffF2F2F2),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff86E3CE),
          elevation: 0.0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      title: 'Main App',
      home: LoginPage(),
    );
  }
}

class MyMainPage extends StatefulWidget {
  MyMainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double height;
  double statusBarHeight;

  final List<Widget> _children = [AttendancePage(), BoardPage(), Calendar()];
  String _title = '';
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(child: NoticeView()),
      appBar: AppBar(
        toolbarHeight: height * 0.14 - statusBarHeight,
        title: Text("CSPC"), //TODO FIX
        automaticallyImplyLeading: false,
        centerTitle: true,

        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 29,
          fontWeight: FontWeight.w800,
        ),

        actions: [
          IconButton(
            icon: Icon(
              CustomIcons.bell_icon,
              color: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        //itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        onTap: _onTap,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(size: height * 0.035),
        selectedIconTheme: IconThemeData(size: height * 0.035),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(CustomIcons.home),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(CustomIcons.community),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(CustomIcons.calendar),
          )
        ],
      ),
    );
  }
}
