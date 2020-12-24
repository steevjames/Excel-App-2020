import 'dart:async';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:flutter/material.dart';
import 'package:excelapp/Models/event_card.dart';
import 'package:excelapp/Services/API/events_api.dart';
import 'package:excelapp/UI/Components/Appbar/appbar.dart';
import 'package:excelapp/UI/Components/EventCard/event_card.dart';

class EventsList extends StatefulWidget {
  final String category;
  EventsList(this.category);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  String endpoint;
  StreamController<dynamic> estream;

  @override
  void initState() {
    super.initState();
    endpoint = APIConfig.getEndpoint(widget.category);
    estream = StreamController<dynamic>();
    fetchEvents(endpoint);
  }

  void fetchEvents(String endpoint) async {
    var result1;
    result1 = await EventsAPI.fetchEventListFromStorage(endpoint);
    if (result1 != null) estream.add(result1);

    // Fetch from net & update
    var result2 = await EventsAPI.fetchAndStoreEventListFromNet(endpoint);
    if (result2 == "error" && result1 == null) {
      estream.add("error");
      return;
    }
    if (result2 == "error") return;
    print("- $endpoint fetched, added to DB, & updated in UI");
    estream.add(result2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customappbar(widget.category),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: estream.stream,
              builder: (context, snapshot) {
                // If no internet & not stored
                if (snapshot.data == "error")
                  return Center(
                    child: Text(
                      "Failed to load. Please retry",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  );
                List<Event> list = snapshot.data;
                // If data is present
                if (snapshot.hasData) {
                  // If no events
                  if (list.isEmpty)
                    return Center(
                      child: Text(
                        "No Events",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    );

                  return ListView(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: <Widget>[
                          SizedBox(height: 20),
                        ] +
                        List.generate(
                          list.length,
                          (index) => EventCard(
                            list[index],
                          ),
                        ) +
                        <Widget>[
                          SizedBox(height: 100),
                        ],
                  );
                } else {
                  return LoadingAnimation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
