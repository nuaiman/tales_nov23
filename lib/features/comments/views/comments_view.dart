import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/tale_model.dart';
import '../controllers/comment_controller.dart';
import '../widgets/add_comment_field.dart';
import '../widgets/comment_tile.dart';

class CommentsView extends ConsumerWidget {
  final TaleModel tale;
  const CommentsView({super.key, required this.tale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref
        .watch(commentsControllerProvider)
        .where(
          (element) => element.taleId == tale.id,
        )
        .toList();
    final commentsCount = comments.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: commentsCount,
                itemBuilder: (context, index) =>
                    CommentTile(comment: comments[index]),
              ),
            ),
            AddCommentField(tale: tale),
          ],
        ),
      ),
    );
  }
}
