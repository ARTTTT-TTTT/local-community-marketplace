class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';

  // Auth
  static const String singIn = '$baseUrl/auth/signIn';
  static const String signUp = '$baseUrl/auth/signUp';

  // Product
  static const String getProducts = '$baseUrl/products';
  static const String getProductDetail = '$baseUrl/products/';
}
