import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/order.dart';
import '../../widgets/custom_button.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  List<Order> orders = List.from(SampleData.orders);
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
    filteredOrders = orders;
  }

  void _filterOrders() {
    setState(() {
      if (selectedFilter == 'All') {
        filteredOrders = orders;
      } else {
        filteredOrders = orders.where((order) {
          return order.statusText == selectedFilter;
        }).toList();
      }
    });
  }

  void _updateOrderStatus(int index, OrderStatus newStatus) {
    setState(() {
      filteredOrders[index] = filteredOrders[index].copyWith(status: newStatus);
      // Update in main orders list too
      final orderIndex = orders.indexWhere((o) => o.id == filteredOrders[index].id);
      if (orderIndex != -1) {
        orders[orderIndex] = orders[orderIndex].copyWith(status: newStatus);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${filteredOrders[index].id} status updated to ${newStatus.name}'),
        backgroundColor: AppColors.success,
      ),
    );
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
        title: const Text('Manage Orders'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin/add-product');
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _buildStatCard('Total Orders', orders.length.toString(), AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Pending', orders.where((o) => o.status == OrderStatus.pending).length.toString(), AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Delivered', orders.where((o) => o.status == OrderStatus.delivered).length.toString(), AppColors.success)),
              ],
            ),
          ),
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
                              child: _buildOrderCard(filteredOrders[index], index),
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
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
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
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
            'Orders will appear here when customers place them',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, int index) {
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
                      fontSize: 18,
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
          // Customer Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.containerLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.shippingAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Payment: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      order.paymentMethod,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Order Items
          const Text(
            'Items:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
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
                          'Qty: ${item.quantity} × \$${item.product.price.toStringAsFixed(2)}',
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
          }),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled)
                CustomButton(
                  text: 'Update Status',
                  onPressed: () => _showStatusUpdateDialog(order, index),
                  backgroundColor: AppColors.accent,
                  width: 120,
                  height: 36,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(Order order, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Update Order ${order.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values.where((status) => status != order.status).map((status) {
            return ListTile(
              title: Text(status.name.toUpperCase()),
              leading: Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
              ),
              onTap: () {
                Navigator.pop(context);
                _updateOrderStatus(index, status);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.processing:
        return Icons.autorenew;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}
