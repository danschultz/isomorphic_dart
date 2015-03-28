library isomorphic_dart.omdb;

import 'dart:async';
import 'dart:convert';
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:isomorphic_dart/src/util/http.dart';

class OmdbClient {
  final ClientFactory _clientFactory;
  final Uri _baseUri = Uri.parse("http://www.omdbapi.com/");

  OmdbClient(this._clientFactory);

  Future<Map> getMovie(String id) async {
    var client = _clientFactory();
    var uri = _baseUri.replace(queryParameters: {"i": id});
    return JSON.decode(await client.read(uri));
  }

  Future<Iterable<Map>> search(String term) async {
    var client = _clientFactory();
    var uri = _baseUri.replace(queryParameters: {"s": term});
    var movies = JSON.decode(await client.read(uri))["Search"];

    if (movies != null) {
      var ids = movies.map((movie) => movie["imdbID"]);
      return Future.wait(ids.map((id) => getMovie(id)));
    } else {
      return [];
    }
  }
}