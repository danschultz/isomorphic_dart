import 'dart:io';

import 'package:args/args.dart';
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

@app.Route("/search", responseType: "text/html")
String search() => renderTemplate("/search");

@app.Route("/movies", responseType: "text/html")
String movie() => renderTemplate("/movies");

String renderTemplate(String path) {
  return """
      <html>
      <head>
        <title>IMDB Dart</title>
      </head>
      <body>
        ${renderToString(applicationView(path: path))}
        <script src="packages/react/react.js"></script>
        <script type="application/dart" src="main.dart"></script>
        <script src="packages/browser/dart.js"></script>
      </body>
      </html>
      """;
}
