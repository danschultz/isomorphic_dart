part of isomorphic_dart.components;

typedef HomeView(Subject<String> search);

var _homeView = registerComponent(() => new _HomeView());

HomeView homeView = (Subject<String> search) => _homeView({"search": search});

class _HomeView extends Component {
  Subject<String> get _search => props["search"];

  render() {
    return div({"className": "home"}, [searchView(_search)]);
  }
}