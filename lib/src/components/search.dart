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
        h2({}, "Results for $_term"),
        ul({}, _movies.map((movie) => renderMovie(movie)).toList())
    ]);
  }

  renderMovie(Movie movie) {
    var onLinkClick = new Subject<SyntheticEvent>(sync: true);
    onLinkClick.stream
        .doAction((event) => event.preventDefault())
        .listen((_) => _select.add(movie));

    var children = movie.posterUri != null ? [img({"src": movie.posterUri.toString()})] : [];
    children.add(span({}, movie.title));

    return li({}, [
        a({"href": "/movie/${movie.id}", "onClick": onLinkClick}, children)
    ]);
  }
}