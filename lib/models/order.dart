import 'cart_item.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final String shippingAddress;
  final String paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    DateTime? orderDate,
    OrderStatus? status,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
