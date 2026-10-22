import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_department.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_details.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/person/person_state.dart';

part 'person_notifier.g.dart';

/// Person card for one id.
@riverpod
class PersonNotifier extends _$PersonNotifier {
  bool _inFlight = false;

  @override
  PersonState build(int id) {
    unawaited(
      Future<void>.microtask(() {
        if (!ref.mounted) {
          return;
        }
        unawaited(load());
      }),
    );
    return PersonState(personId: id, isLoading: true);
  }

  /// Loads the person.
  ///
  /// A call while a request is already running does nothing.
  Future<void> load() async {
    if (!ref.mounted || _inFlight) {
      return;
    }
    _inFlight = true;
    final personId = id;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final details = await ref
          .read(personRepositoryProvider)
          .getPersonDetails(personId);
      if (!ref.mounted) {
        return;
      }
      state = _loaded(state, details);
    } on TmdbException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error.message);
    } finally {
      _inFlight = false;
    }
  }

  /// Reveals every acting credit on this screen.
  void showFullCastCredits() {
    if (!ref.mounted || state.showFullCastCredits) {
      return;
    }
    state = state.copyWith(showFullCastCredits: true);
  }

  /// Reveals every crew credit on this screen.
  void showFullCrewCredits() {
    if (!ref.mounted || state.showFullCrewCredits) {
      return;
    }
    state = state.copyWith(showFullCrewCredits: true);
  }
}

PersonState _loaded(PersonState current, PersonDetails details) {
  final department = details.knownForDepartment;
  return PersonState(
    personId: current.personId,
    name: details.name,
    biography: details.biography,
    profileUrl: details.profileUrl,
    knownForDepartment: department?.toDepartmentLabel(),
    birthday: details.birthday,
    deathday: details.deathday,
    placeOfBirth: details.placeOfBirth,
    alsoKnownAs: details.alsoKnownAs,
    knownFor: details.knownFor,
    castCredits: details.castCredits,
    crewCredits: details.crewCredits,
    showFullCastCredits: current.showFullCastCredits,
    showFullCrewCredits: current.showFullCrewCredits,
  );
}
