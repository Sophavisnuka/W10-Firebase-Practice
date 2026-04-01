import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week10_firebase/data/dtos/comment_dto.dart';
import 'package:week10_firebase/model/comments/comment.dart';
import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  List<Artist>? _cacheArtist;

  @override
  Future<List<Artist>> fetchArtists() async {
    if (_cacheArtist != null) {
      return _cacheArtist!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      _cacheArtist = result;

      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}

  @override
  Future<List<Comment>> fetchComments(String artistId) async {
    final Uri commentsUri = Uri.https(
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artists/$artistId/comments.json',
    );

    final response = await http.get(commentsUri);

    if (response.statusCode == 200 && response.body != 'null') {
      Map<String, dynamic> commentsJson = jsonDecode(response.body);
      return commentsJson.entries
          .map((e) => CommentDto.fromJson(e.key, e.value))
          .toList();
    }
    return [];
  }
  @override
  Future<void> addComment(String artistId, String text) async {
    final Uri commentsUri = Uri.https(
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artists/$artistId/comments.json',
    );

    final response = await http.post(
      //POST generates a unique key per comment
      commentsUri,
      body: jsonEncode(CommentDto.toJson(text)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }

    _cacheArtist = null; //Invalidate cache
  }
}
