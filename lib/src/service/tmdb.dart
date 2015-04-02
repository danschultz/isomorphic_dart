library isomorphic_dart.omdb;

import 'dart:async';
import 'dart:convert';
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:isomorphic_dart/src/util/http.dart';

class TmdbClient {
  final ClientFactory _clientFactory;
  final Uri _baseUri = Uri.parse("https://api.themoviedb.org/3");
  final String _apiKey;

  TmdbClient(this._clientFactory, {String apiKey: "f9dba24a3b8ed9425600eb5d5fbd9a93"}) :
      _apiKey = apiKey;

  Future<Map> getMovie(id) async {
    var response = await _request("movie/$id", params: {"append_to_response": "credits,releases"});
    return JSON.decode(response);
  }

  Future<Iterable<Map>> search(String term) async {
    var response = await _request("search/movie", params: {"query": term});
    var results = JSON.decode(response)["results"];
    var ids = results.map((json) => json["id"]);
    return Future.wait(ids.map((id) => getMovie(id)));
  }

  Future<String> _request(String path, {Map params: const {}}) {
    var pathSegments = _baseUri.pathSegments.toList()..addAll(path.split("/"));
    var queryParams = new Map.from(params)..addAll({"api_key": _apiKey});
    var uri = _baseUri.replace(pathSegments: pathSegments, queryParameters: queryParams);
    var client = _clientFactory();
    return client.read(uri);
  }
}