import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String selectedCategory = 'Electronics';
  bool isLoading = false;
  List<String> imageUrls = [];

  final List<String> categories = [
    'Electronics',
    'Sports',
    'Home & Kitchen',
    'Fashion',
    'Books',
    'Beauty',
    'Toys',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addImageUrl() {
    if (_imageUrlController.text.isNotEmpty) {
      setState(() {
        imageUrls.add(_imageUrlController.text);
        _imageUrlController.clear();
      });
    }
  }

  void _removeImageUrl(int index) {
    setState(() {
      imageUrls.removeAt(index);
    });
  }

  void _addProduct() async {
    if (_formKey.currentState!.validate() && imageUrls.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Simulate product addition
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog();
      }
    } else if (imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product image'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Product Added Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The product has been added to your inventory.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Add Another',
                    onPressed: () {
                      Navigator.of(context).pop();
                      _clearForm();
                    },
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'View Products',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/admin/manage-products');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _imageUrlController.clear();
    setState(() {
      imageUrls.clear();
      selectedCategory = 'Electronics';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin/manage-products');
            },
            icon: const Icon(Icons.inventory_outlined),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: AnimationLimiter(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildSectionCard(
                  title: 'Basic Information',
                  icon: Icons.info_outline,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Product Name',
                      hintText: 'Enter product name',
                      prefixIcon: Icons.shopping_bag_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.containerLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              items: categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Enter product description',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'Pricing & Inventory',
                  icon: Icons.attach_money,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _priceController,
                            label: 'Price (\$)',
                            hintText: '0.00',
                            prefixIcon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _stockController,
                            label: 'Stock Quantity',
                            hintText: '0',
                            prefixIcon: Icons.inventory_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter stock';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter valid quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'Product Images',
                  icon: Icons.image_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _imageUrlController,
                            label: 'Image URL',
                            hintText: 'Enter image URL',
                            prefixIcon: Icons.link,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: 'Add',
                          onPressed: _addImageUrl,
                          width: 80,
                          height: 56,
                        ),
                      ],
                    ),
                    if (imageUrls.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Added Images:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...imageUrls.asMap().entries.map((entry) {
                        final index = entry.key;
                        final url = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.containerLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  url,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeImageUrl(index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Add Product',
                  onPressed: _addProduct,
                  isLoading: isLoading,
                  icon: Icons.add_shopping_cart,
                  backgroundColor: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
