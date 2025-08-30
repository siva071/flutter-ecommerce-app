import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/product.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int currentImageIndex = 0;
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                    ),
                    items: product.images.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.containerLight,
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.containerLight,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textLight,
                            size: 60,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentImageIndex,
                        count: product.images.length,
                        effect: const WormEffect(
                          dotColor: Colors.white54,
                          activeDotColor: Colors.white,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${product.stock} in stock',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quantity Selector
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1
                                  ? () {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              color: AppColors.textSecondary,
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: quantity < product.stock
                                  ? () {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add),
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: \$${(product.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                icon: Icons.shopping_cart_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Buy Now',
                icon: Icons.flash_on,
                backgroundColor: AppColors.accent,
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
