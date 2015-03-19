import 'dart:io';

import 'package:args/args.dart';
import 'package:redstone/server.dart' as app;
import 'package:react/react.dart';
import 'package:react/react_server.dart' as react_server;
import 'package:isomorphic_dart/isomorphic_dart.dart';

void main(List<String> args) {
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  react_server.setServerConfiguration();

  app.setupConsoleLog();
  app.start(address: "localhost", port: port);
}

@app.Route("/", responseType: "text/html")
String root() => renderToString(applicationView({}));
