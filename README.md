# An isomorphic Dart app

An isomorphic web app using Dart and React. Search for and list information about movies and TV shows.

## Features

* [x] *Server side rendering.* All entry points are rendered using React components. These entry points include:
  * `/`
  * `/search/:movie_name`
  * `/movie/:imdb_id`
* [x] *Progressive enhancement.* The app doesn't require client-side Dart or JS to function. All search fields and links will work in cases where the client-side code is still downloading, or the user has disabled JS.
* [x] *History API.* Client updates the browser's history API on screen transitions, and responds to history changes. The application stores its full state as a memento in the browser's history stack, so the application can be fully restored on browser back/forward actions.
* [x] *Isomorphic routing.* The same routing code is used on the server and client.
* [ ] *Animations.* Animate HTML elements when transitioning between different routes.

## Challenges

* Initializing the client from server state.
  * Issue: When the client is initialized, React will replace the DOM provided by the server. In order for the client to render the same DOM as the server, the client needs to have the same state as the server for rendering.
  * Solution: The server writes the state as a JSON object in a script tag. The client reads the JSON from the script tag and uses it to render the DOM.
* Rerendering state changes.
  * Issue: State changes need to trigger a rerender of the DOM. State changes can happen either through user interaction within the app, or from an `onPopState` event from the browser. It'd be ideal if both of these scenarios could be handled from a central location.
  * Solution: Use a stream controller to handle state changes triggered by interactions within the app. The stream controller is passed to the `ApplicationView` which adds `Action`s that encapsulate a state change. Each action returns a new `State` object when invoked. By merging the action stream with the `onPopState` stream, we can tell React to rerender the DOM from a single location in the app.
* History state serialization
* Dependencies on `dart:html` and `dart:io`.

## Running

* Run `dart bin/server.dart`
* Open `http://localhost:8080` in your browser
