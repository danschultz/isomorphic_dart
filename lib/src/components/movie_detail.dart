part of isomorphic_dart.components;

typedef MovieDetailView(Movie movie);

var _movieDetailView = registerComponent(() => new _MovieDetailView());

MovieDetailView movieDetailView = (Movie movie) => _movieDetailView({"movie": movie});

class _MovieDetailView extends Component {
  Movie get _movie => props["movie"];

  render() {
    return div({"className": "tile movie movie-detail"}, [
        posterImageView({"posterUri": _movie.posterUri}),
        div({}, [
            div({}, [
                h2({}, [_movie.title, span({"className": "title-year"}, " (${_movie.year})")]),
            ]),
            div({"className": "movie-meta-items"}, [
                div({"className": "movie-meta"}, _movie.rating),
                div({"className": "movie-meta"}, _movie.runtime),
                div({"className": "movie-meta"}, _movie.releaseDate),
            ]),
            div({}, _movie.plot),
            div({"className": "movie-credits"}, [
              div({"className": "movie-credit"}, [
                strong({}, "Director: "),
                _movie.director
              ]),
              div({"className": "movie-credit"}, [
                strong({}, "Stars: "),
                _movie.actors.join(", ")
              ])
            ])
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