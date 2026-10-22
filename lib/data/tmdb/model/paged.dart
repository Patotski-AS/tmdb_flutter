import 'package:flutter/foundation.dart';

/// One page of a TMDB list.
@immutable
final class Paged<T> {
  /// Creates a page.
  const new({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  /// Items on this page.
  final List<T> items;

  /// Page number reported by TMDB. The first page is 1.
  final int page;

  /// Total number of pages.
  final int totalPages;

  /// Total number of matches.
  final int totalResults;

  @override
  bool operator ==(Object other) {
    return other is Paged<T> &&
        items == other.items &&
        page == other.page &&
        totalPages == other.totalPages &&
        totalResults == other.totalResults;
  }

  @override
  int get hashCode => Object.hash(items, page, totalPages, totalResults);
}
