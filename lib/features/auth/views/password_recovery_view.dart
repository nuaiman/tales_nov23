import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/large_elevated_button.dart';
import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

class PasswordRecoveryView extends ConsumerStatefulWidget {
  const PasswordRecoveryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends ConsumerState<PasswordRecoveryView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Recover Password',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text(
                    'Please enter your email address so we can send a temporary code.'),
                const SizedBox(height: 30),
                AuthField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email),
                const SizedBox(height: 20),
                LargeElevatedButton(
                  title: 'Send Code',
                  function: () {
                    if (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@')) {
                      showSnackbar(context, 'Enter a valid email address');
                      return;
                    }

                    ref.read(authControllerProvider.notifier).login(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                            (route) => false);
                      },
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
