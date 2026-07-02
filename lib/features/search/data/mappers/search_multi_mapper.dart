import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_multi_result_dto.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

class SearchMultiMapper {
  SearchMultiMapper._();

  static MediaItem? toMediaItem(TmdbMultiSearchItemDto dto) {
    return switch (dto.mediaType) {
      'movie' => MediaItem.movie(
        MovieEntity(
          id: dto.id,
          title: dto.title ?? '',
          posterPath: dto.posterPath ?? '',
          voteAverage: dto.voteAverage,
          releaseDate: dto.releaseDate ?? '',
          overview: dto.overview ?? '',
        ),
      ),
      'tv' => MediaItem.tvShow(
        TvShowEntity(
          id: dto.id,
          name: dto.name ?? '',
          posterPath: dto.posterPath ?? '',
          voteAverage: dto.voteAverage,
          firstAirDate: dto.firstAirDate ?? '',
          overview: dto.overview ?? '',
        ),
      ),
      _ => null,
    };
  }

  static List<MediaItem> toMediaItemList(List<TmdbMultiSearchItemDto> dtos) {
    return dtos.map(toMediaItem).whereType<MediaItem>().toList();
  }
}
