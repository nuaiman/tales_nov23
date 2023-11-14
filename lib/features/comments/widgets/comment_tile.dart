import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tales_nov23/features/auth/controllers/auth_controller.dart';
import 'package:tales_nov23/features/comments/controllers/comment_controller.dart';
import 'package:tales_nov23/features/tales/widgets/tales_screen_utils.dart';
import 'package:tales_nov23/models/comment_model.dart';

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
                          ref
                              .read(commentsControllerProvider.notifier)
                              .deleteComment(context, comment);
                        },
                        icon: const Icon(Icons.delete))
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

class ReactionCounter extends StatelessWidget {
  final String reactionImage;
  final int reationCount;
  const ReactionCounter({
    super.key,
    required this.reactionImage,
    required this.reationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset('assets/emojis/$reactionImage.png'),
          ),
          Text(reationCount.toString()),
        ],
      ),
    );
  }
}
