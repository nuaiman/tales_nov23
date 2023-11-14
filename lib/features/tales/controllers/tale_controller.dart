import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apis/storage_api.dart';
import '../../../apis/tale_api.dart';
import '../../../core/utils.dart';
import '../../auth/controllers/auth_controller.dart';
import '../views/tales_view.dart';
import '../../../models/tale_model.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../core/loader_provider.dart';

class TalesController extends StateNotifier<List<TaleModel>> {
  final TaleApi _taleApi;
  final StorageApi _storageApi;
  final AuthController _auth;
  final LoadingController _loader;
  TalesController({
    required TaleApi taleApi,
    required StorageApi storageApi,
    required AuthController auth,
    required LoadingController loader,
  })  : _taleApi = taleApi,
        _storageApi = storageApi,
        _auth = auth,
        _loader = loader,
        super([]);

  void updateTale(String currentUserId, List<File>? images, String? text,
      TaleModel tale) async {
    List<String>? imageLinks;
    if (images != null) {
      imageLinks = await _storageApi.uploadTaleImages(images);
    }
    TaleModel updatedAbleComment =
        tale.copyWith(title: text, images: imageLinks);
    // -------------------
    final updatableIndex =
        state.indexWhere((element) => element.id == updatedAbleComment.id);
    state.removeAt(updatableIndex);
    state.insert(updatableIndex, updatedAbleComment);
    final newState = [...state.toSet().toList()];
    state = newState;
    await _taleApi.updateTale(updatedAbleComment);
  }

  void reactTale(String value, TaleModel tale, String currentUserId) async {
    TaleModel updatedAbleTale = tale.copyWith(reactionValue: value);
    // ----------------------------------
    if (updatedAbleTale.unlikedIds.contains(currentUserId)) {
      updatedAbleTale.unlikedIds.remove(currentUserId);
    }
    if (updatedAbleTale.likeIds.contains(currentUserId)) {
      updatedAbleTale.likeIds.remove(currentUserId);
    }
    if (updatedAbleTale.laughIds.contains(currentUserId)) {
      updatedAbleTale.laughIds.remove(currentUserId);
    }
    if (updatedAbleTale.loveIds.contains(currentUserId)) {
      updatedAbleTale.loveIds.remove(currentUserId);
    }
    if (updatedAbleTale.angryIds.contains(currentUserId)) {
      updatedAbleTale.angryIds.remove(currentUserId);
    }
    // ----------------------------------
    if (value == 'like') {
      updatedAbleTale.likeIds.add(currentUserId);
    } else if (value == 'laugh') {
      updatedAbleTale.laughIds.add(currentUserId);
    } else if (value == 'love') {
      updatedAbleTale.loveIds.add(currentUserId);
    } else if (value == 'angry') {
      updatedAbleTale.angryIds.add(currentUserId);
    } else if (value == 'like_outlined') {
      updatedAbleTale.unlikedIds.add(currentUserId);
    }
    // -------------------
    if (value == 'like') {
      updatedAbleTale = updatedAbleTale.copyWith(reactionValue: 'like');
    } else if (value == 'laugh') {
      updatedAbleTale = updatedAbleTale.copyWith(reactionValue: 'laugh');
    } else if (value == 'love') {
      updatedAbleTale = updatedAbleTale.copyWith(reactionValue: 'love');
    } else if (value == 'angry') {
      updatedAbleTale = updatedAbleTale.copyWith(reactionValue: 'angry');
    } else if (value == 'like_outlined') {
      updatedAbleTale =
          updatedAbleTale.copyWith(reactionValue: 'like_outlined');
    }
    // -------------------
    final updatableIndex =
        state.indexWhere((element) => element.id == updatedAbleTale.id);
    state.removeAt(updatableIndex);
    state.insert(updatableIndex, updatedAbleTale);
    final newState = [...state.toSet().toList()];
    state = newState;
    await _taleApi.updateTale(updatedAbleTale);
  }

  // void reactTale(String value, TaleModel tale, String currentUserId) async {
  //   TaleModel updatedTale = tale.copyWith(reactionValue: value);
  //   if (updatedTale.likeIds.contains(currentUserId)) {
  //     updatedTale.likeIds.remove(currentUserId);
  //   }
  //   if (updatedTale.laughIds.contains(currentUserId)) {
  //     updatedTale.laughIds.remove(currentUserId);
  //   }
  //   if (updatedTale.loveIds.contains(currentUserId)) {
  //     updatedTale.loveIds.remove(currentUserId);
  //   }
  //   if (updatedTale.angryIds.contains(currentUserId)) {
  //     updatedTale.angryIds.remove(currentUserId);
  //   }
  //   // ----------------------------------
  //   if (value == 'like') {
  //     updatedTale.likeIds.add(currentUserId);
  //   } else if (value == 'laugh') {
  //     updatedTale.laughIds.add(currentUserId);
  //   } else if (value == 'love') {
  //     updatedTale.loveIds.add(currentUserId);
  //   } else if (value == 'angry') {
  //     updatedTale.angryIds.add(currentUserId);
  //   }
  //   await _taleApi.updateTale(updatedTale);
  //   // -------------------
  //   state = state.map((tale) {
  //     TaleModel eitableTale = tale;
  //     if (eitableTale.likeIds.contains(currentUserId)) {
  //       eitableTale = eitableTale.copyWith(reactionValue: 'like');
  //     } else if (eitableTale.laughIds.contains(currentUserId)) {
  //       eitableTale = eitableTale.copyWith(reactionValue: 'laugh');
  //     } else if (eitableTale.loveIds.contains(currentUserId)) {
  //       eitableTale = eitableTale.copyWith(reactionValue: 'love');
  //     } else if (eitableTale.angryIds.contains(currentUserId)) {
  //       eitableTale = eitableTale.copyWith(reactionValue: 'angry');
  //     } else {
  //       eitableTale = eitableTale.copyWith(reactionValue: 'like_outlined');
  //     }
  //     return eitableTale;
  //   }).toList();
  //   final newState = [...state.toSet().toList()];
  //   state = newState;
  // }

