/// Catalog section a [MediaSortOption] applies to.
enum MediaContentType {
  /// Movies.
  movies,

  /// TV shows.
  tv,

  /// People.
  people,
}

/// Discover order for movies, shows, and people.
enum MediaSortOption {
  /// Most popular first.
  popularity('По популярности'),

  /// Newest release first.
  ///
  /// People have no release date, so this uses popularity.
  releaseDate('По дате выхода'),

  /// Highest vote average first.
  voteAverage('По оценке');

  /// Creates a sort option with a Russian [label].
  new(this.label);

  /// Russian caption for the catalog filter.
  final String label;

  /// TMDB `sort_by` value for [contentType].
  String sortBy(MediaContentType contentType) {
    return switch (this) {
      MediaSortOption.popularity => 'popularity.desc',
      MediaSortOption.releaseDate => switch (contentType) {
        MediaContentType.movies => 'primary_release_date.desc',
        MediaContentType.tv => 'first_air_date.desc',
        MediaContentType.people => 'popularity.desc',
      },
      MediaSortOption.voteAverage => 'vote_average.desc',
    };
  }

  /// Maps a TMDB `sort_by` value back to an option.
  ///
  /// Returns null when [sortBy] is null or not one of the known values.
  static MediaSortOption? fromSortBy(String? sortBy) {
    return switch (sortBy) {
      'popularity.desc' => MediaSortOption.popularity,
      'primary_release_date.desc' ||
      'first_air_date.desc' => MediaSortOption.releaseDate,
      'vote_average.desc' => MediaSortOption.voteAverage,
      _ => null,
    };
  }
}
