# An isomorphic Dart app

An isomorphic web app using Dart and React. Search for and list information about movies and TV shows. Checkout the working demo [here][demo].

[![Screenshot](screenshot.jpg)][demo]

## Features

* [x] *Server side rendering.* All entry points are rendered using React components. These entry points include:
  * `/`
  * `/search`
  * `/search/?q=:movie_name`
  * `/movie/:movie_id`
* [x] *Progressive enhancement.* The app doesn't require client-side Dart or JS to function. All search fields and links will work in cases where the client-side code is still downloading, or the user has disabled JS.
* [x] *History API.* Client updates the browser's history API on screen transitions, and responds to history changes.
* [x] *Isomorphic routing.* The same routing code is used on the server and client.

## Why Isomorphic?

Single page applications are great for developers and for users. For developers, it offers a clean separation of concerns. Backend logic is isolated to the server, and view logic is isolated to the client, with the two communicating through some API. For users, it means navigation can happen quickly between different pages without having to do a full refresh of the page.

There's a hitch though. Since the server is delegating what needs to be rendered to the client, the browser has to wait for the necessary JavaScript to load before it can start rendering. The client may also need to make additional requests to the API to load additional data.

There's quite a bit of data out there that correlates perceived page load times to convertion rates. Kiss Metrics [claims](https://blog.kissmetrics.com/loading-time/) that every second in loading your page results in a 7% decrease in conversion. And, [According to Amazon](http://www.radware.com/Products/FastView/), every 100ms decrease in page load time, increases conversion by 1%.

This is where an isomorphic approach comes in. The server sends fully-formed HTML to the browser for fast perceived performance. Once the JavaScript loads, the client takes over so we get the benefits of a single page application.

## Architecture

### Shared view components on the server and client

React's uses a virtual DOM for rendering, which allows views to be used on the client or server. The server renders the fully-formed HTML using `React.renderToString()`. Once the JavaScript is loaded, the client takes over and installs the necessary event handlers using `React.render()`.

### Initializing the client from server state

When the client is initialized, React replaces the DOM provided by the server. In order for the client to render the same DOM as the server, it needs to have the same state the server used for rendering. To do this, the server writes its state as a JSON object in a script tag. The client then reads the JSON from the script tag and uses it to render the DOM.

### Rerendering state changes

DOM rendering is treated as a stateless function, with the `State` object being used to represent the view's state. `State` objects are passed to an `ApplicationView` component which it uses for generating the DOM.

To trigger state changes, the `ApplicationView` is also passed a `StreamController`. When a user performs some interaction, the view adds an `Action` onto this stream controller. `Action`s are just closures that are passed the current state and return a new state. The application listens to actions added to the controller's stream, invokes them, and rerenders the view. You can think of this as an endless cycle of `Render -> User Action -> State Modification -> Render`.

### Dependencies on `dart:html` and `dart:io`

In order for React components to be reused on the client and server, special care needs to be given so they don't depend on `dart:html` or `dart:io`. This app requires network calls to an external movies API, which depending on the environment, will either need to use the network classes from `dart:io` or `dart:html`. To solve this, the `MoviesApi` uses factories for generating the appropriate request objects depending on if we're in a server or browser environment.

## Running

Checkout the working demo [here][demo]. Otherwise, if you want to run it locally, there's a couple options listed below.

### App Engine (default)

Take a look at Dart's AppEngine [guide](https://www.dartlang.org/server/google-cloud-platform/app-engine/) for setting up Docker and AppEngine for Dart.

* Run `boot2docker up`
* Run `$(boot2docker shellinit)`
* Run `gcloud preview app run app.yaml`
* Run `pub serve web --hostname 192.168.59.3 --port 7777` in another terminal window
* Open `http://localhost:8080` in your browser

### Without App Engine (Non-Dartium)

* Run `pub build`
* Run `dart bin/server.dart --no-app-engine --serve-dir build/`
* Open `http://localhost:8080` in your browser

### Without App Engine (Dartium)

* Run `dart bin/server.dart --no-app-engine`
* Open `http://localhost:8080` in your Dartium

[demo]: http://isomorphic-dart-demo.appspot.com
