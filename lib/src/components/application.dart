part of isomorphic_dart;

var applicationView = registerComponent(() => new ApplicationView());

class ApplicationView extends Component {
  render() => div({}, "My application");
}