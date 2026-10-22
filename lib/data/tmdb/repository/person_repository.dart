import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_details.dart';

/// People from lists, search, and person details.
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

  /// Person card for [personId], including combined credits.
  Future<PersonDetails> getPersonDetails(int personId);
}
