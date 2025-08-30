import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  
  String selectedPaymentMethod = 'credit_card';
  bool isLoading = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'credit_card',
      'title': 'Credit Card',
      'subtitle': 'Visa, Mastercard, American Express',
      'icon': Icons.credit_card,
    },
    {
      'id': 'paypal',
      'title': 'PayPal',
      'subtitle': 'Pay with your PayPal account',
      'icon': Icons.account_balance_wallet,
    },
    {
      'id': 'apple_pay',
      'title': 'Apple Pay',
      'subtitle': 'Touch ID or Face ID required',
      'icon': Icons.phone_iphone,
    },
    {
      'id': 'google_pay',
      'title': 'Google Pay',
      'subtitle': 'Pay with Google Pay',
      'icon': Icons.g_mobiledata,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _processOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate order processing
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        _showOrderSuccessDialog();
      }
    }
  }

  void _showOrderSuccessDialog() {
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
                color: AppColors.success.withValues(alpha: 0.1),
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
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed and will be delivered soon.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Continue Shopping',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
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
                  title: 'Shipping Address',
                  icon: Icons.location_on_outlined,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      label: 'Address',
                      hintText: 'Enter your address',
                      prefixIcon: Icons.home_outlined,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _cityController,
                            label: 'City',
                            hintText: 'Enter city',
                            prefixIcon: Icons.location_city_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _zipController,
                            label: 'ZIP Code',
                            hintText: 'Enter ZIP',
                            prefixIcon: Icons.markunread_mailbox_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ZIP code';
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
                  title: 'Payment Method',
                  icon: Icons.payment_outlined,
                  children: [
                    ...paymentMethods.map((method) => _buildPaymentOption(method)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildOrderSummary(),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Place Order',
                  onPressed: _processOrder,
                  isLoading: isLoading,
                  icon: Icons.shopping_bag_outlined,
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
                color: AppColors.primary,
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

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final isSelected = selectedPaymentMethod == method['id'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPaymentMethod = method['id'];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                method['icon'],
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      method['subtitle'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = method['id'];
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedPaymentMethod == method['id'] 
                          ? AppColors.primary 
                          : AppColors.divider,
                      width: 2,
                    ),
                    color: selectedPaymentMethod == method['id'] 
                        ? AppColors.primary 
                        : Colors.transparent,
                  ),
                  child: selectedPaymentMethod == method['id']
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    const subtotal = 459.97;
    const shipping = 10.0;
    const tax = 36.80;
    const total = subtotal + shipping + tax;

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
          const Row(
            children: [
              Icon(
                Icons.receipt_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Shipping', shipping),
          _buildSummaryRow('Tax', tax),
          const Divider(height: 24),
          _buildSummaryRow('Total', total, isTotal: true),
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
