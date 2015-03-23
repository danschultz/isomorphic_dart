part of isomorphic_dart.models;

class State {
  final String path;
  final Map data;

  State(this.path, this.data);

  factory State.fromJson(Map json) => new State(json["path"], json["data"]);

  Map toJson() => {
    "path": path,
    "data": data,
  };
}