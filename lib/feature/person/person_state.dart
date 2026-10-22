import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_credit.dart';

const _unchanged = Object();

/// Person screen state for one id.
@immutable
final class PersonState {
  /// Creates a person screen state.
  const new({
    required this.personId,
    this.name,
    this.biography,
    this.profileUrl,
    this.knownForDepartment,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.alsoKnownAs = const [],
    this.knownFor = const [],
    this.castCredits = const [],
    this.crewCredits = const [],
    this.showFullCastCredits = false,
    this.showFullCrewCredits = false,
    this.isLoading = false,
    this.error,
  });

  /// TMDB person id.
  final int personId;

  /// Display name, or null before the first success.
  final String? name;

  /// Biography, or null when it is blank or not loaded yet.
  final String? biography;

  /// Absolute profile URL, or null.
  final String? profileUrl;

  /// Russian department caption, or null.
  final String? knownForDepartment;

  /// Birthday `YYYY-MM-DD`, or null.
  final String? birthday;

  /// Day of death `YYYY-MM-DD`, or null.
  final String? deathday;

  /// Place of birth, or null.
  final String? placeOfBirth;

  /// Other names, without blanks and without duplicates.
  final List<String> alsoKnownAs;

  /// Up to eight roles shown in «Известен по».
  final List<PersonCredit> knownFor;

  /// Acting credits, newest first.
  ///
  /// The screen shows the first 12 until [showFullCastCredits].
  final List<PersonCredit> castCredits;

  /// Crew credits, newest first.
  ///
  /// The screen shows the first 12 until [showFullCrewCredits].
  final List<PersonCredit> crewCredits;

  /// Whether the acting list is expanded on this screen.
  final bool showFullCastCredits;

  /// Whether the crew list is expanded on this screen.
  final bool showFullCrewCredits;

  /// Whether a person request is in flight.
  final bool isLoading;

  /// Last failure text, or null.
  final String? error;

  /// Returns a copy with the given fields replaced.
  ///
  /// Pass [error] to replace it, including with null.
  /// Omit it to keep the current value.
  PersonState copyWith({
    bool? showFullCastCredits,
    bool? showFullCrewCredits,
    bool? isLoading,
    Object? error = _unchanged,
  }) {
    return PersonState(
      personId: personId,
      name: name,
      biography: biography,
      profileUrl: profileUrl,
      knownForDepartment: knownForDepartment,
      birthday: birthday,
      deathday: deathday,
      placeOfBirth: placeOfBirth,
      alsoKnownAs: alsoKnownAs,
      knownFor: knownFor,
      castCredits: castCredits,
      crewCredits: crewCredits,
      showFullCastCredits: showFullCastCredits ?? this.showFullCastCredits,
      showFullCrewCredits: showFullCrewCredits ?? this.showFullCrewCredits,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unchanged) ? this.error : error as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PersonState &&
        personId == other.personId &&
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
        listEquals(crewCredits, other.crewCredits) &&
        showFullCastCredits == other.showFullCastCredits &&
        showFullCrewCredits == other.showFullCrewCredits &&
        isLoading == other.isLoading &&
        error == other.error;
  }

  @override
  int get hashCode => Object.hash(
    personId,
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
    showFullCastCredits,
    showFullCrewCredits,
    isLoading,
    error,
  );
}
