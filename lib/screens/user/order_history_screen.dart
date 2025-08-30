import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/order.dart';
import '../../widgets/custom_button.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedFilter = 'All';
  List<Order> filteredOrders = [];

  final List<String> filterOptions = [
    'All',
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    filteredOrders = SampleData.orders;
  }

  void _filterOrders() {
    setState(() {
      if (selectedFilter == 'All') {
        filteredOrders = SampleData.orders;
      } else {
        filteredOrders = SampleData.orders.where((order) {
          return order.statusText == selectedFilter;
        }).toList();
      }
    });
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
        return AppColors.info;
      case OrderStatus.shipped:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filterOptions.length,
              itemBuilder: (context, index) {
                final filter = filterOptions[index];
                final isSelected = selectedFilter == filter;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                      _filterOrders();
                    },
                    backgroundColor: AppColors.containerLight,
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              },
            ),
          ),
          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildOrderCard(filteredOrders[index]),
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
              Icons.receipt_long_outlined,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            selectedFilter == 'All' ? 'No orders yet' : 'No $selectedFilter orders',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start shopping to see your orders here',
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

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Order Items
          Column(
            children: order.items.take(2).map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.containerLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (order.items.length > 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '+${order.items.length - 2} more items',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const Divider(height: 24),
          // Order Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (order.status == OrderStatus.delivered)
                    CustomButton(
                      text: 'Reorder',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Items added to cart'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      isOutlined: true,
                      width: 80,
                      height: 36,
                    ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'Track',
                    onPressed: () {
                      _showTrackingDialog(order);
                    },
                    width: 80,
                    height: 36,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTrackingDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Track Order ${order.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrackingStep('Order Placed', true, true),
            _buildTrackingStep('Processing', order.status.index >= 1, order.status.index > 1),
            _buildTrackingStep('Shipped', order.status.index >= 2, order.status.index > 2),
            _buildTrackingStep('Delivered', order.status.index >= 3, false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, bool isCompleted, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : AppColors.containerLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.divider,
                width: isActive ? 2 : 1,
              ),
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isCompleted ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
