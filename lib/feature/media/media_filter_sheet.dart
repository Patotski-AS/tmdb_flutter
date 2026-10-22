import 'package:flutter/material.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';
import 'package:tmdb_flutter/feature/media/media_state.dart';

const _allGenres = -1;
const _defaultSort = '';

/// Opens the genre and sort sheet for [contentType].
Future<void> showMediaFilterSheet({
  required BuildContext context,
  required MediaContentType contentType,
  required List<Genre> genres,
  required MediaFilters filters,
  required ValueChanged<MediaFilters> onApply,
  required VoidCallback onReset,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _MediaFilterSheet(
        contentType: contentType,
        genres: genres,
        filters: filters,
        onApply: onApply,
        onReset: onReset,
      );
    },
  );
}

class _MediaFilterSheet extends StatefulWidget {
  const new({
    required this.contentType,
    required this.genres,
    required this.filters,
    required this.onApply,
    required this.onReset,
  });

  final MediaContentType contentType;
  final List<Genre> genres;
  final MediaFilters filters;
  final ValueChanged<MediaFilters> onApply;
  final VoidCallback onReset;

  @override
  State<_MediaFilterSheet> createState() => _MediaFilterSheetState();
}

class _MediaFilterSheetState extends State<_MediaFilterSheet> {
  int? _draftGenreId;
  String? _draftSortBy;

  @override
  void initState() {
    super.initState();
    final genreId = widget.filters.genreId;
    final known = widget.genres.any((genre) => genre.id == genreId);
    _draftGenreId = known ? genreId : null;
    _draftSortBy = widget.filters.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Фильтры', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            _GenreDropdown(
              genres: widget.genres,
              genreId: _draftGenreId,
              onChanged: (genreId) => setState(() => _draftGenreId = genreId),
            ),
            const SizedBox(height: 16),
            Text(
              'Сортировка',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            RadioGroup<String>(
              groupValue: _draftSortBy ?? _defaultSort,
              onChanged: (value) {
                setState(() {
                  _draftSortBy = value == null || value.isEmpty ? null : value;
                });
              },
              child: Column(
                children: [
                  const RadioListTile<String>(
                    value: _defaultSort,
                    title: Text('По умолчанию'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  for (final option in MediaSortOption.values)
                    RadioListTile<String>(
                      value: option.sortBy(widget.contentType),
                      title: Text(option.label),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Сбросить'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onApply(
                        MediaFilters(
                          genreId: _draftGenreId,
                          sortBy: _draftSortBy,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Применить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreDropdown extends StatelessWidget {
  const new({
    required this.genres,
    required this.genreId,
    required this.onChanged,
  });

  final List<Genre> genres;
  final int? genreId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Жанр',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: genreId ?? _allGenres,
          items: [
            const DropdownMenuItem<int>(
              value: _allGenres,
              child: Text('Все жанры'),
            ),
            for (final genre in genres)
              DropdownMenuItem<int>(value: genre.id, child: Text(genre.name)),
          ],
          onChanged: (value) {
            onChanged(value == null || value == _allGenres ? null : value);
          },
        ),
      ),
    );
  }
}
