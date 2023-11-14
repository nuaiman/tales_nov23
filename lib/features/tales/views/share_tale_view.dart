import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tales_nov23/common/large_elevated_button.dart';
import 'package:tales_nov23/core/loader_provider.dart';
import 'package:tales_nov23/features/auth/controllers/auth_controller.dart';
import 'package:tales_nov23/features/tales/controllers/tale_controller.dart';

import '../../../core/utils.dart';

class ShareTaleView extends ConsumerStatefulWidget {
  const ShareTaleView({super.key});

  @override
  ConsumerState<ShareTaleView> createState() => _ShareTaleViewState();
}

class _ShareTaleViewState extends ConsumerState<ShareTaleView> {
  List<File>? _images;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void onPickImages() async {
    _images = await pickImages(context);
    setState(() {});
  }

  void onShareTale() {
    if (_images == null && _textController.text.trim().isEmpty) {
      showSnackbar(context, 'Cannot share an empty Tale');
      return;
    }
    ref.read(talesControllerProvider.notifier).shareTale(
        context: context, images: _images, text: _textController.text);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final loader = ref.watch(loadingControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Share Tale',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          Card(
            color: const Color(0xFF353435),
            child: IconButton(
                onPressed: () {
                  onPickImages();
                },
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What\'s Happening?',
                      ),
                      maxLines: null,
                      maxLength: 120,
                    ),
                  ),
                ],
              ),
              if (_images != null)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: CarouselSlider(
                      items: _images!
                          .map(
                            (e) => Stack(
                              children: [
                                Image.file(
                                  e,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _images!.remove(e);
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 300,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loader == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : LargeElevatedButton(
                title: 'Share',
                function: () {
                  onShareTale();
                }),
      ),
    );
  }
}
