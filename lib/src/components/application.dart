part of isomorphic_dart;

typedef ApplicationView({String path, Map data});

var _applicationView = registerComponent(() => new _ApplicationView());

ApplicationView applicationView = ({String path, Map data}) => _applicationView({"path": path, "data": data});

class _ApplicationView extends Component {
  String get _path => props["path"];
  Map get _data => props["data"];

  final _search = new Subject<String>();

  void componentDidMount(rootNode) {
    _search.stream.listen((text) => print("submit: $text"));
  }

  render() {
    return div({}, [
        h1({}, "IMDB Dart"),
        _renderPath(_path, _data),
    ]);
  }

  _renderPath(String path, Map data) {
    if (path == "/") {
      return homeView(_search);
    } else if (path.startsWith("/search")) {
      return searchResultsView(data["term"], data["movies"]);
    } else if (path.startsWith("/movie")) {
      return movieDetailView(data["movie"]);
    } else {
      throw new ArgumentError("Undefined route `$path`");
    }
  }
}