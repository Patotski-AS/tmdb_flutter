import 'package:tmdb_flutter/data/tmdb/dto/details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/cast_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/crew_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_image.dart';
import 'package:tmdb_flutter/data/tmdb/model/video.dart';

/// Maps [cast] and builds profile URLs from [images].
List<CastMember> mapCast(List<CastMemberDto> cast, ImageConfiguration images) {
  return [
    for (final dto in cast)
      CastMember(
        id: dto.id,
        name: dto.name,
        character: dto.character,
        profileUrl: images.profileUrlFor(dto.profilePath),
        order: dto.order,
      ),
  ];
}

/// Maps [crew] without dropping jobs.
List<CrewMember> mapCrew(List<CrewMemberDto> crew) {
  return [
    for (final dto in crew)
      CrewMember(id: dto.id, name: dto.name, job: dto.job),
  ];
}

/// Keeps videos whose [VideoDto.site] is YouTube, ignoring case.
List<Video> mapYoutubeVideos(List<VideoDto> videos) {
  return [
    for (final dto in videos)
      if (dto.site.toLowerCase() == 'youtube')
        Video(
          id: dto.id,
          key: dto.key,
          name: dto.name,
          site: dto.site,
          type: dto.type,
          official: dto.official,
        ),
  ];
}

/// Builds image URLs from [images].
///
/// [backdrop] selects the backdrop size. Otherwise the poster size is used.
List<MediaImage> mapMediaImages(
  List<ImageDto> dtos,
  ImageConfiguration images, {
  required bool backdrop,
}) {
  final size = backdrop ? images.backdropSize : images.posterSize;
  return [
    for (final dto in dtos)
      MediaImage(
        url: images.urlFor(dto.filePath, size),
        aspectRatio: dto.aspectRatio,
        width: dto.width,
      ),
  ];
}
