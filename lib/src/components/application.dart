part of isomorphic_dart;

typedef ApplicationView({String path});

var _applicationView = registerComponent(() => new _ApplicationView());

ApplicationView applicationView = ({String path}) => _applicationView({"path": path});

class _ApplicationView extends Component {
  String get _path => props["path"];

  final _search = new Subject<String>();

  void componentDidMount(rootNode) {
    _search.stream.listen((text) => print("submit: $text"));
  }

  render() {
    return div({}, [
        h1({}, "IMDB Dart"),
        _renderPath(_path),
    ]);
  }

  _renderPath(String path) {
    if (path == "/") {
      return homeView(_search);
    } else if (path.startsWith("/search")) {

    } else {
      throw new ArgumentError("Undefined route `$path`");
    }
  }
}