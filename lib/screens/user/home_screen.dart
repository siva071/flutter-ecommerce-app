import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:badges/badges.dart' as badges;
import '../../utils/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = SampleData.products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = SampleData.products.where((product) {
        final matchesCategory = selectedCategory == 'All' || 
            product.category == selectedCategory;
        final matchesSearch = product.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      badges.Badge(
                        badgeContent: Text(
                          '${SampleData.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.accent,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/order-history');
                        },
                        icon: const Icon(
                          Icons.person_outline,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterProducts(),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(color: AppColors.textLight),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.containerLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Categories
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: SampleData.categories.length,
                itemBuilder: (context, index) {
                  final category = SampleData.categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CategoryChip(
                      label: category,
                      isSelected: selectedCategory == category,
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        _filterProducts();
                      },
                    ),
                  );
                },
              ),
            ),
            // Products Grid
            Expanded(
              child: AnimationLimiter(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ProductCard(
                            product: filteredProducts[index],
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-details',
                                arguments: filteredProducts[index],
                              );
                            },
                            onAddToCart: () {
                              // Add to cart logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${filteredProducts[index].name} added to cart',
                                  ),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
