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

  var serverData = JSON.decode(document.querySelector("#server-data").text);
  var initialState = new State.fromJson(serverData);

  var updates = new Subject<Action<State>>.broadcast();
  var appState = updates.stream.scan(initialState, (state, action) => action(state));
  var historyState = window.onPopState
      .map((event) => JSON.decode(event.state))
      .map((json) => new State.fromJson(json));

  // Render the application with the updated state.
  appState.merge(historyState).listen((state) {
    var view = applicationView(state: state, updates: updates, clientFactory: () => new BrowserClient());
    render(view, document.querySelector("#application"));
  });

  // Replace the current history with the state given by the server.
  appState.take(1).listen((state) {
    window.history.replaceState(JSON.encode(state), window.name, state.path);
  });

  // Append additional route changes to the history.
  appState.skip(1)
      .distinct((a, b) => a.path == b.path)
      .listen((state) {
        window.history.pushState(JSON.encode(state), window.name, state.path);
      });
}
