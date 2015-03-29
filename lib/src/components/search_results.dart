part of isomorphic_dart.components;

typedef SearchResultsView(String term, Iterable<Movie> movies, Subject<String> search, Subject<Movie> select);

var _searchResultsView = registerComponent(() => new _SearchResultsView());

SearchResultsView searchResultsView = (String term, Iterable<Movie> movies, Subject<String> search, Subject<Movie> select) {
  return _searchResultsView({"term": term, "movies": movies, "search": search, "select": select});
};

class _SearchResultsView extends Component {
  String get _term => props["term"];
  Iterable<Movie> get _movies => props["movies"];
  Subject<String> get _search => props["search"];
  Subject<Movie> get _select => props["select"];

  render() {
    return div({}, [
        searchView(_search),
        h2({"className": "tile results-count"}, "Results for \"$_term\""),
        div({}, _movies.map((movie) => renderMovie(movie)).toList())
    ]);
  }

  renderMovie(Movie movie) {
    var onLinkClick = new Subject<SyntheticEvent>(sync: true);
    onLinkClick.stream
        .doAction((event) => event.preventDefault())
        .listen((_) => _select.add(movie));

    return div({"className": "tile movie movie-summary"}, [
        a({"href": "/movie/${movie.id}", "onClick": onLinkClick}, [
            posterImageView(movie.posterUri)
        ]),
        a({"href": "/movie/${movie.id}", "onClick": onLinkClick}, [
            span({}, movie.title)
        ])
    ]);
  }
}