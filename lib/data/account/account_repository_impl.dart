import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/account/account_api.dart';
import 'package:tmdb_flutter/data/account/account_exception.dart';
import 'package:tmdb_flutter/data/account/account_repository.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/movie_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

/// [AccountRepository] that reads favorites through [AccountApi].
final class AccountRepositoryImpl implements AccountRepository {
  /// Creates a repository for the signed-in account.
  ///
  /// [catalog] is used only to load image configuration for posters.
  const new({
    required this.api,
    required this.sessions,
    required this.images,
    required this.catalog,
  });

  /// Remote account API.
  final AccountApi api;

  /// Session used to reject guests before a request.
  final SessionRepository sessions;

  /// Process-wide image configuration.
  final ImageConfigurationCache images;

  /// Catalog API that serves `GET configuration`.
  final TmdbApi catalog;

  @override
  Future<bool> isFavorite(int movieId) async {
    await _requireAccountId();
    return await _guard(() => api.isFavorite(movieId: movieId));
  }

  @override
  Future<void> setFavorite({
    required int movieId,
    required bool favorite,
  }) async {
    final accountId = await _requireAccountId();
    await _guard(
      () => api.setFavorite(
        accountId: accountId,
        movieId: movieId,
        favorite: favorite,
      ),
    );
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    final accountId = await _requireAccountId();
    final configuration = await images.require(catalog);
    final movies = <Movie>[];
    var page = 1;
    var totalPages = 1;
    do {
      final response = await _guard(
        () => api.getFavoriteMovies(accountId: accountId, page: page),
      );
      movies.addAll(mapMoviePage(response, configuration).items);
      totalPages = response.totalPages;
      page += 1;
    } while (page <= totalPages);
    return movies;
  }

  Future<int> _requireAccountId() async {
    final sessionId = await sessions.getSessionId();
    final account = await sessions.readAuthenticated();
    if (sessionId == null || account == null) {
      throw const AccountAuthorizationException();
    }
    return account.accountId;
  }

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on TmdbHttpException catch (error) {
      if (error.httpStatusCode == 401) {
        await sessions.logout();
      }
      rethrow;
    }
  }
}
