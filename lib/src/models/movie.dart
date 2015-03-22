part of isomorphic_dart;

class Movie {
  final Map<String, Object> _json;

  String get id => _json["imdbID"];
  Iterable<String> get actors => _json["Actors"].split(",");
  String get director => _json["Director"];
  Uri get posterUri => _json.containsKey("Poster") ? Uri.parse(_json["Poster"]) : null;
  String get rating => _json["Rating"];
  DateTime get releaseDate => DateTime.parse(_json["Released"]);
  String get title => _json["Title"];
  String get plot => _json["Plot"];

  Movie._(this._json);

  factory Movie.fromJson(Map<String, Object> json) => new Movie._(json);
}

// Example JSON response

//{
//  "Actors": "Tom Cruise, Kelly McGillis, Val Kilmer, Anthony Edwards",
//  "Awards": "Won 1 Oscar. Another 9 wins & 5 nominations.",
//  "Country": "USA",
//  "Director": "Tony Scott",
//  "Genre": "Action, Drama, Romance",
//  "Language": "English",
//  "Metascore": "N/A",
//  "Plot": "As students at the Navy's elite fighter weapons school compete to be best in the class, one daring young flyer learns a few things from a civilian instructor that are not taught in the classroom.",
//  "Poster": "http://ia.media-imdb.com/images/M/MV5BMTY3ODg4OTU3Nl5BMl5BanBnXkFtZTYwMjI1Nzg4._V1_SX300.jpg",
//  "Rated": "PG",
//  "Released": "1986-05-16",
//  "Response": "True",
//  "Runtime": "110 min",
//  "Title": "Top Gun",
//  "Type": "movie",
//  "Writer": "Jim Cash, Jack Epps Jr., Ehud Yonay (magazine article \"Top Guns\")",
//  "Year": "1986",
//  "imdbID": "tt0092099",
//  "imdbRating": "6.8",
//  "imdbVotes": "188,869"
//}