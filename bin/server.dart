import 'dart:async';
import 'dart:convert';
import 'package:appengine/appengine.dart';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:redstone/server.dart' as app;
import 'package:react/react.dart';
import 'package:react/react_server.dart' as react_server;
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_appengine/shelf_appengine.dart' as shelf_ae;
import 'package:isomorphic_dart/src/apis.dart';

void main(List<String> args) {
  var parser = new ArgParser();
  parser
      ..addOption('serve-dir', defaultsTo: "web")
      ..addOption("host", defaultsTo: "localhost")
      ..addOption("port", defaultsTo: "8080")
      ..addFlag("app-engine", defaultsTo: true);

  var params = parser.parse(args);

  react_server.setServerConfiguration();

  app.setupConsoleLog();
  app.setUp();

  if (params["app-engine"]) {
    app.setShelfHandler(shelf_ae.assetHandler(
        directoryIndexServeMode: shelf_ae.DirectoryIndexServeMode.SERVE));
    runAppEngine((req) => app.handleRequest(req));
  } else {
    app.setShelfHandler(createStaticHandler(params["serve-dir"], serveFilesOutsidePath: true));
    app.start(address: params["host"], port: int.parse(params["port"]), autoCompress: true);
  }
}

@app.Route("/", responseType: "text/html")
String root() => renderTemplate(new State("/", {}));

@app.Route("/search", responseType: "text/html")
searchMovieWithQuery(@app.QueryParam("q") String query) async {
  var movieApi = new TmdbMoviesApi(() => new http.IOClient());
  var path = app.request.url.toString();

  return renderTemplate(new State(path, {
    "term": query != null ? Uri.decodeQueryComponent(query) : "",
    "movies": await movieApi.search(query)
  }));
}

@app.Route("/movie/:id", responseType: "text/html")
Future<String> movie(String id) async {
  var path = app.request.url.path;
  var omdbApi = new TmdbMoviesApi(() => new http.IOClient());
  return renderTemplate(new State(path, {"movie": await omdbApi.getMovie(id)}));
}

String renderTemplate(State state) {
  var serverData = JSON.encode(state);
  return """
<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <title>IMDB Dart</title>
  <link type="text/css" rel="stylesheet" href="/styles/normalize.css">
  <link type="text/css" rel="stylesheet" href="/styles/main.css">
  <script id="server-data" type="application/json">$serverData</script>
</head>
<body>
  <a href="https://github.com/danschultz/isomorphic_dart"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"></a>
  <div id="application" class="viewport">
    ${renderToString(applicationView(state: state))}
  </div>
  <script src="/packages/react/react_prod.js"></script>
  <script type="application/dart" src="/main.dart"></script>
  <script src="/packages/browser/dart.js"></script>
</body>
</html>
""";
}

