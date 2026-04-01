import 'package:week10_firebase/data/dtos/comment_dto.dart';
import 'package:week10_firebase/model/comments/comment.dart';

import '../../model/artist/artist.dart';

class ArtistDto {
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageUrlKey = 'imageUrl';
  static const String comment = 'comments';

  static Artist fromJson(String id, Map<String, dynamic> json) {
    assert(json[nameKey] is String);
    assert(json[genreKey] is String);
    assert(json[imageUrlKey] is String);

    List<Comment> comments = [];
    if (json['comments'] != null) {
      final commentsMap = json['comments'] as Map<String, dynamic>;
      for (final entry in commentsMap.entries) {
        comments.add(CommentDto.fromJson(entry.key, entry.value));
      }
    }

    return Artist(
      id: id,
      name: json[nameKey],
      genre: json[genreKey],
      imageUrl: Uri.parse(json[imageUrlKey]),
      comments: comments,
    );
  }

  /// Convert Artist to JSON
  Map<String, dynamic> toJson(Artist artist) {
    return {
      nameKey: artist.name,
      genreKey: artist.genre,
      imageUrlKey: artist.imageUrl.toString(),
      comment: artist.comments,
    };
  }
}
