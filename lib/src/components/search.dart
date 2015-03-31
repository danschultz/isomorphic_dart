part of isomorphic_dart.components;

typedef SearchView(Subject<String> submit, {String text});

var _searchView = registerComponent(() => new _SearchView());

SearchView searchView = (Subject<String> submit, {String text: ""}) => _searchView({"submit": submit, "text": text});

class _SearchView extends Component {
  Subject<String> get _submit => props["submit"];
  String get _text => state["text"];

  final _onChange = new Subject<SyntheticFormEvent>(sync: true);
  final _onSubmit = new Subject<SyntheticFormEvent>(sync: true);

  Map getInitialState() => {"text": props["text"]};

  void componentDidMount(rootNode) {
    _onChange.stream
        .map((event) => event.target.value)
        .listen((text) => setState({"text": text}));

    _onSubmit.stream
        .doAction((event) => event.preventDefault())
        .map((_) => _text)
        .listen((text) => _submit(text));
  }

  render() {
    return form({"className": "search tile", "action": "/search", "method": "get", "onSubmit": _onSubmit}, [
        div({}, "Search for a movie or TV show"),
        input({"className": "search-field", "type": "text", "name": "q", "onChange": _onChange, "value": _text}),
        div({}, [
            button({"className": "search-button", "type": "submit"}, "Search")
        ])
    ]);
  }
}