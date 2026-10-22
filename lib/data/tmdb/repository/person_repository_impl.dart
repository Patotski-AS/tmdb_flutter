import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/person_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

/// [PersonRepository] that maps TMDB list payloads.
final class PersonRepositoryImpl implements PersonRepository {
  /// Creates a repository that reads people through [api].
  ///
  /// Profile URLs use the shared [images] cache.
  const new({required this.api, required this.images});

  /// Remote catalog API.
  final TmdbApi api;

  /// Process-wide image configuration.
  final ImageConfigurationCache images;

  @override
  Future<Paged<Person>> getPopularPeople([int page = 1]) {
    return _load(() => api.getPopularPeople(page: page));
  }

  @override
  Future<Paged<Person>> searchPeople(String query, [int page = 1]) {
    return _load(() => api.searchPeople(query: query, page: page));
  }

  Future<Paged<Person>> _load(
    Future<PopularPeopleResponseDto> Function() load,
  ) async {
    final configuration = await images.require(api);
    return mapPersonPage(await load(), configuration);
  }
}
