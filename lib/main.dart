import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/product_details_screen.dart';
import 'screens/user/cart_screen.dart';
import 'screens/user/checkout_screen.dart';
import 'screens/user/order_history_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/add_product_screen.dart';
import 'screens/admin/manage_products_screen.dart';
import 'screens/admin/manage_orders_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/order-history': (context) => const OrderHistoryScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin/add-product': (context) => const AddProductScreen(),
        '/admin/manage-products': (context) => const ManageProductsScreen(),
        '/admin/manage-orders': (context) => const ManageOrdersScreen(),
      },
    );
  }
}
