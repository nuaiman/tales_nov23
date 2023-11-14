import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_view.dart';
import '../widgets/auth_field.dart';

import '../../../common/large_elevated_button.dart';
import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
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
              'assets/images/onboarding_gif.gif',
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
                  'Create Account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text('Please signup to continue with Tales'),
                const SizedBox(height: 30),
                AuthField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email),
                const SizedBox(height: 10),
                AuthField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isPasswordField: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 20),
                LargeElevatedButton(
                  title: 'Signup',
                  function: () {
                    if (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@')) {
                      showSnackbar(context, 'Enter a valid email address');
                      return;
                    }
                    if (_passwordController.text.isEmpty ||
                        _passwordController.text.length < 8) {
                      showSnackbar(context, 'Password must be 8 units long');
                      return;
                    }

                    ref.read(authControllerProvider.notifier).signup(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                          (route) => false);
                    },
                    child: const Text(
                      'Login to my account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
