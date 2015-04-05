part of isomorphic_dart.apis;

class TmdbMoviesApi implements MoviesApi {
  final ClientFactory _clientFactory;
  final Uri _baseUri = Uri.parse("https://api.themoviedb.org/3");
  final String _apiKey;

  TmdbMoviesApi(this._clientFactory, {String apiKey: "f9dba24a3b8ed9425600eb5d5fbd9a93"}) :
      _apiKey = apiKey;

  Future<Map> getMovie(id) async {
    var response = _request("movie/$id", params: {"append_to_response": "credits,releases"});
    return JSON.decode(await response);
  }

  Future<Iterable<Map>> search(String term) async {
    if (term != null && term.isNotEmpty) {
      var response = _request("search/movie", params: {"query": term});
      var results = JSON.decode(await response)["results"];
      var ids = results.map((json) => json["id"]);
      return Future.wait(ids.map((id) => getMovie(id)));
    } else {
      return [];
    }
  }

  Future<String> _request(String path, {Map params: const {}}) {
    var pathSegments = _baseUri.pathSegments.toList()..addAll(path.split("/"));
    var queryParams = new Map.from(params)..addAll({"api_key": _apiKey});
    var uri = _baseUri.replace(pathSegments: pathSegments, queryParameters: queryParams);
    var client = _clientFactory();
    return client.read(uri);
  }
}