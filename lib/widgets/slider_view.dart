import 'package:fluter_tuto/screens/lost_item_screen.dart';
import 'package:fluter_tuto/screens/time_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../screens/credit.dart';
import '../screens/feedback.dart';
import '../screens/slider_setting.dart';

class MySlider extends StatelessWidget {
  const MySlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
                // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage('https://png.pngtree.com/png-clipart/20190922/original/pngtree-school-bus-icon-design-png-image_4779432.jpg'),),
                  accountName: Text(' YA-TA!'),
                  accountEmail: Text(' Public Transportation Assistant'),
                  decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40.0),bottomRight: Radius.circular(40.0))),),
                ListTile(
                  leading: Icon(Icons.content_paste_search,size: 30,color: Colors.grey[850],),
                  title: Text('분실물 문의'),
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => LostItemScreen()),);
                  },
                  trailing: Icon(Icons.add),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.departure_board,size: 30,color: Colors.grey[850],),
                  title: Text('버스 시간표 확인'),
                  onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => TimeTableScreen()),);},
                  trailing: Icon(Icons.add),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.feedback,size: 30,color: Colors.grey[850],),
                  title: Text('피드백'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Slider_Feedback()),
                    );
                  },
                  trailing: Icon(Icons.add),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.wc, size: 30, color: Colors.grey[850],),
                  title: Text('공공 화장실'),
                  onTap: () {launch('https://data.gg.go.kr/portal/data/service/selectServicePage.do?page=1&rows=10&sortColumn=&sortDirection=&infId=GW6U772M6045H11Q799612585601&infSeq=2&order=&loc=#none');},
                  trailing: Icon(Icons.add),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.question_answer, size: 30, color: Colors.grey[850],),
                  title: Text('CREDIT'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Credit()),
                    );
                  },
                  trailing: Icon(Icons.add),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings, size: 30, color: Colors.grey[850],),
                  title: Text('설정'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Slider_Setting()),);
                  },
                  trailing: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'YA-TA! Ver 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}