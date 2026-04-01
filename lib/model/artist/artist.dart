import 'package:week10_firebase/model/comments/comment.dart';

class Artist {
  final String id;
  final String name;
  final String genre;
  final Uri imageUrl;
  final List<Comment>? comments;

  Artist({
    required this.id,
    required this.name,
    required this.genre,
    required this.imageUrl,
    this.comments = const [],
  });

  @override
  String toString() {
    return 'Song(id: $id, name: $name, genre: $genre, genre: $genre)';
  }
}
