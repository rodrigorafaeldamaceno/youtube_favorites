import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_favorites/models/Video.dart';
import 'package:youtube_favorites/services/api.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;

  final _videosController = StreamController<List<Video>>();
  // acesso a saída dos videos
  Stream get outVideos => _videosController.stream;

  final _searchController = StreamController<String>();
  // acesso a entrada do search
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
}
