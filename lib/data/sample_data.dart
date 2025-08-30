import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class SampleData {
  static List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium quality wireless headphones with noise cancellation and 30-hour battery life. Perfect for music lovers and professionals.',
      price: 199.99,
      category: 'Electronics',
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500',
      ],
      stock: 25,
      rating: 4.5,
      reviewCount: 128,
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Advanced fitness tracking smartwatch with heart rate monitor, GPS, and 7-day battery life.',
      price: 299.99,
      category: 'Electronics',
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500',
      ],
      stock: 15,
      rating: 4.7,
      reviewCount: 89,
    ),
    Product(
      id: '3',
      name: 'Running Shoes',
      description: 'Comfortable and durable running shoes with advanced cushioning technology for all terrains.',
      price: 129.99,
      category: 'Sports',
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500',
      ],
      stock: 40,
      rating: 4.3,
      reviewCount: 156,
    ),
    Product(
      id: '4',
      name: 'Coffee Maker',
      description: 'Automatic drip coffee maker with programmable timer and thermal carafe. Makes perfect coffee every time.',
      price: 89.99,
      category: 'Home & Kitchen',
      images: [
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500',
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
      ],
      stock: 20,
      rating: 4.2,
      reviewCount: 73,
    ),
    Product(
      id: '5',
      name: 'Backpack',
      description: 'Durable and spacious backpack perfect for travel, work, or school. Multiple compartments and water-resistant.',
      price: 59.99,
      category: 'Fashion',
      images: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
        'https://images.unsplash.com/photo-1581605405669-fcdf81165afa?w=500',
      ],
      stock: 35,
      rating: 4.4,
      reviewCount: 92,
    ),
    Product(
      id: '6',
      name: 'Bluetooth Speaker',
      description: 'Portable Bluetooth speaker with 360-degree sound, waterproof design, and 12-hour battery life.',
      price: 79.99,
      category: 'Electronics',
      images: [
        'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500',
        'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=500',
      ],
      stock: 30,
      rating: 4.6,
      reviewCount: 114,
    ),
  ];

  static List<CartItem> cartItems = [
    CartItem(product: products[0], quantity: 1),
    CartItem(product: products[2], quantity: 2),
  ];

  static List<Order> orders = [
    Order(
      id: 'ORD001',
      items: [
        CartItem(product: products[1], quantity: 1),
        CartItem(product: products[3], quantity: 1),
      ],
      totalAmount: 389.98,
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.delivered,
      shippingAddress: '123 Main St, City, State 12345',
      paymentMethod: 'Credit Card',
    ),
    Order(
      id: 'ORD002',
      items: [
        CartItem(product: products[0], quantity: 2),
      ],
      totalAmount: 399.98,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.shipped,
      shippingAddress: '456 Oak Ave, City, State 12345',
      paymentMethod: 'PayPal',
    ),
    Order(
      id: 'ORD003',
      items: [
        CartItem(product: products[4], quantity: 1),
        CartItem(product: products[5], quantity: 1),
      ],
      totalAmount: 139.98,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.processing,
      shippingAddress: '789 Pine St, City, State 12345',
      paymentMethod: 'Credit Card',
    ),
  ];

  static List<String> categories = [
    'All',
    'Electronics',
    'Sports',
    'Home & Kitchen',
    'Fashion',
  ];
}
