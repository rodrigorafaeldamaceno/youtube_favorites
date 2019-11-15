import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites/bloc/FavoriteBloc.dart';
import 'package:youtube_favorites/bloc/VideosBloc.dart';
import 'package:youtube_favorites/delegates/DataSearch.dart';
import 'package:youtube_favorites/models/Video.dart';
import 'package:youtube_favorites/pages/FavoritesPage.dart';
import 'package:youtube_favorites/widgets/VideoTile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _videoBloc = BlocProvider.getBloc<VideosBloc>();
    final _favBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset('images/youtube.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: _favBloc.outFav,
              // initialData: {},
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Container();
                return Container(
                  child: Text('${snapshot.data.length}'),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FavoritesPage(),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) _videoBloc.inSearch.add(result);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _videoBloc.outVideos,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView.builder(
            itemCount: snapshot.data.length + 1,
            itemBuilder: (context, index) {
              if (index < snapshot.data.length) {
                return VideoTile(snapshot.data[index]);
              } else if (index > 1) {
                _videoBloc.inSearch.add(null);
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.red,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
