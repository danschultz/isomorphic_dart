// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:html';
import 'package:http/browser_client.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:isomorphic_dart/isomorphic_dart.dart';

void main() {
  react_client.setClientConfiguration();

  var path = Uri.parse(window.location.href).path;
  var serverData = document.querySelector("#server-data").text;
  var data = JSON.decode(serverData);
  var view = applicationView(path: path, data: data, clientFactory: () => new BrowserClient());
  render(view, document.querySelector("#application"));
}
