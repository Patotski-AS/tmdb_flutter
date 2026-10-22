import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_credit.dart';

/// Full person card returned by `GET person/{id}`.
@immutable
final class PersonDetails {
  /// Creates a person card.
  const new({
    required this.id,
    required this.name,
    required this.biography,
    required this.profileUrl,
    required this.knownForDepartment,
    required this.birthday,
    required this.deathday,
    required this.placeOfBirth,
    required this.alsoKnownAs,
    required this.knownFor,
    required this.castCredits,
    required this.crewCredits,
  });

  /// TMDB person id.
  final int id;

  /// Display name.
  final String name;

  /// Biography, or null when it is blank.
  final String? biography;

  /// Absolute profile URL, or null.
  final String? profileUrl;

  /// Department such as Acting, or null when it is blank.
  final String? knownForDepartment;

  /// Birthday `YYYY-MM-DD`, or null when it is blank.
  final String? birthday;

  /// Day of death `YYYY-MM-DD`, or null when it is blank.
  final String? deathday;

  /// Place of birth, or null when it is blank.
  final String? placeOfBirth;

  /// Other names, without blanks and without duplicates.
  final List<String> alsoKnownAs;

  /// Up to eight roles, ordered by vote descending.
  ///
  /// Acting roles are used first. Crew roles are used only when the
  /// person has no acting credits.
  final List<PersonCredit> knownFor;

  /// Acting credits, distinct and newest first.
  final List<PersonCredit> castCredits;

  /// Crew credits, distinct and newest first.
  final List<PersonCredit> crewCredits;

  @override
  bool operator ==(Object other) {
    return other is PersonDetails &&
        id == other.id &&
        name == other.name &&
        biography == other.biography &&
        profileUrl == other.profileUrl &&
        knownForDepartment == other.knownForDepartment &&
        birthday == other.birthday &&
        deathday == other.deathday &&
        placeOfBirth == other.placeOfBirth &&
        listEquals(alsoKnownAs, other.alsoKnownAs) &&
        listEquals(knownFor, other.knownFor) &&
        listEquals(castCredits, other.castCredits) &&
        listEquals(crewCredits, other.crewCredits);
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    biography,
    profileUrl,
    knownForDepartment,
    birthday,
    deathday,
    placeOfBirth,
    Object.hashAll(alsoKnownAs),
    Object.hashAll(knownFor),
    Object.hashAll(castCredits),
    Object.hashAll(crewCredits),
  );
}
