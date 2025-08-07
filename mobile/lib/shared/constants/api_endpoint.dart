class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // Product
  static const String getProducts = '$baseUrl/products';
  static const String getProductDetail = '$baseUrl/products/';
}
