import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'fir-flutter-48baa-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artist/songs.json',
  );

  List<Song>? _cacheSong;

  @override
  Future<List<Song>> fetchSongs() async {
    if (_cacheSong != null) {
      return _cacheSong!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      _cacheSong = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
  
  @override
  Future<void> likeSong(String songId, int like) async {
    final Uri songsLikeUri = Uri.https(
      'fir-flutter-48baa-default-rtdb.asia-southeast1.firebasedatabase.app',
      'artist/songs/$songId.json',
    );
    final http.Response response = await http.patch(
      songsLikeUri,
      body: json.encode({
        'likes': like + 1
      })
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like song');
    }

    // Force next fetch to return fresh values from Firebase.
    _cacheSong = null;
  }
}
