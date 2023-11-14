import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/background.png',
          ),
          fit: BoxFit.cover,
        )),
        child: const Loader(),
      ),
    );
  }
}
