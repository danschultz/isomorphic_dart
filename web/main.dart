// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:html';
import 'package:frappe/frappe.dart';
import 'package:http/browser_client.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:isomorphic_dart/isomorphic_dart.dart';
import 'package:isomorphic_dart/src/util/async.dart';

void main() {
  react_client.setClientConfiguration();

  var path = Uri.parse(window.location.href).path;
  var serverData = document.querySelector("#server-data").text;
  var data = JSON.decode(serverData);
  var initialState = new State(path, data);

  var updates = new Subject<Action<State>>.broadcast();
  var state = updates.stream.scan(initialState, (state, action) => action(state));
  var historyState = window.onPopState
      .map((event) => JSON.decode(event.state))
      .map((json) => new State.fromJson(json));

  // Render the application with the updated state.
  state.merge(historyState).listen((state) {
    var view = applicationView(state: state, updates: updates, clientFactory: () => new BrowserClient());
    render(view, document.querySelector("#application"));
  });

  // Append the new route to the history.
  state
      .distinct((a, b) => a.path == b.path)
      .listen((state) {
        window.history.pushState(JSON.encode(state), window.name, state.path);
      });
}
