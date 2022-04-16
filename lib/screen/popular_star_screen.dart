import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/home_content.dart';
import '../../screen/movies_by_star_id.dart';
import '../../style/theme.dart';

// ignore: must_be_immutable
class PopularStarScreen extends StatefulWidget {
  static const String route = "popular_star_screen";

  PopularStarScreen({this.popularStarList});

  int index = 0;
  List<PopularStars>? popularStarList;

  @override
  PopularStarScreenState createState() => PopularStarScreenState();
}

class PopularStarScreenState extends State<PopularStarScreen> {
  static late bool isDark;
  var appModeBox = Hive.box('appModeBox');

  @override
  void initState() {
    isDark = appModeBox.get('isDark') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.popularStarList =
        ModalRoute.of(context)!.settings.arguments as List<PopularStars>;
    return Container(
        padding: EdgeInsets.only(left: 2),
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: widget.popularStarList?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MoviesScreenByStarID.route,
                      arguments: {
                        'isPresentAppBar': true,
                        'starID':
                            widget.popularStarList?.elementAt(index).starId,
                        'title':
                            widget.popularStarList?.elementAt(index).starName,
                      },
                    );
                  },
                  child: Container(
                    width: 120.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              widget.popularStarList![index].imageUrl!,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          widget.popularStarList![index].starName!,
                          style: isDark
                              ? CustomTheme.bodyText2White
                              : CustomTheme.coloredBodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
              ),
            ),
          ],
        ));
  }
}
