import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

const _base = 'https://image.tmdb.org/t/p/';

const _configuration = ConfigurationResponseDto(
  images: ImagesDto(
    secureBaseUrl: _base,
    posterSizes: ['w92', 'w500', 'original'],
    backdropSizes: ['w300', 'w780', 'w1280'],
    profileSizes: ['w45', 'w185'],
  ),
);

const _emptyMovies = PopularMoviesResponseDto(
  page: 1,
  totalPages: 0,
  totalResults: 0,
);

void main() {
  test('popular movies build poster urls from configuration', () async {
    final api = _FakeTmdbApi(_configuration)
      ..popularMovies = const PopularMoviesResponseDto(
        page: 1,
        totalPages: 3,
        totalResults: 40,
        results: [
          MovieDto(
            id: 550,
            title: 'Дюна',
            overview: 'Пустыня',
            posterPath: '/dune.jpg',
            voteAverage: 8.1,
            releaseDate: '2024-02-28',
          ),
          MovieDto(id: 2, title: 'Без постера'),
        ],
      );
    final repository = MovieRepositoryImpl(
      api: api,
      images: ImageConfigurationCache(),
    );

    final page = await repository.getPopularMovies();

    expect(page.page, 1);
    expect(page.totalPages, 3);
    expect(page.totalResults, 40);
    expect(page.items, hasLength(2));
    final withPoster = page.items.first;
    expect(withPoster.id, 550);
    expect(withPoster.title, 'Дюна');
    expect(withPoster.overview, 'Пустыня');
    expect(withPoster.voteAverage, 8.1);
    expect(withPoster.releaseDate, '2024-02-28');
    expect(withPoster.posterUrl, '${_base}w500/dune.jpg');
    expect(page.items[1].posterUrl, isNull);
    expect(api.configurationCalls, 1);

    await repository.getPopularMovies(2);
    expect(api.configurationCalls, 1);

    final images = await repository.getImageConfiguration();
    expect(images.posterSize, 'w500');
    expect(images.backdropSize, 'w780');
    expect(images.profileSize, 'w185');
    expect(api.configurationCalls, 1);
  });

  test('empty search returns an empty page', () async {
    final api = _FakeTmdbApi(_configuration)..searchMoviesPage = _emptyMovies;
    final repository = MovieRepositoryImpl(
      api: api,
      images: ImageConfigurationCache(),
    );

    final page = await repository.searchMovies('нет такого');

    expect(page.items, isEmpty);
    expect(page.page, 1);
    expect(page.totalPages, 0);
    expect(page.totalResults, 0);
  });

  test('three repositories share one image configuration', () async {
    final api = _FakeTmdbApi(_configuration)
      ..popularTv = const PopularTvResponseDto(
        page: 2,
        totalPages: 4,
        totalResults: 10,
        results: [
          TvShowDto(
            id: 9,
            name: 'Сериал',
            overview: 'Сюжет',
            posterPath: '/tv.jpg',
            voteAverage: 7,
            firstAirDate: '2020-01-02',
          ),
        ],
      )
      ..popularPeople = const PopularPeopleResponseDto(
        page: 1,
        totalPages: 1,
        totalResults: 2,
        results: [
          PersonDto(
            id: 3,
            name: 'Актёр',
            profilePath: '/face.jpg',
            knownForDepartment: 'Acting',
          ),
          PersonDto(id: 4, name: 'Без отдела', knownForDepartment: '   '),
        ],
      );
    final images = ImageConfigurationCache();
    final movies = MovieRepositoryImpl(api: api, images: images);
    final shows = TvRepositoryImpl(api: api, images: images);
    final people = PersonRepositoryImpl(api: api, images: images);

    await movies.getPopularMovies();
    final tvPage = await shows.getPopularTvShows();
    final peoplePage = await people.getPopularPeople();

    expect(api.configurationCalls, 1);
    final show = tvPage.items.single;
    expect(show.title, 'Сериал');
    expect(show.overview, 'Сюжет');
    expect(show.posterUrl, '${_base}w500/tv.jpg');
    expect(show.voteAverage, 7);
    expect(show.firstAirDate, '2020-01-02');
    expect(peoplePage.items.first.profileUrl, '${_base}w185/face.jpg');
    expect(peoplePage.items.first.knownForDepartment, 'Acting');
    expect(peoplePage.items[1].profileUrl, isNull);
    expect(peoplePage.items[1].knownForDepartment, isNull);
  });

  test('image sizes fall back the way the KMP mapper does', () async {
    final api = _FakeTmdbApi(
      const ConfigurationResponseDto(
        images: ImagesDto(
          secureBaseUrl: _base,
          posterSizes: ['w92', 'original'],
          backdropSizes: ['w300', 'original'],
          profileSizes: ['w45'],
        ),
      ),
    );
    final repository = MovieRepositoryImpl(
      api: api,
      images: ImageConfigurationCache(),
    );

    final images = await repository.getImageConfiguration();

    expect(images.posterSize, 'w500');
    expect(images.backdropSize, 'w300');
    expect(images.profileSize, 'w185');

    final onlyOriginal = _FakeTmdbApi(
      const ConfigurationResponseDto(
        images: ImagesDto(secureBaseUrl: _base, backdropSizes: ['original']),
      ),
    );
    final again = MovieRepositoryImpl(
      api: onlyOriginal,
      images: ImageConfigurationCache(),
    );
    final fallback = await again.getImageConfiguration();
    expect(fallback.backdropSize, 'w780');
    expect(fallback.posterSize, 'w500');
  });
}

