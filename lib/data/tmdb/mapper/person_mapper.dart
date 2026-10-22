import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';

/// Maps [dto] to people, building profile URLs from [images].
Paged<Person> mapPersonPage(
  PopularPeopleResponseDto dto,
  ImageConfiguration images,
) {
  return Paged<Person>(
    items: [for (final person in dto.results) _mapPerson(person, images)],
    page: dto.page,
    totalPages: dto.totalPages,
    totalResults: dto.totalResults,
  );
}

Person _mapPerson(PersonDto dto, ImageConfiguration images) {
  return Person(
    id: dto.id,
    name: dto.name,
    profileUrl: images.profileUrlFor(dto.profilePath),
    knownForDepartment: _blankToNull(dto.knownForDepartment),
  );
}

String? _blankToNull(String? value) {
  if (value == null) {
    return null;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
