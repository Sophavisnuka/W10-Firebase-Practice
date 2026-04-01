import 'package:week10_firebase/model/comments/comment.dart';

class CommentDto {
  static Comment fromJson(String id, Map<String, dynamic> json) {
    return Comment(commentId: id, artistComment: json['text']);
  }

  static Map<String, dynamic> toJson(String text) {
    return {'text': text};
  }
}
