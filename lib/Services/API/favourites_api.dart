import 'dart:convert';
import 'package:excelapp/Models/event_card.dart';
import 'package:excelapp/Models/event_details.dart';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FavouritesStatus {
  static final FavouritesStatus instance = FavouritesStatus.internal();
  FavouritesStatus.internal();
  // 0 if data not retreived, 1 if data retrieved, 2 if error, 3 if refresh needed
  int favouritesStatus = 0;
  // Stores favourited event ID's
  Set<int> favouritesIDs = {};
  // Event list
  List<Event> eventList = [];

  removeEventFromMemory(int id) {
    for (int i = 0; i < eventList.length; i++) {
      if (eventList[i].id == id) {
        eventList.removeAt(i);
        break;
      }
    }
  }
}

class FavouritesAPI {
  // Gets ID's of favourited events
  static fetchFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    if (jwt == null) {
      FavouritesStatus.instance.favouritesStatus = 3;
      return 'notLoggedIn';
    }
    if (FavouritesStatus.instance.favouritesStatus == 1)
      return FavouritesStatus.instance.eventList;

    print('---Network request to fetch Favourites---');
    var response = await fetchDataFromNet(jwt);
    FavouritesStatus.instance.favouritesStatus = 1;

    try {
      List data = json.decode(response.body);
      // Add event ID's
      FavouritesStatus.instance.favouritesIDs = {};
      for (int i = 0; i < data.length; i++) {
        FavouritesStatus.instance.favouritesIDs.add(data[i]['id']);
      }
      List<dynamic> responseData = json.decode(response.body);
      FavouritesStatus.instance.eventList =
          responseData.map<Event>((event) => Event.fromJson(event)).toList();
      return FavouritesStatus.instance.eventList;
    } catch (_) {
      FavouritesStatus.instance.favouritesStatus = 2;
      return [];
    }
  }

// Check if an event is favourited
  static isFavourited(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    if (jwt == null)
      return false;
    else if (FavouritesStatus.instance.favouritesIDs.contains(id))
      return true;
    else
      return false;
  }

// Deletes an event from favourites
  static Future deleteFavourite({int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    if (jwt == null) return "Log in to remove favourite events";
    if (FavouritesStatus.instance.favouritesStatus == 0)
      return 'Network not available';
    if (!await isFavourited(id)) return "Already Unfavourited";
    try {
      var a = await http.delete(
        APIConfig.baseUrl + '/bookmark/' + id.toString(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + jwt,
          "Content-Type": "application/json"
        },
      );
      print("Removing from favourites attempted with status code " +
          a.statusCode.toString());
      FavouritesStatus.instance.favouritesIDs.remove(id);
      FavouritesStatus.instance.removeEventFromMemory(id);
      // Can instead use FavouritesStatus.instance.favouritesStatus = 3;
      return "deleted";
    } catch (_) {
      return "An error occured";
    }
  }

// Add event to favourites
  static Future addEventToFavourites(
      {@required EventDetails eventDetails}) async {
    int id = eventDetails.id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    if (jwt == null)
      return "Log in to add favourite events";
    else if (FavouritesStatus.instance.favouritesStatus == 0)
      return "Network not Aailable";
    else if (await isFavourited(id)) return "Already in Favourites";
    try {
      var a = await http.post(
        APIConfig.baseUrl + '/bookmark',
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + jwt,
          "Content-Type": "application/json"
        },
        body: json.encode({"id": id}),
      );
      print("Adding to favourites attempted with status code " +
          a.statusCode.toString());
      FavouritesStatus.instance.favouritesIDs.add(id);
      // Converts event details model to event model to add to favourites
      Event eventDetailsToEvent = Event.fromJson(eventDetails.toJson());
      FavouritesStatus.instance.eventList.add(eventDetailsToEvent);
      // Can instead use FavouritesStatus.instance.favouritesStatus = 3;
      return "added";
    } catch (_) {
      return "An error occured";
    }
  }
  // End of registerEvent

}

Future fetchDataFromNet(jwt) async {
  http.Response res;
  try {
    res = await http.get(
      APIConfig.baseUrl + '/bookmark',
      headers: {HttpHeaders.authorizationHeader: "Bearer " + jwt},
    );
    return res;
  } catch (_) {
    await Future.delayed(Duration(milliseconds: 3000), () async {
      res = await fetchDataFromNet(jwt);
    });
    return res;
  }
}
