import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/profile_update_view.dart';
import 'features/auth/views/signup_view.dart';
import 'features/tales/views/get_tales_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFD9D8DA),
        appBarTheme: const AppBarTheme(color: Color(0xFFD9D8DA)),
      ),
      home: ref.watch(getCurrentAccountProvider).when(
            data: (data) {
              if (data == null) {
                return const SignupView();
              } else if (data.name.isEmpty) {
                return ProfileUpdateView(userId: data.$id);
              }
              return const GetTalesView();
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
