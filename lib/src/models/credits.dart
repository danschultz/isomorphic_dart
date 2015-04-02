part of isomorphic_dart.models;

class Credits {
  final Map<String, Object> _json;

  Iterable<String> get cast => _json["cast"].map((member) => member["name"]);

  String get director {
    Iterable<Map> crew = _json["crew"];
    var match = crew.firstWhere((member) => member["job"] == "Director", orElse: () => null);
    return match != null ? match["name"] : null;
  }

  Credits._(this._json);

  factory Credits.fromJson(Map<String, Object> json) => new Credits._(json);
}