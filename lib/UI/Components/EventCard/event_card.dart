import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Models/event_card.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';

// This card UI can be used for
// 1. Events List
// 2. Favourites
// 3. Registered events

class TestCard extends StatelessWidget {
  final Event event;

  TestCard(this.event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Naviagte to event details
      },
      child: Card(
        elevation: 7.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              child: CachedNetworkImage(
                imageUrl: event.icon,
                // TODO: Placeholder
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
            ),
            title: Text(
              event.name[0].toUpperCase() + event.name.substring(1),
            ),
            subtitle: Text(
              event.dateTime != null ? event.dateTime : 'No date | No time',
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: MediaQuery.of(context).size.height / 5.5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image
          Container(
            child: CachedNetworkImage(
              imageUrl: event.icon,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  colors: [primaryColor, primaryColor],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Details
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title
                Text(
                  event.name[0].toUpperCase() + event.name.substring(1),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                  ),
                ),
                SizedBox(height: 5),
                // Date and Time
                Text(
                  event.dateTime != null ? event.dateTime : 'No date | No time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // On Tap
          Material(
            color: Colors.transparent,
            child: InkWell(
              // TODO: Navigate to event details page
              onTap: () {},
            ),
          ),
          // Favourites - Add below if required (Use Positioned)
        ],
      ),
    );
  }
}