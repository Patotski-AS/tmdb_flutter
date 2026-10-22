import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';

/// People from the popular and search lists.
///
/// Failures are thrown as [TmdbException].
abstract interface class PersonRepository {
  /// Popular people.
  ///
  /// [page] starts at 1.
  Future<Paged<Person>> getPopularPeople([int page = 1]);

  /// People matching [query].
  ///
  /// [page] starts at 1.
  Future<Paged<Person>> searchPeople(String query, [int page = 1]);
}
