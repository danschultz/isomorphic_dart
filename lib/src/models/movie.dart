part of isomorphic_dart.models;

class Movie {
  final Map<String, Object> _json;

  int get id => _json["id"];
  String get posterPath => _json["poster_path"];
  String get rating {
    var releases = _json["releases"];
    var countries = releases != null ? releases["countries"] : null;
    var primary = countries.firstWhere((country) => country["primary"], orElse: null);
    return primary != null ? primary["certification"] : "Unrated";
  }
  String get releaseDate => _json["release_date"];
  String get year => releaseDate.split("-").first;
  String get title => _json["title"];
  String get plot => _json["overview"];
  int get runtime => _json["runtime"];
  Credits get credits => new Credits.fromJson(_json["credits"]);

  Uri get posterUri {
    if (posterPath != null) {
      var baseUri = Uri.parse("https://image.tmdb.org/t/p/w185");
      var path = baseUri.pathSegments.toList()..add(posterPath.split("/").last);
      return baseUri.replace(pathSegments: path);
    } else {
      return null;
    }
  }

  Movie._(this._json);

  factory Movie.fromJson(Map<String, Object> json) => new Movie._(json);

  Map toJson() => new Map.from(_json);
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