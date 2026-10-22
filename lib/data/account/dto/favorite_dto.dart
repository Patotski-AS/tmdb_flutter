import 'package:json_annotation/json_annotation.dart';

part 'favorite_dto.g.dart';

/// `GET movie/{id}/account_states` payload.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class MovieAccountStatesDto {
  /// Creates an account-state payload.
  const new({this.favorite = false});

  /// Parses an account-state response.
  factory fromJson(Map<String, dynamic> json) =>
      _$MovieAccountStatesDtoFromJson(json);

  /// Whether the movie is on the favorite list.
  ///
  /// Missing values count as false.
  final bool favorite;
}

/// JSON body for `POST account/{account_id}/favorite`.
@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
final class FavoriteRequestDto {
  /// Creates a favorite body for one movie.
  const new({
    required this.mediaType,
    required this.mediaId,
    required this.favorite,
  });

  /// Serializes the favorite body.
  Map<String, dynamic> toJson() => _$FavoriteRequestDtoToJson(this);

  /// TMDB media type. Movies use `movie`.
  final String mediaType;

  /// TMDB media id.
  final int mediaId;

  /// Whether the movie should be on the favorite list.
  final bool favorite;
}
