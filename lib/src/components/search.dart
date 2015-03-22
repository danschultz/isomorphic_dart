part of isomorphic_dart;

typedef SearchResultsView(String term, Iterable<Movie> movies);

var _searchResultsView = registerComponent(() => new _SearchResultsView());

SearchResultsView searchResultsView = (String term, Iterable<Movie> movies) {
  return _searchResultsView({"term": term, "movies": movies});
};

class _SearchResultsView extends Component {
  String get _term => props["term"];
  Iterable<Movie> get _movies => props["movies"];

  void componentDidMount(rootNode) {

  }

  render() {
    return div({}, [
        h2({}, "Results for $_term"),
        ul({}, _movies.map((movie) => renderMovie(movie)).toList())
    ]);
  }

  renderMovie(Movie movie) {
    return li({}, [
        a({"href": "/movie/${movie.id}"}, [
            img({"src": movie.posterUri.toString()}),
            span({}, movie.title)
        ])
    ]);
  }
}