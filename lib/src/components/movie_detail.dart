part of isomorphic_dart.components;

typedef MovieDetailView(Movie movie);

var _movieDetailView = registerComponent(() => new _MovieDetailView());

MovieDetailView movieDetailView = (Movie movie) => _movieDetailView({"movie": movie});

class _MovieDetailView extends Component {
  Movie get _movie => props["movie"];

  void componentDidMount(rootNode) {

  }

  render() {
    return div({"className": "tile movie movie-detail"}, [
        posterImageView({"posterUri": _movie.posterUri}),
        div({}, [
            div({}, [
                h2({}, [_movie.title, span({"className": "title-year"}, " (${_movie.year})")]),
            ]),
            div({}, [
                div({}, _movie.rating),
                div({}, _movie.runtime),
                div({}, _movie.releaseDate),
            ]),
            div({}, _movie.plot),
            div({}, [
                strong({}, "Director: "),
                _movie.director
            ]),
            div({}, [
                strong({}, "Stars: "),
                _movie.actors.join(", ")
            ]),
        ])
    ]);
  }

  renderMovie(Movie movie) {
    return li({}, [
        img({"src": movie.posterUri.toString()}),
        span({}, movie.title)
    ]);
  }
}