  void shareTale({
    required BuildContext context,
    List<File>? images,
    String? text,
  }) async {
    _loader.updateState(true);
    final currentUser = _auth.state;
    List<String>? imageLinks;
    if (images != null) {
      imageLinks = await _storageApi.uploadTaleImages(images);
    }
    final tale = TaleModel(
      userId: currentUser.userId,
      userName: currentUser.name,
      userImageUrl: currentUser.imageUrl,
      commentIds: const [],
      title: text,
      images: imageLinks,
      reactionValue: 'null',
      unlikedIds: [currentUser.userId],
      likeIds: [],
      laughIds: [],
      loveIds: [],
      angryIds: [],
    );

    final result = await _taleApi.shareTale(tale);
    _loader.updateState(false);
    result.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) {
        Navigator.of(context).pop();
      },
    );
  }

  Future<List<TaleModel>> getAllTales(
      String currentUserId, BuildContext context, WidgetRef ref) async {
    final talesList = await _taleApi.getTales();
    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TalesView(),
      ));
    }
    state = talesList.map((tale) {
      TaleModel eitableTale = TaleModel.fromMap(tale.data);

      if (eitableTale.likeIds.contains(currentUserId)) {
        eitableTale = eitableTale.copyWith(reactionValue: 'like');
      } else if (eitableTale.laughIds.contains(currentUserId)) {
        eitableTale = eitableTale.copyWith(reactionValue: 'laugh');
      } else if (eitableTale.loveIds.contains(currentUserId)) {
        eitableTale = eitableTale.copyWith(reactionValue: 'love');
      } else if (eitableTale.angryIds.contains(currentUserId)) {
        eitableTale = eitableTale.copyWith(reactionValue: 'angry');
      } else if (eitableTale.unlikedIds.contains(currentUserId)) {
        eitableTale = eitableTale.copyWith(reactionValue: 'like_outlined');
      }
      return eitableTale;
    }).toList();
    final newState = [...state.toSet().toList()];
    state = newState;
    return state;
  }

  void startListeningForUpdates(
      String currentUserId, BuildContext context, WidgetRef ref) {
    final talesStream = _taleApi.getLatestTale();
    talesStream.listen((RealtimeMessage message) {
      if (message.events.contains(
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.talesCollection}.documents.*.create')) {
        getAllTales(currentUserId, context, ref);
      } else if (message.events.contains(
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.talesCollection}.documents.*.delete')) {
        state.removeWhere(
            (element) => element.id == TaleModel.fromMap(message.payload).id);
        final newState = [...state];
        state = newState;
      } else if (message.events.contains(
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.talesCollection}.documents.*.update')) {
        final updatedIndex = state.indexWhere(
            (element) => element.id == TaleModel.fromMap(message.payload).id);
        state.removeWhere(
            (element) => element.id == TaleModel.fromMap(message.payload).id);
        state.insert(updatedIndex, TaleModel.fromMap(message.payload));
        final newState = [...state];
        state = newState;
      }
    }).onError((_) {
      startListeningForUpdates(currentUserId, context, ref);
    });
  }

  void deleteTale(BuildContext context, TaleModel tale) async {
    await _taleApi.deleteTale(tale.id);
    state.removeWhere((element) => element.id == tale.id);
    final newState = [...state];
    state = newState;
  }
}
// -----------------------------------------------------------------------------

final talesControllerProvider =
    StateNotifierProvider<TalesController, List<TaleModel>>((ref) {
  final taleApi = ref.watch(taleApiProvider);
  final storageApi = ref.watch(storageApiProvider);
  final auth = ref.watch(authControllerProvider.notifier);
  final loader = ref.watch(loadingControllerProvider.notifier);
  return TalesController(
    taleApi: taleApi,
    storageApi: storageApi,
    auth: auth,
    loader: loader,
  );
});

// final getPetsProvider = FutureProvider((ref) async {
//   final petController = ref.watch(petControllerProvider.notifier);
//   return petController.getPets();
// });

// final filterPetsProvider = Provider.family((ref, PetType petType) async {
//   final pets = await ref.watch(petControllerProvider.notifier).getPets();
//   return pets.where((pet) => pet.petType == petType).toList();
// });
