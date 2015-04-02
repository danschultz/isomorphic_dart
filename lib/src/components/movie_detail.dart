part of isomorphic_dart.components;

typedef MovieDetailView(Movie movie);

var _movieDetailView = registerComponent(() => new _MovieDetailView());

MovieDetailView movieDetailView = (Movie movie) => _movieDetailView({"movie": movie});

class _MovieDetailView extends Component {
  Movie get _movie => props["movie"];

  render() {
    return div({"className": "tile movie movie-detail"}, [
        posterImageView(_movie.posterUri),
        div({}, [
            div({}, [
                h2({}, [_movie.title, span({"className": "title-year"}, " (${_movie.year})")]),
            ]),
            div({"className": "movie-meta-items"}, [
                div({"className": "movie-meta"}, "Rated: ${_movie.rating}"),
                div({"className": "movie-meta"}, "Runtime: ${_movie.runtime} min"),
                div({"className": "movie-meta"}, "Released: ${_movie.releaseDate}"),
            ]),
            hr({"className": "separator"}),
            div({}, _movie.plot),
            div({"className": "movie-credits"}, [
              div({"className": "movie-credit"}, [
                strong({}, "Director: "),
                _movie.credits.director
              ]),
              div({"className": "movie-credit"}, [
                strong({}, "Stars: "),
                _movie.credits.cast.take(3).join(", ")
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