part of isomorphic_dart.components;

typedef ApplicationView({State state, Subject<Action> updates, MoviesApi moviesApi});

var _applicationView = registerComponent(() => new _ApplicationView());

ApplicationView applicationView = ({State state, Subject<Action> updates, MoviesApi moviesApi}) {
  return _applicationView({"state": state, "updates": updates, "moviesApi": moviesApi});
};

class _ApplicationView extends Component {
  State get _state => props["state"];
  Subject<Action> get _updates => props["updates"];
  MoviesApi get _moviesApi => props["moviesApi"];

  final _search = new Subject<String>();
  final _selectMovie = new Subject<Movie>();

  void componentDidMount(rootNode) {
    _search.stream
        .flatMapLatest((term) => new EventStream.fromFuture(_searchMovies(term).then((movies) => [term, movies])))
        .listen((result) {
          var term = result.first;
          var movies = result.last;
          _updates.add(showSearchResults(term, movies));
        });

    _selectMovie.stream
        .listen((movie) => _updates.add(showMovie(movie)));
  }

  Future<Iterable<Movie>> _searchMovies(String term) async {
    var results = await _moviesApi.search(term);
    return results.map((json) => new Movie.fromJson(json));
  }

  render() {
    return div({"className": "application"}, [_renderPath(_state.path, _state.data)]);
  }

  _renderPath(String path, Map data) {
    if (path == "") {
      return homeView(_search);
    } else if (path.startsWith("search")) {
      var movies = data["movies"].map((json) => new Movie.fromJson(json));
      return searchResultsView(data["term"], movies, _search, _selectMovie);
    } else if (path.startsWith("movie")) {
      var movie = new Movie.fromJson(data["movie"]);
      return movieDetailView(movie);
    } else {
      throw new ArgumentError("Undefined route `$path`");
    }
  }
}