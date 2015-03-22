import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:redstone/server.dart' as app;
import 'package:react/react.dart';
import 'package:react/react_server.dart' as react_server;
import 'package:isomorphic_dart/isomorphic_dart.dart';
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

  app.setShelfHandler(createStaticHandler("../web", serveFilesOutsidePath: true));

  app.setupConsoleLog();
  app.start(address: "localhost", port: port);
}

@app.Route("/", responseType: "text/html")
String root() => renderTemplate("/");

@app.Route("/search/:query", responseType: "text/html")
Future<String> searchMovie(String query) {
  var uri = Uri.parse("http://www.omdbapi.com/?s=$query");
  var request = http.read(uri)
      .then((body) => JSON.decode(body)["Search"])
      .then((movies) => movies.map((movie) => movie["imdbID"]))
      .then((ids) => Future.wait(ids.map((id) => getMovie(id))));

  return request.then((movies) => renderTemplate("/search", data: {
      "term": Uri.decodeQueryComponent(query),
      "movies": movies
  }));
}

@app.Route("/movie/:id", responseType: "text/html")
Future<String> movie(String id) {
  return getMovie(id).then((movie) {
    return renderTemplate("/movie", data: {"movie": movie});
  });
}

String renderTemplate(String path, {Map data: const {}}) {
  return """
      <html>
      <head>
        <title>IMDB Dart</title>
      </head>
      <body>
        ${renderToString(applicationView(path: path, data: data))}
        <script src="packages/react/react.js"></script>
        <script type="application/dart" src="main.dart"></script>
        <script src="packages/browser/dart.js"></script>
      </body>
      </html>
      """;
}

Future<Movie> getMovie(id) {
  var uri = Uri.parse("http://www.omdbapi.com/?i=$id");
  return http.read(uri)
      .then((data) => JSON.decode(data))
      .then((json) => new Movie.fromJson(json));
}
