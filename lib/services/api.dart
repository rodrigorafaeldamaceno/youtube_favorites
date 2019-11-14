import "dart:convert";

import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import "package:youtube_favorites/models/Video.dart";

String API_KEY = DotEnv().env['API_KEY'];

class Api {
  String _search;
  String _nextToken;

  search(String search) async {
    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");
    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded['nextPageToken'];

      List<Video> videos = decoded["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  nextPage() async {
    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken');

    return decode(response);
  }
}
