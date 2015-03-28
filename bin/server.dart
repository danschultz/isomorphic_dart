import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:redstone/server.dart' as app;
import 'package:react/react.dart';
import 'package:react/react_server.dart' as react_server;
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:isomorphic_dart/src/service/omdb.dart';
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) {
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  react_server.setServerConfiguration();

  app.setShelfHandler(createStaticHandler("web", serveFilesOutsidePath: true));
  app.setupConsoleLog();
  app.start(address: "localhost", port: port);
}

@app.Route("/", responseType: "text/html")
String root() => renderTemplate(new State("/", {}));

@app.Route("/search/:query", responseType: "text/html")
Future<String> searchMovie(String query) async {
  var omdbApi = new OmdbClient(() => new http.IOClient());
  var path = app.request.url.path;

  return renderTemplate(new State(path, {
    "term": Uri.decodeQueryComponent(query),
    "movies": await omdbApi.search(query)
  }));
}

@app.Route("/search", responseType: "text/html")
void searchMovieWithQuery(@app.QueryParam("q") String query) {
  // Forward /search?q=movie to /search/movie to have pretty URLs
  return app.redirect("/search/${Uri.encodeQueryComponent(query)}");
}

@app.Route("/movie/:id", responseType: "text/html")
Future<String> movie(String id) async {
  var path = app.request.url.path;
  var omdbApi = new OmdbClient(() => new http.IOClient());
  return renderTemplate(new State(path, {"movie": await omdbApi.getMovie(id)}));
}

String renderTemplate(State state) {
  var serverData = JSON.encode(state);
  return """
<html>
<head>
  <title>IMDB Dart</title>
  <link type="text/css" rel="stylesheet" href="/styles/normalize.css">
  <link type="text/css" rel="stylesheet" href="/styles/main.css">
  <script id="server-data" type="application/json">$serverData</script>
</head>
<body>
  <div id="application">
    ${renderToString(applicationView(state: state))}
  </div>
  <script src="/packages/react/react.js"></script>
  <script type="application/dart" src="/main.dart"></script>
  <script src="/packages/browser/dart.js"></script>
</body>
</html>
""";
}

