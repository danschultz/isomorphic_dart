part of isomorphic_dart.components;

typedef ApplicationView({String path, Map data, ClientFactory clientFactory});

var _applicationView = registerComponent(() => new _ApplicationView());

ApplicationView applicationView = ({String path, Map data, ClientFactory clientFactory}) {
  return _applicationView({"path": path, "data": data, "clientFactory": clientFactory});
};

class _ApplicationView extends Component {
  String get _path => state["path"];
  Map get _data => state["data"];
  ClientFactory get _clientFactory => props["clientFactory"];

  final _search = new Subject<String>();
  final _selectMovie = new Subject<Movie>();

  Map getInitialState() => {
    "path": props["path"],
    "data": props["data"]
  };

  void componentDidMount(rootNode) {
    var omdbApi = new OmdbClient(_clientFactory);
    _search.stream
        .flatMapLatest((term) => new EventStream.fromFuture(omdbApi.search(term).then((movies) => [term, movies])))
        .listen((result) {
          var term = result.first;
          var movies = result.last;
          setState({"path": "/search/${Uri.encodeComponent(term)}}", "data": {"movies": movies}});
        });

    _selectMovie.stream
        .listen((movie) => setState({"path": "/movie/${movie.id}", "data": {"movie": movie.toJson()}}));
  }

  render() {
    return div({}, [
        h1({}, "IMDB Dart"),
        _renderPath(_path, _data),
    ]);
  }

  _renderPath(String path, Map data) {
    if (path == "/") {
      return homeView(_search);
    } else if (path.startsWith("/search")) {
      var movies = data["movies"].map((json) => new Movie.fromJson(json));
      return searchResultsView(data["term"], movies, _selectMovie);
    } else if (path.startsWith("/movie")) {
      var movie = new Movie.fromJson(data["movie"]);
      return movieDetailView(movie);
    } else {
      throw new ArgumentError("Undefined route `$path`");
    }
  }
}