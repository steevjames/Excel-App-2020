import 'package:flutter/material.dart';
import './sponsoredCard.dart';
import 'package:excelapp/UI/constants.dart';

class WelcomeCard extends StatelessWidget {
  final double cardHeight = screenSize.height / 2.1;
  final Radius cardRoundness = Radius.circular(32);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: cardRoundness,
            topRight: cardRoundness,
          ),
        ),
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery.of(context).size.width/5,
                  height: 6,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, 12, 0, 0),
              child: title(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 24),
              child: SponserCards(),
            ),
          ],
        ),
      ),
    );
  }


  title() {
    double subtitleSize = 22;
    double titleSize = 40;
    double headingSize = 16;
    var subtitleWeight = FontWeight.w300;
    var titleWeight = FontWeight.w700;
    var headingWeight = FontWeight.w600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Welcome To",
          style: TextStyle(
              color: primaryColor,
              fontFamily: pfontFamily,
              fontWeight: subtitleWeight,
              fontSize: subtitleSize),
        ),
        Text(
          "Excel 2020",
          style: TextStyle(
              color: primaryColor,
              fontFamily: pfontFamily,
              fontWeight: titleWeight,
              fontSize: titleSize),
        ),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        Text(
          "Sponsered By",
          style: TextStyle(
              color: primaryColor,
              fontFamily: pfontFamily,
              fontWeight: headingWeight,
              fontSize: headingSize),
        )
      ],
    );
  }
}
