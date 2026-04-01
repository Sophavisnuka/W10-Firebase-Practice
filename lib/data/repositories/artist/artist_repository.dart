import 'package:week10_firebase/model/comments/comment.dart';

import '../../../model/artist/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();

  Future<Artist?> fetchArtistById(String id);

  Future<List<Comment>> fetchComments(String artistId);

  Future<void> addComment(String artistId, String text);
}
