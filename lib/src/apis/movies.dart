part of isomorphic_dart.apis;

abstract class MoviesApi {
  Future<Map> getMovie(id);

  Future<Iterable<Map>> search(String term);
}