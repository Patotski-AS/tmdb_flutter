import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';

/// Maps a genre list payload.
List<Genre> mapGenres(GenreListResponseDto dto) {
  return [
    for (final genre in dto.genres) Genre(id: genre.id, name: genre.name),
  ];
}
