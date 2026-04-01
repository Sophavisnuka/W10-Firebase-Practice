import 'package:flutter/material.dart';
import 'package:week10_firebase/data/repositories/artist/artist_repository.dart';
import 'package:week10_firebase/model/comments/comment.dart';
import '../../../../model/artist/artist.dart';
import '../../../utils/async_value.dart';

class ArtistsViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistsViewModel({required this.artistRepository}) {
    _init();
  }

  void _init() async {
    fetchArtists();
  }

  void fetchArtists() async {
    // 1- Loading state
    artistsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Artist> artists = await artistRepository.fetchArtists();
      artistsValue = AsyncValue.success(artists);
    } catch (e) {
      // 3- Fetch is unsucessfull
      artistsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void fetchComments(String artistId) async {
    commentsValue = AsyncValue.loading();
    notifyListeners();
    try {
      List<Comment> comments = await artistRepository.fetchComments(artistId);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void addComment(String artistId, String text) async {
    try {
      await artistRepository.addComment(artistId, text);
      fetchComments(artistId); //Refresh comments after adding
    } catch (e) {
      commentsValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
