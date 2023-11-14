import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/large_elevated_button.dart';
import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';

class ProfileUpdateView extends ConsumerStatefulWidget {
  final String userId;
  const ProfileUpdateView({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends ConsumerState<ProfileUpdateView> {
  final _formKey = GlobalKey<FormState>();
  File? _userImage;
  String _name = '';

  void _pickImage() async {
    final pickedImage = await pickImage();
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _userImage = pickedImage;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (_userImage == null) {
      showSnackbar(context, 'Must add an image');
      return;
    }
    if (!isValid) {
      return;
    }
    if (_name == '' || _name.trim().isEmpty) {
      return;
    }
    // -------------------------------------------------------------------------
    _formKey.currentState!.save();
    // -------------------------------------------------------------------------
    ref.read(authControllerProvider.notifier).updateProfile(
          context: context,
          userId: widget.userId,
          name: _name,
          imagePath: _userImage != null ? _userImage!.path : '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.black54,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.white,
                          backgroundImage: _userImage != null
                              ? FileImage(_userImage!)
                              : null,
                          child: _userImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black54,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                  ),
                  const SizedBox(height: 50),
                  LargeElevatedButton(
                    title: 'Update',
                    function: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
