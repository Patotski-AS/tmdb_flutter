import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';

void main() {
  test('sort values match the KMP MediaSortOption', () {
    expect(
      MediaSortOption.popularity.sortBy(MediaContentType.movies),
      'popularity.desc',
    );
    expect(
      MediaSortOption.popularity.sortBy(MediaContentType.people),
      'popularity.desc',
    );
    expect(
      MediaSortOption.releaseDate.sortBy(MediaContentType.movies),
      'primary_release_date.desc',
    );
    expect(
      MediaSortOption.releaseDate.sortBy(MediaContentType.tv),
      'first_air_date.desc',
    );
    expect(
      MediaSortOption.releaseDate.sortBy(MediaContentType.people),
      'popularity.desc',
    );
    expect(
      MediaSortOption.voteAverage.sortBy(MediaContentType.tv),
      'vote_average.desc',
    );

    expect(MediaSortOption.popularity.label, 'По популярности');
    expect(MediaSortOption.releaseDate.label, 'По дате выхода');
    expect(MediaSortOption.voteAverage.label, 'По оценке');

    expect(
      MediaSortOption.fromSortBy('popularity.desc'),
      MediaSortOption.popularity,
    );
    expect(
      MediaSortOption.fromSortBy('primary_release_date.desc'),
      MediaSortOption.releaseDate,
    );
    expect(
      MediaSortOption.fromSortBy('first_air_date.desc'),
      MediaSortOption.releaseDate,
    );
    expect(
      MediaSortOption.fromSortBy('vote_average.desc'),
      MediaSortOption.voteAverage,
    );
    expect(MediaSortOption.fromSortBy(null), isNull);
    expect(MediaSortOption.fromSortBy('revenue.desc'), isNull);
  });
}
