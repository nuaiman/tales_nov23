import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingController extends StateNotifier<bool> {
  LoadingController() : super(false);

  void updateState(bool value) {
    state = value;
  }
}
// -----------------------------------------------------------------------------

final loadingControllerProvider =
    StateNotifierProvider<LoadingController, bool>((ref) {
  return LoadingController();
});
