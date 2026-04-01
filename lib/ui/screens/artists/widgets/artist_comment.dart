import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week10_firebase/model/artist/artist.dart';
import 'package:week10_firebase/model/comments/comment.dart';
import 'package:week10_firebase/ui/screens/artists/view_model/artists_view_model.dart';
import 'package:week10_firebase/ui/utils/async_value.dart';
import 'package:week10_firebase/ui/widgets/song/artist_tile.dart';


class ArtistComment extends StatefulWidget {
  final Artist artist;
  const ArtistComment({super.key, required this.artist});

  @override
  State<ArtistComment> createState() => _ArtistCommentState();
}

class _ArtistCommentState extends State<ArtistComment> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch comments when screen opens
    context.read<ArtistsViewModel>().fetchComments(widget.artist.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArtistsViewModel vm = context.watch<ArtistsViewModel>();
    AsyncValue<List<Comment>> commentsValue = vm.commentsValue;

    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Artist tile at top
            ArtistTile(artist: widget.artist),
            SizedBox(height: 16),

            // Comments list
            Expanded(
              child: switch (commentsValue.state) {
                AsyncValueState.loading => Center(child: CircularProgressIndicator()),
                AsyncValueState.error => Center(child: Text('Error loading comments')),
                AsyncValueState.success => commentsValue.data!.isEmpty
                    ? Center(child: Text('No comments yet'))
                    : ListView.builder(
                        itemCount: commentsValue.data!.length,
                        itemBuilder: (context, index) {
                          final comment = commentsValue.data![index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.comment, color: Colors.grey),
                              title: Text(comment.artistComment),
                            ),
                          );
                        },
                      ),
              },
            ),

            // Add comment input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      vm.addComment(widget.artist.id, _controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}