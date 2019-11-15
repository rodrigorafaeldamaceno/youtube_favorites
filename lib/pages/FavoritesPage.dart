import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_favorites/bloc/FavoriteBloc.dart';
import 'package:youtube_favorites/models/Video.dart';
import 'package:youtube_favorites/services/api.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _favBloc = BlocProvider.getBloc<FavoriteBloc>();

    Widget _buildVideo(Video value) {
      return Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 50,
            child: Image.network(value.thumb),
          ),
          Expanded(
            child: Text(
              value.title,
              style: TextStyle(
                color: Colors.white70,
              ),
              maxLines: 2,
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: _favBloc.outFav,
        initialData: {},
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView(
            children: snapshot.data.values.map<Widget>((value) {
              return InkWell(
                child: _buildVideo(value),
                onTap: () {
                  FlutterYoutube.playYoutubeVideoById(
                    // fullScreen: true,
                    autoPlay: true,
                    appBarColor: Colors.black,
                    apiKey: API_KEY,
                    videoId: value.id,
                  );
                },
                onLongPress: () {
                  _favBloc.toggleFavorite(value);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
