part of isomorphic_dart.components;

typedef HomeView(Subject<String> submit);

var _homeView = registerComponent(() => new _HomeView());

HomeView homeView = (Subject<String> submit) => _homeView({"submit": submit});

class _HomeView extends Component {
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
    return div({}, [
        input({"type": "text", "onChange": _onChange}, _text),
        button({"onClick": _onSubmit}, "Search")
    ]);
  }
}