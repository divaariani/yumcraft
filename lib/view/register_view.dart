import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/theme/app_colors.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final picker = ImagePicker();
  String image = "Photo Profile";
  File? pickedImage;
  double uploadImageProgress = 0.0;
  String imageUrl = '';

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
        image = pickedFile.name;
      });

      await uploadImageToFirebase();
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (pickedImage != null) {
      final path = 'files/${pickedImage!.path.split('/').last}';
      final file = File(pickedImage!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          uploadImageProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = urlDownload;
      });
      
      debugPrint('Direct Image Link: $urlDownload');
    } else {
      debugPrint('No file selected');
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Register to create your account !',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.color600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.color400, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.color100,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.color600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.color400, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.color100,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordVisible ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.color600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.color400, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.color600,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.color100,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: AppColors.color100,
                      border: Border.all(color: AppColors.color600),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pickedImage == null
                                ? image
                                : pickedImage!.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.color600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_a_photo,
                              color: AppColors.color600, size: 24),
                          onPressed: pickImage,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: pickedImage != null,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: LinearProgressIndicator(
                            value: uploadImageProgress,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.color600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color600,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: AppColors.color600,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.color600,
                        ),
                      ),
                    ),
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
