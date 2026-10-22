import 'dart:async';

import 'package:flutter/material.dart' hide ImageConfiguration;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/app/theme/tmdb_theme.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage_provider.dart';
import 'package:tmdb_flutter/data/account/account_providers.dart';
import 'package:tmdb_flutter/data/account/account_repository.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie_details.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/details/details_notifier.dart';
import 'package:tmdb_flutter/feature/details/details_state.dart';

const _card = MovieDetails(
  id: 550,
  title: 'Бойцовский клуб',
  overview: '',
  posterUrl: null,
  voteAverage: 8.4,
  releaseDate: null,
  runtime: null,
  genres: [],
  tagline: null,
  backdropUrl: null,
  originalTitle: null,
  status: null,
  originalLanguage: null,
  budget: 0,
  revenue: 0,
  cast: [],
  crew: [],
  videos: [],
  backdrops: [],
  posters: [],
  recommendations: [],
);

void main() {
  test('setFavorite error keeps the previous flag', () async {
    final account = _Account()
      ..favorite = true
      ..writeError = const TmdbHttpException(
        statusCode: 500,
        statusMessage: 'Сервис недоступен',
        httpStatusCode: 500,
      );
    final container = _container(account, signedIn: true)
      ..listen(_provider, (_, _) {});

    await _until(() => _read(container).isFavorite == true);
    await container.read(_provider.notifier).toggleFavorite();

    final state = _read(container);
    expect(state.isFavorite, isTrue);
    expect(state.isFavoriteLoading, isFalse);
    expect(state.favoriteMessage, 'Сервис недоступен');
    expect(account.writes, 1);
  });

  test('a second tap while setFavorite is running is ignored', () async {
    final account = _Account()..favorite = false;
    final container = _container(account, signedIn: true)
      ..listen(_provider, (_, _) {});
    await _until(() => _read(container).isFavorite == false);

    final notifier = container.read(_provider.notifier);
    final first = notifier.toggleFavorite();
    await _until(() => account.writes == 1);
    final second = notifier.toggleFavorite();
    await second;
    expect(account.writes, 1);

    account.gate.complete();
    await first;
    await _until(() => _read(container).isFavorite == true);
  });

  testWidgets('guest heart opens profile and skips account api', (
    tester,
  ) async {
    final account = _Account();
    final container = _container(account, signedIn: false);
    final router = _router();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: tmdbDarkTheme, routerConfig: router),
      ),
    );
    await _untilWidget(
      tester,
      () => _favoriteButton(tester, '☆ В избранное')?.onPressed != null,
    );

    await tester.tap(find.text('☆ В избранное'));
    await _untilWidget(
      tester,
      () => find.text('Логин TMDB').evaluate().isNotEmpty,
    );

    expect(account.reads, 0);
    expect(account.writes, 0);
    expect(find.text('Логин TMDB'), findsOneWidget);
  });

  testWidgets('failed setFavorite keeps the filled star on the card', (
    tester,
  ) async {
    final account = _Account()
      ..favorite = true
      ..writeError = const TmdbHttpException(
        statusCode: 500,
        statusMessage: 'Сервис недоступен',
        httpStatusCode: 500,
      );
    final container = _container(account, signedIn: true);
    final router = _router();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: tmdbDarkTheme, routerConfig: router),
      ),
    );
    await _untilWidget(
      tester,
      () => _favoriteButton(tester, '★ В избранном')?.onPressed != null,
    );

    await tester.tap(find.text('★ В избранном'));
    await _untilWidget(
      tester,
      () => find.text('Сервис недоступен').evaluate().isNotEmpty,
    );

    expect(find.text('★ В избранном'), findsOneWidget);
    expect(find.text('Сервис недоступен'), findsOneWidget);
    expect(_read(container).isFavorite, isTrue);
    expect(account.writes, 1);
  });
}

TextButton? _favoriteButton(WidgetTester tester, String label) {
  final finder = find.widgetWithText(TextButton, label);
  if (finder.evaluate().isEmpty) {
    return null;
  }
  return tester.widget<TextButton>(finder);
}

Future<void> _untilWidget(WidgetTester tester, bool Function() ready) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (ready()) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 50));
  }
  fail('details screen did not settle');
}

Future<void> _until(bool Function() ready) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (ready()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('details state did not settle');
}

final DetailsNotifierProvider _provider = detailsProvider(
  DetailsMediaType.movie,
  550,
);

GoRouter _router() {
  return GoRouter(
    initialLocation: '/movie/550',
    routes: [
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MovieRoute(id: id).build(context, state);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileRoute().build(context, state);
        },
        routes: [
          GoRoute(
            path: 'favorites',
            builder: (context, state) {
              return const FavoritesRoute().build(context, state);
            },
          ),
        ],
      ),
    ],
  );
}

DetailsState _read(ProviderContainer container) => container.read(_provider);

ProviderContainer _container(_Account account, {required bool signedIn}) {
  final stored = signedIn
      ? const StoredSession(sessionId: 'sid', accountId: 7, username: 'neo')
      : null;
  final container = ProviderContainer(
    overrides: [
      sessionStorageProvider.overrideWithValue(_Memory(stored)),
      movieRepositoryProvider.overrideWithValue(_Movies()),
      accountRepositoryProvider.overrideWithValue(account),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

final class _Memory implements SessionStorage {
  new([this._session]);

  final StoredSession? _session;

  @override
  Future<StoredSession?> read() async => _session;

  @override
  Future<void> write(StoredSession session) async {}

  @override
  Future<void> clear() async {}
}

final class _Account implements AccountRepository {
  final gate = Completer<void>();
  bool favorite = false;
  Exception? writeError;
  int reads = 0;
  int writes = 0;

  @override
  Future<bool> isFavorite(int movieId) async {
    reads += 1;
    return favorite;
  }

  @override
  Future<void> setFavorite({
    required int movieId,
    required bool favorite,
  }) async {
    writes += 1;
    final error = writeError;
    if (error != null) {
      throw error;
    }
    await gate.future;
    this.favorite = favorite;
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async => const [];
}

final class _Movies implements MovieRepository {
  @override
  Future<MovieDetails> getMovieDetails(int movieId) async => _card;

  @override
  Future<List<Genre>> getMovieGenres() => _unused();

  @override
  Future<Paged<Movie>> getPopularMovies([int page = 1]) => _unused();

  @override
  Future<Paged<Movie>> searchMovies(String query, [int page = 1]) {
    return _unused();
  }

  @override
  Future<Paged<Movie>> discoverMovies({
    int? genreId,
    String? sortBy,
    int page = 1,
  }) => _unused();

  @override
  Future<ImageConfiguration> getImageConfiguration() => _unused();
}

Never _unused() => throw UnimplementedError();
