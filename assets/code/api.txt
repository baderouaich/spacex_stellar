import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static String baseUrl = "https://api.spacexdata.com/v3";
  static Map<String, dynamic> defaultResponse = {
    "isError": false,
    "message": "",
    "data": ""
  };

  //////////////////======== Missions START========/////////////////
  static Future<Map<String, dynamic>> getAllMissions() async {
    var url = "$baseUrl/missions";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Missions Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Missions END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== Capsules START========/////////////////
  static Future<Map<String, dynamic>> getAllCapsules() async {
    var url = "$baseUrl/capsules";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Capsules Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getUpcomingCapsules() async {
    var url = "$baseUrl/capsules/upcoming";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Upcoming Capsules Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getPastCapsules() async {
    var url = "$baseUrl/capsules/past";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Past Capsules Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Capsules END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== Cores START========/////////////////
  static Future<Map<String, dynamic>> getAllCores() async {
    var url = "$baseUrl/cores";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Cores Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getUpcomingCores() async {
    var url = "$baseUrl/cores/upcoming";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Upcoming Cores Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getPastCores() async {
    var url = "$baseUrl/cores/past";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Upcoming Cores Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Cores END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== Dragons START========/////////////////
  static Future<Map<String, dynamic>> getAllDragons() async {
    var url = "$baseUrl/dragons";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Dragons Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Dragons END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== Info START========/////////////////
  static Future<Map<String, dynamic>> getInfo() async {
    var url = "$baseUrl/info";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Info Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Info END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== LandingPads START========/////////////////
  static Future<Map<String, dynamic>> getAllLandingPads() async {
    var url = "$baseUrl/landpads";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Landing Pads Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== LandingPads END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///  //////////////////======== Launches START========/////////////////
  static Future<Map<String, dynamic>> getAllLaunches() async {
    var url = "$baseUrl/launches";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Launches Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getUpcomingLaunches() async {
    var url = "$baseUrl/launches/upcoming";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Upcoming Launches Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getPastLaunches() async {
    var url = "$baseUrl/launches/past";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Past Launches Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getLatestLaunches() async {
    var url = "$baseUrl/launches/latest";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Latest Launches Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  ///
  static Future<Map<String, dynamic>> getNextLaunches() async {
    var url = "$baseUrl/launches/next";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get The Next Launches Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Capsules END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== Launch Pads START========/////////////////
  static Future<Map<String, dynamic>> getAllLaunchPads() async {
    var url = "$baseUrl/launchpads";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Launch Pads Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Launch Pads END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== Payloads  START========/////////////////
  static Future<Map<String, dynamic>> getAllPayloads() async {
    var url = "$baseUrl/payloads";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Payloads Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Payloads  END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== History  START========/////////////////
  static Future<Map<String, dynamic>> getAllHistoryEvents() async {
    var url = "$baseUrl/history";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get History Events Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== History  END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== Roadster  START========/////////////////
  static Future<Map<String, dynamic>> getRoadster() async {
    var url = "$baseUrl/roadster";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Roadster Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Roadster  END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== Ships  START========/////////////////
  static Future<Map<String, dynamic>> getAllShips() async {
    var url = "$baseUrl/ships";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Ships Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }

  //////////////////======== Ships  END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /////////////////////======== Rockets  START========/////////////////
  static Future<Map<String, dynamic>> getAllRockets() async {
    var url = "$baseUrl/rockets";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      defaultResponse["isError"] = false;
      defaultResponse["data"] = await json.decode(response.body);
      return defaultResponse;
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get Rockets Data from SpaceX API, please try again later.";
      return defaultResponse;
    }
  }
  //////////////////======== Rockets  END========/////////////////

}
