import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/comment_controller.dart';
import '../../tales/widgets/tales_screen_utils.dart';
import '../../../models/comment_model.dart';

import 'comment_edit_dialog.dart';
import 'reaction_counter.dart';

class CommentTile extends ConsumerWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });

  final CommentModel comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    return Card(
      color: const Color(0xFFE7E5E7),
      surfaceTintColor: const Color(0xFFE7E5E7),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                ),
                Row(
                  children: [
                    ReactionCounter(
                      reactionImage: 'like',
                      reationCount: comment.likeIds.length,
                    ),
                    ReactionCounter(
                      reactionImage: 'laugh',
                      reationCount: comment.laughIds.length,
                    ),
                    ReactionCounter(
                      reactionImage: 'love',
                      reationCount: comment.loveIds.length,
                    ),
                    ReactionCounter(
                      reactionImage: 'angry',
                      reationCount: comment.angryIds.length,
                    ),
                  ],
                ),
                currentUser.userId == comment.userId
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Action Menu'),
                              content: const Text(
                                  'Would you like to edit or delete your comment?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      ref
                                          .read(commentsControllerProvider
                                              .notifier)
                                          .deleteComment(context, comment);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete')),
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CommentEditDialog(
                                              comment: comment,
                                              initialValue: comment.text);
                                        },
                                      ).then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Edit')),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_horiz))
                    : Opacity(
                        opacity: 0,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz)),
                      ),
              ],
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment.userImageUrl),
            ),
            title: Text(comment.userName),
            subtitle: Text(comment.text),
            trailing: ReactionButton(
              animateBox: true,
              onReactionChanged: (value) {
                ref.read(commentsControllerProvider.notifier).reactToComment(
                    value!.value.toString(), comment, currentUser.userId);
              },
              selectedReaction: comment.angryIds.contains(currentUser.userId)
                  ? const Reaction(
                      value: 'angry',
                      icon: ReactionSizedBox(pngTitle: 'angry'),
                    )
                  : comment.likeIds.contains(currentUser.userId)
                      ? const Reaction(
                          value: 'like',
                          icon: ReactionSizedBox(pngTitle: 'like'),
                        )
                      : comment.laughIds.contains(currentUser.userId)
                          ? const Reaction(
                              value: 'laugh',
                              icon: ReactionSizedBox(pngTitle: 'laugh'),
                            )
                          : comment.loveIds.contains(currentUser.userId)
                              ? const Reaction(
                                  value: 'love',
                                  icon: ReactionSizedBox(pngTitle: 'love'),
                                )
                              : const Reaction(
                                  value: 'like_outlined',
                                  icon: ReactionSizedBox(
                                      pngTitle: 'like_outlined'),
                                ),
              placeholder: comment.angryIds.contains(currentUser.userId)
                  ? const Reaction(
                      value: 'angry',
                      icon: ReactionSizedBox(pngTitle: 'angry'),
                    )
                  : comment.likeIds.contains(currentUser.userId)
                      ? const Reaction(
                          value: 'like',
                          icon: ReactionSizedBox(pngTitle: 'like'),
                        )
                      : comment.laughIds.contains(currentUser.userId)
                          ? const Reaction(
                              value: 'laugh',
                              icon: ReactionSizedBox(pngTitle: 'laugh'),
                            )
                          : comment.loveIds.contains(currentUser.userId)
                              ? const Reaction(
                                  value: 'love',
                                  icon: ReactionSizedBox(pngTitle: 'love'),
                                )
                              : const Reaction(
                                  value: 'like_outlined',
                                  icon: ReactionSizedBox(
                                      pngTitle: 'like_outlined'),
                                ),
              reactions: const [
                Reaction(
                  value: 'like',
                  icon: ReactionSizedBox(pngTitle: 'like'),
                ),
                Reaction(
                  value: 'laugh',
                  icon: ReactionSizedBox(pngTitle: 'laugh'),
                ),
                Reaction(
                  value: 'love',
                  icon: ReactionSizedBox(pngTitle: 'love'),
                ),
                Reaction(
                  value: 'angry',
                  icon: ReactionSizedBox(pngTitle: 'angry'),
                ),
              ],
              itemSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }
}
