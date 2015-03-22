part of isomorphic_dart;

typedef MovieDetailView(Movie movie);

var _movieDetailView = registerComponent(() => new _MovieDetailView());

MovieDetailView movieDetailView = (Movie movie) => _movieDetailView({"movie": movie});

class _MovieDetailView extends Component {
  Movie get _movie => props["movie"];

  void componentDidMount(rootNode) {

  }

  render() {
    return div({}, [
        img({"src": _movie.posterUri.toString()}),
        h2({}, [
            div({}, _movie.title),
            div({}, "(${_movie.releaseDate.year.toString()})")
        ]),
        div({}, _movie.rating),
        div({}, _movie.plot)
    ]);
  }

  renderMovie(Movie movie) {
    return li({}, [
        img({"src": movie.posterUri.toString()}),
        span({}, movie.title)
    ]);
  }
}