import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/product.dart';
import '../../widgets/custom_button.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  List<Product> products = List.from(SampleData.products);
  String selectedCategory = 'All';
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesCategory = selectedCategory == 'All' || 
            product.category == selectedCategory;
        final matchesSearch = product.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final product = filteredProducts[index];
                products.remove(product);
                filteredProducts.remove(product);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(Product product) {
    // Navigate to edit product screen (would be similar to add product)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit product feature would open here'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin/manage-orders');
            },
            icon: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with Search and Add Button
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
                    Expanded(
                      child: TextField(
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
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: 'Add Product',
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin/add-product');
                      },
                      icon: Icons.add,
                      backgroundColor: AppColors.accent,
                      width: 140,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: SampleData.categories.length,
                    itemBuilder: (context, index) {
                      final category = SampleData.categories[index];
                      final isSelected = selectedCategory == category;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                            _filterProducts();
                          },
                          backgroundColor: AppColors.containerLight,
                          selectedColor: AppColors.accent.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.accent : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.accent : AppColors.divider,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Products List
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildProductCard(filteredProducts[index], index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.containerLight,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.inventory_outlined,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some products to get started',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Add First Product',
            onPressed: () {
              Navigator.pushNamed(context, '/admin/add-product');
            },
            icon: Icons.add_shopping_cart,
            backgroundColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: product.images.first,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: AppColors.containerLight,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: AppColors.containerLight,
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.stock > 10
                            ? AppColors.success.withValues(alpha: 0.1)
                            : product.stock > 0
                                ? AppColors.warning.withValues(alpha: 0.1)
                                : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${product.stock} in stock',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: product.stock > 10
                              ? AppColors.success
                              : product.stock > 0
                                  ? AppColors.warning
                                  : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons
          Column(
            children: [
              IconButton(
                onPressed: () => _editProduct(product),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  minimumSize: const Size(36, 36),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => _deleteProduct(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  minimumSize: const Size(36, 36),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
