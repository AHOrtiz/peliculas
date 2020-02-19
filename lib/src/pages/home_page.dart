import 'package:flutter/material.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/providers/peliculas_provaider.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final peliculasProvaider = new PeliculasProvaider();

  @override
  Widget build(BuildContext context) {

    peliculasProvaider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en Cines'),
        backgroundColor: Color(0xFF65587f),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      // body: SafeArea(
      //   child: Text('Hello world'),
      // )
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTerjetas(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swiperTerjetas() {
    
    return FutureBuilder(
      future: peliculasProvaider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if (snapshot.hasData) {
          return CardSwiperWidget(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
        }

      },
    );

  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Tendencia', style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0),

          StreamBuilder(
            stream: peliculasProvaider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvaider.getPopulares
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          )

        ],
      ),
    );
  }
}