import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/network/api_firebase.dart';

import '../../models/video_paid.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/loadingIndicator.dart';
import '../movie/movie_details_screen.dart';

class BoughtScreen extends StatefulWidget {
  static final String route = '/BoughtScreen';

  @override
  State<StatefulWidget> createState() => BoughtScreenState();
}

class BoughtScreenState extends State<BoughtScreen> {
  List<VideoPaid> listVideosPaid = [];
  var appModeBox = Hive.box('appModeBox');
  late bool isDark;

  @override
  Widget build(BuildContext context) {
    isDark = appModeBox.get('isDark') ?? false;
    return StreamBuilder<DocumentSnapshot>(
        stream: ApiFirebase().getVideosPaidStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            listVideosPaid = [];
          }
          if (snapshot.hasData) {
            listVideosPaid =
                (snapshot.data?.data() as VideosPaid?)?.listVideoPaid ?? [];
          }
          print(
              "VideosPaid: ${(snapshot.data?.data() as VideosPaid?)?.listVideoPaid}");
          return Scaffold(
            appBar: _buildAppBar(),
            body: (listVideosPaid.length == 0)
                ? _noItemFounnd(context)
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: listVideosPaid.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemBuilder(context, listVideosPaid[index]);
                    }),
          );
        });
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor:
          isDark ? CustomTheme.colorAccentDark : CustomTheme.primaryColor,
      title: Text("Bài học đã mua"),
    );
  }

  Widget _itemBuilder(context, VideoPaid model) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, MovieDetailScreen.route,
          arguments: {"movieID": model.videoId}),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Card(
            color: isDark ? CustomTheme.darkGrey : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  child: Image.network(
                    model.thumb!,
                    fit: BoxFit.cover,
                    height: 140,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2),
                  padding: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        overflow: TextOverflow.ellipsis,
                        style: isDark
                            ? CustomTheme.authTitleWhite
                            : CustomTheme.authTitleBlack,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _noItemFounnd(context) {
    return Center(
        child: Text("Bạn chưa mua bài nhảy nào.",
            style: isDark ? CustomTheme.bodyText2 : CustomTheme.bodyText2));
  }

  Widget _loadingBuilder(context) {
    return Center(child: spinkit);
  }
}
