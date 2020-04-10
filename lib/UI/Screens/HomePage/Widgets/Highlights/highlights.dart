import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Models/event_card.dart';

class HighLights extends StatefulWidget {
  final List<Event> highLightsMap;

  HighLights({Key key, @required this.highLightsMap}) : super(key: key);
  @override
  HighLightsState createState() => HighLightsState();
}

class HighLightsState extends State<HighLights> {
  List<Event> highLightEvents;
  int autoplayseconds = 5;
  double carousalHeight = 240;
  var isLiked;

  // TODO: Themes should be made global
  var titleStyle = TextStyle(
      color: Colors.white,
      fontFamily: pfontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600);
  var contentStyle = TextStyle(
      color: Colors.white,
      fontFamily: sfontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400);

  List<Event> highLightsMap;

  @override
  void initState() {
    highLightsMap = widget.highLightsMap;
    super.initState();
    isLiked = [false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: highLightsMap.length,
        height: carousalHeight,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: autoplayseconds),
        itemBuilder: (BuildContext build, index) {
          return GestureDetector(
            child: Card(
              margin: EdgeInsets.all(4),
              child: Stack(
                children: <Widget>[
                  cardImage(highLightsMap[index].icon),
                  highLightCardContent(highLightsMap[index], index)
                ],
              ),
            ),
            // TODO: Navigate to details page
            onTap: () {},
          );
        });
  }

  highLightCardContent(Event event, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                event.name,
                style: titleStyle,
              ),
              Text("${event.dateTime}", style: contentStyle)
            ],
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2)),
              child: IconButton(
                  iconSize: 32,
                  color: Colors.white,
                  icon: !isLiked[index]
                      ? Icon(Icons.favorite_border)
                      : Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    //Insert function that enables this event as favourite
                    /*

                        Over Here

                    */
                    setState(() {
                      isLiked[index] = !isLiked[index];
                    });
                  }))
        ],
      ),
    );
  }
}

cardImage(String url) {
  var gradientcolor1 = Color(0xf224234A);
  var gradientcolor2 = Color(0xb324234A);
  var roundness = BorderRadius.circular(16);
  return Stack(children: <Widget>[
    CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            borderRadius: roundness,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
    ),

    //gradient overlay
    Container(
      decoration: BoxDecoration(
          borderRadius: roundness,
          gradient: LinearGradient(
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
            colors: [gradientcolor1, gradientcolor2],
            stops: [0.0, 1.0],
          )),
    )
  ]);
}
