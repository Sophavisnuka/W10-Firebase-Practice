import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week10_firebase/ui/screens/library/view_model/library_view_model.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
    required this.isLike
  });

  final LibraryItemData data;
  final bool isPlaying;
  final bool isLike;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LibraryViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(data.song.title),
          subtitle: Row(
            children: [
              Text("${data.song.duration.inMinutes} mins"),
              SizedBox(width: 10),
              Text("${data.song.like} Likes"),
              SizedBox(width: 20),
              Text(data.artist.name),
              SizedBox(width: 5),
              Text('-'),
              SizedBox(width: 5),
              Text(data.artist.genre),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  vm.likeCount(data.song);
                },
                icon: Icon(
                  isLike ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 5),
              Text(
                isPlaying ? "Playing" : "",
                style: TextStyle(color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
