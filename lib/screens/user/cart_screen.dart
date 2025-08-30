import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/cart_item.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = List.from(SampleData.cartItems);

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get shipping => subtotal > 100 ? 0 : 10;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax;

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        cartItems[index].quantity = newQuantity;
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removed from cart'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.clear();
                });
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildCartItem(cartItems[index], index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _buildOrderSummary(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
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
              Icons.shopping_cart_outlined,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
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
            text: 'Start Shopping',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.product.images.first,
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
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => _updateQuantity(index, item.quantity - 1),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _updateQuantity(index, item.quantity + 1),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _removeItem(index),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.accent,
                            size: 20,
                          ),
                        ),
                      ],
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

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Shipping', shipping),
          _buildSummaryRow('Tax', tax),
          const Divider(height: 24),
          _buildSummaryRow('Total', total, isTotal: true),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Proceed to Checkout',
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
            icon: Icons.payment,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
