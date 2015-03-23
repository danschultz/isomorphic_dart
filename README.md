# An isomorphic Dart app

An isomorphic web app using Dart and React. Search for and list information about movies and TV shows.

## Features

* [x] *Server side rendering.* All entry points are rendered using React components. These entry points include:
  * `/`
  * `/search/:movie_name`
  * `/movie/:imdb_id`
* [ ] *Progressive enhancement.* The app doesn't require client-side Dart or JS to function. All search fields and links will work in cases where the client-side code is still downloading, or the user has disabled JS.
* [x] *History API.* Client updates the browser's history API on screen transitions, and responds to history changes. The application stores its full state as a memento in the browser's history stack, so the application can be fully restored on browser back/forward actions.
* [x] *Isomorphic routing.* The same routing code is used on the server and client.
* [ ] *Animations.* Animate HTML elements when transitioning between different routes.

## Running

* `dart bin/server.dart`
* Open `http://localhost:8080` in your browser.
