part of isomorphic_dart.components;

typedef PosterImageView(Uri posterUri);

var posterImageView = registerComponent(() => new _PosterImageView());

//PosterImageView posterImageView = (Uri posterUri) => _posterImageView({"posterUri": posterUri});

class _PosterImageView extends Component {
  Uri get _posterUri => props["posterUri"];

  render() {
    var children = _posterUri != null ? [img({"src": _posterUri.toString()})] : [];
    return div({"className": "poster-image"}, children);
  }
}