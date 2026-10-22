import 'package:tmdb_flutter/data/tmdb/dto/person_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_credit.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_details.dart';

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

const _knownForLimit = 8;

/// Maps [dto] to a person card and builds image URLs from [images].
///
/// Cast and crew stay separate. A credit is dropped when its media type
/// is not movie or tv, or when both title and name are blank. The rest
/// are distinct by id, media type, and role, then sorted by date
/// descending. [PersonDetails.knownFor] keeps up to eight acting roles
/// by vote, or crew roles when there is no cast.
PersonDetails mapPersonDetails(
  PersonDetailsDto dto,
  ImageConfiguration images,
) {
  final combined = dto.combinedCredits;
  final castCredits = _credits(
    combined?.cast ?? const [],
    images,
    isCast: true,
  );
  final crewCredits = _credits(
    combined?.crew ?? const [],
    images,
    isCast: false,
  );
  final acting = _knownFor(castCredits);
  return PersonDetails(
    id: dto.id,
    name: dto.name,
    biography: _omitBlank(dto.biography),
    profileUrl: images.profileUrlFor(dto.profilePath),
    knownForDepartment: _omitBlank(dto.knownForDepartment),
    birthday: _omitBlank(dto.birthday),
    deathday: _omitBlank(dto.deathday),
    placeOfBirth: _omitBlank(dto.placeOfBirth),
    alsoKnownAs: _alsoKnownAs(dto.alsoKnownAs),
    knownFor: acting.isEmpty ? _knownFor(crewCredits) : acting,
    castCredits: castCredits,
    crewCredits: crewCredits,
  );
}

List<PersonCredit> _credits(
  List<PersonCreditDto> dtos,
  ImageConfiguration images, {
  required bool isCast,
}) {
  final credits = <PersonCredit>[];
  final seen = <(int, PersonCreditMediaType, String?)>{};
  for (final dto in dtos) {
    final credit = _mapCredit(dto, images, isCast: isCast);
    if (credit == null) {
      continue;
    }
    final key = (credit.id, credit.mediaType, credit.characterOrJob);
    if (!seen.add(key)) {
      continue;
    }
    credits.add(credit);
  }
  credits.sort((left, right) {
    final leftDate = left.releaseDate ?? '';
    final rightDate = right.releaseDate ?? '';
    return rightDate.compareTo(leftDate);
  });
  return credits;
}

List<PersonCredit> _knownFor(List<PersonCredit> credits) {
  final ranked = [...credits]
    ..sort((left, right) => right.voteAverage.compareTo(left.voteAverage));
  final chosen = <PersonCredit>[];
  final seen = <(int, PersonCreditMediaType)>{};
  for (final credit in ranked) {
    if (!seen.add((credit.id, credit.mediaType))) {
      continue;
    }
    chosen.add(credit);
    if (chosen.length == _knownForLimit) {
      break;
    }
  }
  return chosen;
}

PersonCredit? _mapCredit(
  PersonCreditDto dto,
  ImageConfiguration images, {
  required bool isCast,
}) {
  final mediaType = _creditMediaType(dto.mediaType);
  if (mediaType == null) {
    return null;
  }
  final title = _omitBlank(dto.title) ?? _omitBlank(dto.name);
  if (title == null) {
    return null;
  }
  final role = isCast ? dto.character : dto.job;
  return PersonCredit(
    id: dto.id,
    title: title,
    posterUrl: images.posterUrlFor(dto.posterPath),
    mediaType: mediaType,
    characterOrJob: _omitBlank(role),
    releaseDate: _omitBlank(dto.releaseDate) ?? _omitBlank(dto.firstAirDate),
    voteAverage: dto.voteAverage,
    isCast: isCast,
  );
}

PersonCreditMediaType? _creditMediaType(String value) {
  return switch (value.toLowerCase()) {
    'movie' => PersonCreditMediaType.movie,
    'tv' => PersonCreditMediaType.tv,
    _ => null,
  };
}

List<String> _alsoKnownAs(List<String> names) {
  final unique = <String>[];
  final seen = <String>{};
  for (final name in names) {
    if (name.trim().isEmpty || !seen.add(name)) {
      continue;
    }
    unique.add(name);
  }
  return unique;
}

String? _omitBlank(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value;
}
