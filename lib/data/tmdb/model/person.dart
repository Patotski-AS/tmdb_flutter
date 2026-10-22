import 'package:flutter/foundation.dart';

/// A person row from a list or search response.
@immutable
final class Person {
  /// Creates a person list item.
  const new({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.knownForDepartment,
  });

  /// TMDB person id.
  final int id;

  /// Display name.
  final String name;

  /// Absolute profile URL, or null when TMDB has no photo.
  final String? profileUrl;

  /// Department such as Acting, or null when it is blank.
  final String? knownForDepartment;

  @override
  bool operator ==(Object other) {
    return other is Person &&
        id == other.id &&
        name == other.name &&
        profileUrl == other.profileUrl &&
        knownForDepartment == other.knownForDepartment;
  }

  @override
  int get hashCode => Object.hash(id, name, profileUrl, knownForDepartment);
}
