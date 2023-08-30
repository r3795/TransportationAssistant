import 'dart:async';
import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:fluter_tuto/provider/provider_itinerary.dart';
import 'package:fluter_tuto/provider/provider_my_location.dart';
import 'package:fluter_tuto/provider/provider_recent_searches.dart';
import 'package:fluter_tuto/provider/provider_search_variable.dart';
import 'package:fluter_tuto/provider/provider_tap_index.dart';
import 'package:fluter_tuto/screens/alarm_screen.dart';
import 'package:fluter_tuto/screens/direction_screen.dart';
import 'package:fluter_tuto/screens/map_screen.dart';
import 'package:fluter_tuto/widgets/slider_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:fluter_tuto/provider/provider_favorites.dart';
import 'package:provider/provider.dart';

import 'Services/notifi_service.dart';
import 'models/model_itinerary.dart';

Timer? ttimer;
//하차 알림 변수들 다 글로벌 변수 선언해버림.
int currentTargetIndex=0;
bool isFirstTimerStart=true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = NoCheckCertificateHttpOverrides();
  var recentSearchesProvider = RecentSearchesProvider();
  await recentSearchesProvider.loadFromPrefs();
  var favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFromPrefs();

  /// provider_Itinerary << 객체 주고받기용
  // List<Itinerary> itineraries = [];
  // Itinerary alarmItinerary = Itinerary.empty();
  /// 라이브러리 메모리에 appKey 등록
  /// 지도가 호출되기 전에만 세팅해 주면 됩니다.
  /// dotEnv 대신 appKey 를 직접 넣어주셔도 됩니다.
  AuthRepository.initialize(appKey: '7e9dda7afb6f5410877bfd9b92fa650f');
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  // debugShowCheckedModeBanner: false, 디버그 모드 안 뜨게 하기

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RecentSearchesProvider>.value(
          value: recentSearchesProvider,
        ),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
        ChangeNotifierProvider<AlarmItineraryProvider>(
          create: (context) => AlarmItineraryProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider<TabIndexProvider>(
          create: (context) => TabIndexProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YATA',
      theme: ThemeData(),
      initialRoute: '/', // set the initial route
      routes: {
        '/': (context) => IntroductionScreenPage(), // new introduction screen
        '/home': (context) {
          return Consumer<TabIndexProvider>(
            builder: (context, tabProvider, _) {
              int currentIndex = tabProvider.currentIndex;
              return DefaultTabController(
                length: 3,
                initialIndex: currentIndex,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'YA-TA!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                  drawer: MySlider(),
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      DirectionScreen(),
                      AlarmScreen(),
                      MapScreen(),
                    ],
                  ),
                  bottomNavigationBar: ConvexAppBar(
                    items: [
                      TabItem(icon: Icons.route, title: '길찾기'),
                      TabItem(icon: Icons.access_alarm, title: '알람'),
                      TabItem(icon: Icons.map, title: '지도'),
                    ],
                    backgroundColor: Color(0xFF3F4250),
                  ),
                ),
              );
            },
          );
        },
      },
    );
  }
}


class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({super.key});

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '대중교통 이용, 이제 더욱 간편하게!',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '사용자 친화적인 인터페이스로 직관적이고 간편하게 \n애플리케이션을 이용하실 수 있습니다.',
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ),
        image: Center(child: Image.asset('assets/images/1_undraw_app.png',)),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 90.0),
          titlePadding: EdgeInsets.only(bottom: 40.0), // Add this line to remove default padding
          bodyPadding: EdgeInsets.only(bottom: 60.0 ),
          bodyAlignment: Alignment.center,
          pageColor: Colors.white,
        ),
      ),

      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '자주가는 길, 한번에 입력!',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '자주 이용하는 경로와 장소를 저장하여 \n빠르고 쉽게 검색이 가능합니다.',
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ),
        image: Center(child: Image.asset('assets/images/2_undraw_navigator.png',)),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 90.0),
          titlePadding: EdgeInsets.only(bottom: 40.0), // Add this line to remove default padding
          bodyPadding: EdgeInsets.only(bottom: 60.0 ),
          bodyAlignment: Alignment.center,
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '신뢰할 수 있는 하차 알림!',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '하차할 정류장이 가까워 질 때마다 알림을 드립니다. \n이제 정류장을 놓치실 걱정 없습니다.',
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ),
        image: Center(child: Image.asset('assets/images/3_undraw_alarm.png',)),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 90.0),
          titlePadding: EdgeInsets.only(bottom: 40.0), // Add this line to remove default padding
          bodyPadding: EdgeInsets.only(bottom: 60.0 ),
          bodyAlignment: Alignment.center,
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '유출없는 개인정보',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '모든 장소, 지역, 길찾기 검색 내용은 \n애플리케이션 내부에 안전하게 저장됩니다.',
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ),
        image: Center(child: Image.asset('assets/images/4_undraw_private_resize.png')),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 90.0),
          titlePadding: EdgeInsets.only(bottom: 40.0), // Add this line to remove default padding
          bodyPadding: EdgeInsets.only(bottom: 60.0 ),
          bodyAlignment: Alignment.center,
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            '지금 시작하세요!',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 0.0), // adjust the value as needed
          child: Text(
            'YATA와 함께 대중교통으로부터 받는 \n스트레스에서 자유로워지세요.',
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
        ),
        image: Center(child: Image.asset('assets/images/5_undraw_Fireworks_resize.png', )),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 90.0),
          titlePadding: EdgeInsets.only(bottom: 40.0), // Add this line to remove default padding
          bodyPadding: EdgeInsets.only(bottom: 60.0 ),
          bodyAlignment: Alignment.center,
          pageColor: Colors.white,
        ),
      ),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: getPages(),
      onDone: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      onSkip: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
      next: const Icon(Icons.navigate_next, color: Colors.black,),
      done: const Text("시작해보기", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColors: [
          Color(0xFF65B0FF), // RGB(101,176,255)
          Color(0xFF8D65FF), // RGB(141,101,255)
          Color(0xFFFFE200), // RGB(255,226,0)
          Color(0xFF42FF00), // RGB(66,255,0)
          Color(0xFF7EFBFD), // RGB(126,251,253)
        ],
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
        ),
      ),
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: Colors.grey[100],
      ),
      skipStyle: TextButton.styleFrom(foregroundColor: Colors.blue,),
      doneStyle: TextButton.styleFrom(foregroundColor: Colors.green),
      nextStyle: TextButton.styleFrom(foregroundColor: Colors.blue),

    );
  }
}
