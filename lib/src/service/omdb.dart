library isomorphic_dart.omdb;

import 'dart:async';
import 'dart:convert';
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:isomorphic_dart/src/util/http.dart';

class OmdbClient {
  final ClientFactory _clientFactory;
  final Uri _baseUri = Uri.parse("http://www.omdbapi.com/");

  OmdbClient(this._clientFactory);

  Future<Map> getMovie(String id) {
    var client = _clientFactory();
    var uri = _baseUri.replace(queryParameters: {"i": id});
    return client.read(uri)
        .then((body) => JSON.decode(body));
  }

  Future<Iterable<Map>> search(String term) {
    var client = _clientFactory();
    var uri = _baseUri.replace(queryParameters: {"s": term});
    return client.read(uri)
        .then((body) => JSON.decode(body)["Search"])
        .then((movies) => movies.map((movie) => movie["imdbID"]))
        .then((ids) => Future.wait(ids.map((id) => getMovie(id))));
  }
}