final class _FakeTmdbApi implements TmdbApi {
  new(this.configuration);

  final ConfigurationResponseDto configuration;
  int configurationCalls = 0;
  PopularMoviesResponseDto popularMovies = _emptyMovies;
  PopularMoviesResponseDto searchMoviesPage = _emptyMovies;
  PopularTvResponseDto popularTv = const PopularTvResponseDto(
    page: 1,
    totalPages: 0,
    totalResults: 0,
  );
  PopularPeopleResponseDto popularPeople = const PopularPeopleResponseDto(
    page: 1,
    totalPages: 0,
    totalResults: 0,
  );

  @override
  Future<ConfigurationResponseDto> getConfiguration() async {
    configurationCalls += 1;
    return configuration;
  }

  @override
  Future<PopularMoviesResponseDto> getPopularMovies({required int page}) {
    return Future<PopularMoviesResponseDto>.value(popularMovies);
  }

  @override
  Future<PopularMoviesResponseDto> searchMovies({
    required String query,
    required int page,
  }) {
    return Future<PopularMoviesResponseDto>.value(searchMoviesPage);
  }

  @override
  Future<PopularTvResponseDto> getPopularTvShows({required int page}) {
    return Future<PopularTvResponseDto>.value(popularTv);
  }

  @override
  Future<PopularPeopleResponseDto> getPopularPeople({required int page}) {
    return Future<PopularPeopleResponseDto>.value(popularPeople);
  }

  @override
  Future<GenreListResponseDto> getMovieGenres() => _unused();

  @override
  Future<GenreListResponseDto> getTvGenres() => _unused();

  @override
  Future<PopularTvResponseDto> searchTvShows({
    required String query,
    required int page,
  }) => _unused();

  @override
  Future<PopularPeopleResponseDto> searchPeople({
    required String query,
    required int page,
  }) => _unused();

  @override
  Future<PopularMoviesResponseDto> discoverMovies({
    required int page,
    int? genreId,
    String? sortBy,
  }) => _unused();

  @override
  Future<PopularTvResponseDto> discoverTvShows({
    required int page,
    int? genreId,
    String? sortBy,
  }) => _unused();

  @override
  Future<MovieDetailsDto> getMovieDetails({required int id}) => _unused();

  @override
  Future<TvShowDetailsDto> getTvShowDetails({required int id}) => _unused();
}

Never _unused() => throw UnimplementedError();
