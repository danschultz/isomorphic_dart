part of isomorphic_dart.components;

typedef SearchView(Subject<String> submit);

var _searchView = registerComponent(() => new _SearchView());

SearchView searchView = (Subject<String> submit) => _searchView({"submit": submit});

class _SearchView extends Component {
  Subject<String> get _submit => props["submit"];
  String get _text => state["text"];

  final _onChange = new Subject<SyntheticFormEvent>();
  final _onSubmit = new Subject<SyntheticFormEvent>();

  Map getInitialState() => {"text": ""};

  void componentDidMount(rootNode) {
    _onChange.stream
        .map((event) => event.target.value)
        .listen((text) => setState({"text": text}));

    _onSubmit.stream
        .map((_) => _text)
        .listen((text) => _submit(text));
  }

  render() {
    return div({"className": "search tile"}, [
        div({}, "Search for a movie or TV show"),
        input({"className": "search-field", "type": "text", "onChange": _onChange}, _text),
        div({}, [
            button({"className": "search-button", "onClick": _onSubmit}, "Search")
        ])
    ]);
  }
}