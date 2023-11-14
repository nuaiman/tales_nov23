import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/auth_api.dart';
import '../../../apis/storage_api.dart';
import '../../../core/loader_provider.dart';
import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../../tales/views/get_tales_view.dart';
import '../views/login_view.dart';
import '../views/profile_update_view.dart';

class AuthController extends StateNotifier<UserModel> {
  final LoadingController _loader;
  final AuthApi _authApi;
  final StorageApi _storageApi;
  AuthController(
      {required AuthApi authApi,
      required LoadingController loader,
      required StorageApi storageApi})
      : _authApi = authApi,
        _loader = loader,
        _storageApi = storageApi,
        super(UserModel(
          userId: '',
          name: '',
          imageUrl: '',
        ));

  Future<User?> getCurrentAccount() async {
    final user = await _authApi.getCurrentAccount();
    if (user != null) {
      state = state.copyWith(userId: user.$id);
      if (user.name.isNotEmpty) {
        setCurrentUser(user.$id);
      }
    }
    return user;
  }

  void setCurrentUser(String userId) async {
    final result = await _authApi.getUserWithId(userId: userId);
    result.fold(
      (l) {},
      (r) {
        state = UserModel.fromMap(r.data);
      },
    );
  }

  void signup({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _loader.updateState(true);
    final result = await _authApi.signup(
      userId: ID.unique(),
      email: email,
      password: password,
    );
    _loader.updateState(false);
    result.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) {
        showSnackbar(context, 'Session creation was successful.');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      },
    );
  }

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _loader.updateState(true);
    final result = await _authApi.login(
      email: email,
      password: password,
    );
    _loader.updateState(false);
    result.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) async {
        _loader.updateState(true);
        final userExists = await _authApi.getUserWithId(userId: r.userId);
        _loader.updateState(false);
        userExists.fold(
          (l) {
            showSnackbar(context, 'Session verification was successful.');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ProfileUpdateView(userId: r.userId),
              ),
              (route) => false,
            );
          },
          (r) {
            state = UserModel.fromMap(r.data);
            showSnackbar(context, 'Welcome back :)');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const GetTalesView(),
              ),
              (route) => false,
            );
          },
        );
      },
    );
  }

  void updateProfile({
    required BuildContext context,
    required String userId,
    required String name,
    required String imagePath,
  }) async {
    _loader.updateState(true);
    final imageUrl =
        imagePath != '' ? await _storageApi.uploadImage(imagePath, userId) : '';

    final user = UserModel(
      userId: userId,
      name: name,
      imageUrl: imageUrl,
    );

    final result = await _authApi.updateProfile(user: user);
    _loader.updateState(false);
    result.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const GetTalesView(),
          ),
          (route) => false,
        );
      },
    );
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();

    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false),
    );
  }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthController, UserModel>((ref) {
  final authApi = ref.watch(authApiProvider);
  final loader = ref.watch(loadingControllerProvider.notifier);
  final storageApi = ref.watch(storageApiProvider);
  return AuthController(
      authApi: authApi, loader: loader, storageApi: storageApi);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
