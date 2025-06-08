import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipes/bloc/food/food_bloc.dart';
import 'package:recipes/model/food_model.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_session_manager.dart';

class FoodView extends StatefulWidget {
  final String category;

  const FoodView({super.key, required this.category});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  FoodBloc foodBloc = FoodBloc();
  List<FoodModel>? list;
  Set<String> wishlist = {};
  String? userId;

  _loadInit() {
    foodBloc
        .add(GetRecipesRequest(category: widget.category, id: userId ?? '0'));
  }

  @override
  void initState() {
    super.initState();
    SessionManager().getUserId().then((value) {
      setState(() {
        userId = value;
      });
      _loadInit();
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
            GoRouter.of(context).go('/main');
          },
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.category} Recipes',
          style: const TextStyle(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer(
                    bloc: foodBloc,
                    listener: listenerList,
                    builder: builderList,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void listenerList(BuildContext context, Object? state) {
    if (state is GetRecipesSuccess) {
      list = foodBloc.listRecipes;
    }

    if (state is GetRecipesError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget builderList(BuildContext context, Object? state) {
    if (state is GetRecipesLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.color600,
        ),
      );
    }

    if (state is GetRecipesError) {
      return Center(
        child: Text(
          state.errorMessage ?? 'An error occurred',
        ),
      );
    }

    return buildList(context);
  }

  Widget buildList(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 3,
      ),
      itemCount: list?.length ?? 0,
      itemBuilder: (context, index) {
        final item = list![index];
        final isWishlisted = wishlist.contains(item.foodName);

        return GestureDetector(
          onTap: () {
            GoRouter.of(context).push(
              '/detail',
              extra: item,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.color100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        item.foodImage ?? '',
                        width: double.infinity,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isWishlisted) {
                              wishlist.remove(item.foodName);
                            } else {
                              wishlist.add(item.foodName!);
                            }
                          });
                        },
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.color100,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (item.foodName?.split(' ').length ?? 0) <= 3
                            ? item.foodName ?? '-'
                            : "${item.foodName?.split(' ').take(3).join(' ')}...",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
