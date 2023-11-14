import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:tales_nov23/features/auth/controllers/auth_controller.dart';
import 'package:tales_nov23/features/tales/controllers/tale_controller.dart';
import 'package:tales_nov23/features/comments/views/comments_view.dart';
import 'package:tales_nov23/models/tale_model.dart';

import 'tales_screen_utils.dart';

class TaleTile extends ConsumerWidget {
  final TaleModel tale;
  const TaleTile({
    super.key,
    required this.tale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xFFE7E5E7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black54,
                      backgroundImage: NetworkImage(tale.userImageUrl),
                    ),
                    title: Text(tale.userName),
                    subtitle: Text(GetTimeAgo.parse(
                      DateTime.parse(
                        tale.time.toString(),
                      ),
                    )),
                  ),
                ),
                if (tale.userId == currentUser.userId)
                  IconButton(
                    onPressed: () {
                      ref
                          .read(talesControllerProvider.notifier)
                          .deleteTale(context, tale);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                // Row(
                //   children: [
                //     IconButton(
                //       onPressed: () {},
                //       icon: const Icon(Icons.edit),
                //     ),
                //     IconButton(
                //       onPressed: () {
                //         ref
                //             .read(talesControllerProvider.notifier)
                //             .deleteTale(context, tale);
                //       },
                //       icon: const Icon(Icons.delete),
                //     ),
                //   ],
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tale.title!.isNotEmpty) Text(tale.title!),
                  if (tale.images!.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        height: 150,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {},
                      ),
                      items: tale.images!.map((e) => Image.network(e)).toList(),
                    ),
                  const Divider(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReactionButton(
                  animateBox: true,
                  onReactionChanged: (value) {
                    ref.read(talesControllerProvider.notifier).reactTale(
                        value!.value.toString(), tale, currentUser.userId);
                  },
                  selectedReaction: tale.angryIds.contains(currentUser.userId)
                      ? const Reaction(
                          value: 'angry',
                          icon: ReactionSizedBox(pngTitle: 'angry'),
                        )
                      : tale.likeIds.contains(currentUser.userId)
                          ? const Reaction(
                              value: 'like',
                              icon: ReactionSizedBox(pngTitle: 'like'),
                            )
                          : tale.laughIds.contains(currentUser.userId)
                              ? const Reaction(
                                  value: 'laugh',
                                  icon: ReactionSizedBox(pngTitle: 'laugh'),
                                )
                              : tale.loveIds.contains(currentUser.userId)
                                  ? const Reaction(
                                      value: 'love',
                                      icon: ReactionSizedBox(pngTitle: 'love'),
                                    )
                                  : const Reaction(
                                      value: 'like_outlined',
                                      icon: ReactionSizedBox(
                                          pngTitle: 'like_outlined'),
                                    ),
                  placeholder: tale.angryIds.contains(currentUser.userId)
                      ? const Reaction(
                          value: 'angry',
                          icon: ReactionSizedBox(pngTitle: 'angry'),
                        )
                      : tale.likeIds.contains(currentUser.userId)
                          ? const Reaction(
                              value: 'like',
                              icon: ReactionSizedBox(pngTitle: 'like'),
                            )
                          : tale.laughIds.contains(currentUser.userId)
                              ? const Reaction(
                                  value: 'laugh',
                                  icon: ReactionSizedBox(pngTitle: 'laugh'),
                                )
                              : tale.loveIds.contains(currentUser.userId)
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
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsView(
                        tale: tale,
                      ),
                    ));
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
