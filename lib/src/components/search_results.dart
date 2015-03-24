part of isomorphic_dart.components;

typedef SearchResultsView(String term, Iterable<Movie> movies, Subject<Movie> select);

var _searchResultsView = registerComponent(() => new _SearchResultsView());

SearchResultsView searchResultsView = (String term, Iterable<Movie> movies, Subject<Movie> select) {
  return _searchResultsView({"term": term, "movies": movies, "select": select});
};

class _SearchResultsView extends Component {
  String get _term => props["term"];
  Iterable<Movie> get _movies => props["movies"];
  Subject<Movie> get _select => props["select"];

  void componentDidMount(rootNode) {

  }

  render() {
    return div({}, [
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
            // TODO(Dan): Figure out why class name doesn't get set.
            posterImageView({"className": "poster-image-summary", "posterUri": movie.posterUri})
        ]),
        a({"href": "/movie/${movie.id}", "onClick": onLinkClick}, [
            span({}, movie.title)
        ])
    ]);
  }
}