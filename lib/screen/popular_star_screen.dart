import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/server/repository.dart';

import '../../models/home_content.dart';
import '../strings.dart';
import '../utils/loadingIndicator.dart';
import 'movies_by_star_id.dart';

// ignore: must_be_immutable
class PopularStarScreen extends StatefulWidget {
  @override
  PopularStarScreenState createState() => PopularStarScreenState();
}

class PopularStarScreenState extends State<PopularStarScreen> {
  static late bool isDark;
  var appModeBox = Hive.box('appModeBox');
  late Future<HomeContent> _homeContent;

  @override
  void initState() {
    isDark = appModeBox.get('isDark') ?? false;
    super.initState();
    _homeContent = Repository().getHomeContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh sách giáo viên"),
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder<HomeContent>(
          future: _homeContent,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              HomeContent homeContent = snapshot.data as HomeContent;
              return SingleChildScrollView(
                child: GridView.builder(
                    itemCount: homeContent.popularStars?.length,
                    padding: EdgeInsets.all(16),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (homeContent.popularStars!.length < 30) ? 2 : 3,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 16),
                    itemBuilder: (BuildContext context, int index) {
                      return buildStarCard(
                          context, homeContent.popularStars![index]);
                    }),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  AppContent.somethingWentWrong,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(
              child: spinkit,
            );
          },
        ));
  }
}

Widget buildStarCard(BuildContext context, PopularStars popularStars) {
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MoviesScreenByStarID.route,
          arguments: {
            'isPresentAppBar': true,
            'starID': popularStars.starId,
            'title': popularStars.starName,
          },
        );
      },
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      popularStars.imageUrl!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(popularStars.starName!,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
