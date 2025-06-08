import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/bloc/food/food_bloc.dart';
import 'package:recipes/model/food_model.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_session_manager.dart';

class FormFoodView extends StatefulWidget {
  const FormFoodView({super.key});

  @override
  State<FormFoodView> createState() => _FormFoodViewState();
}

class _FormFoodViewState extends State<FormFoodView> {
  FoodBloc foodBloc = FoodBloc();
  TextEditingController foodNameController = TextEditingController();
  TextEditingController foodIngredientController = TextEditingController();
  TextEditingController foodStepController = TextEditingController();
  TextEditingController foodTimerController = TextEditingController();

  List<String> ingredients = [];
  List<String> steps = [];

  String? userId;
  bool isLoading = false;

  String selectedCategory = 'Breakfast';
  final List<String> categoryOptions = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  final picker = ImagePicker();
  String image = "Food Photo";
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
    SessionManager().getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create a Recipe',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: foodNameController,
                    decoration: InputDecoration(
                      labelText: 'Food Name',
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
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categoryOptions.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: const TextStyle(
                        color: AppColors.color600,
                      ),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: foodIngredientController,
                          decoration: InputDecoration(
                            labelText: 'Ingredient',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.color600),
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
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (foodIngredientController.text.trim().isNotEmpty) {
                            setState(() {
                              ingredients
                                  .add(foodIngredientController.text.trim());
                              foodIngredientController.clear();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.color400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text('${index + 1}. ${ingredients[index]}'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              ingredients.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.delete,
                              color: AppColors.color600),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: foodStepController,
                          decoration: InputDecoration(
                            labelText: 'Step',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.color600),
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
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (foodStepController.text.trim().isNotEmpty) {
                            setState(() {
                              steps.add(foodStepController.text.trim());
                              foodStepController.clear();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.color400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text('${index + 1}. ${steps[index]}'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              steps.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.delete,
                              color: AppColors.color600),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: foodTimerController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Timer',
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
                  BlocConsumer(
                    bloc: foodBloc,
                    listener: (context, state) {
                      if (state is PostRecipeSuccess) {
                        Future.microtask(() {
                          GoRouter.of(context).go('/main');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recipe created successfully !'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      }

                      if (state is PostRecipeError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(state.errorMessage ?? "An error occurred"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (foodNameController.text.isEmpty ||
                                imageUrl.isEmpty ||
                                selectedCategory.isEmpty ||
                                ingredients.isEmpty ||
                                steps.isEmpty ||
                                foodTimerController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields !'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            FoodModel food = FoodModel(
                              foodName: foodNameController.text,
                              foodImage: imageUrl,
                              foodCategory: selectedCategory,
                              foodIngredients: ingredients.join(', '),
                              foodSteps: steps.join(', '),
                              foodWishlist: false,
                              foodTimer: int.parse(foodTimerController.text),
                              userId: userId,
                            );
                            debugPrint("Food Model: ${food.toJson()}");

                            foodBloc.add(PostRecipeRequest(viewModel: food));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color600,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      );
                    },
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
