// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:react/react.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:isomorphic_dart/isomorphic_dart.dart';

void main() {
  react_client.setClientConfiguration();

  var path = Uri.parse(window.location.href).path;
  render(applicationView(path: path), document.body);
}
