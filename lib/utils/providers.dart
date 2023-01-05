import 'package:provider/provider.dart';

import '../view_models/content_view_models/content_view_model.dart';
import '../view_models/position_view_models/position_view_model.dart';
import '../view_models/user_view_models/auth_view_model.dart';
import '../view_models/cart_view_models/cart_view_model.dart';
import '../view_models/order_view_models/orders_view_model.dart';
import '../view_models/product_view_models/products_view_model.dart';
import '../view_models/request_view_models/request_list_view_model.dart';
import '../view_models/user_view_models/user_view_model.dart';

// List of provider instances that will be used in the app
var authProviders = [
// ChangeNotifierProvider for the AuthViewModel
  ChangeNotifierProvider(
    create: (context) => AuthViewModel(),
  ),

// ChangeNotifierProxyProvider for the ProductListViewModel
  ChangeNotifierProxyProvider<AuthViewModel, ProductListViewModel>(
    create: (context) => ProductListViewModel(),
    update: (context, auth, previousProducts) => ProductListViewModel.fromAuth(
        auth.token, auth.userId, previousProducts),
  ),

// ChangeNotifierProxyProvider for the OrdersViewModel
  ChangeNotifierProxyProvider<AuthViewModel, OrdersViewModel>(
    create: (context) => OrdersViewModel(),
    update: (context, auth, previousOrders) =>
        OrdersViewModel.fromAuth(auth.token, auth.userId, previousOrders),
  ),

// ChangeNotifierProxyProvider for the CartViewModel
  ChangeNotifierProxyProvider<AuthViewModel, CartViewModel>(
    create: (context) => CartViewModel(),
    update: (context, auth, previousOrders) =>
        CartViewModel.fromAuth(auth.token, auth.userId),
  ),

// ChangeNotifierProxyProvider for the RequestListViewModel
  ChangeNotifierProxyProvider<AuthViewModel, RequestListViewModel>(
    create: (context) => RequestListViewModel(),
    update: (context, auth, previousRequests) => RequestListViewModel.fromAuth(
        auth.token, auth.userId, previousRequests),
  ),

  // ChangeNotifierProxyProvider for the RequestListViewModel
  ChangeNotifierProxyProvider<AuthViewModel, UserViewModel>(
    create: (context) => UserViewModel(),
    update: (context, auth, previousRequests) =>
        UserViewModel.fromAuth(auth.token, auth.userId),
  ),

// ChangeNotifierProxyProvider for the ContentViewModel
  ChangeNotifierProvider(
    create: (ctx) => ContentViewModel(),
  ),

  // ChangeNotifierProxyProvider for the PositionViewModel
  ChangeNotifierProxyProvider<AuthViewModel, PositionViewModel>(
    create: (context) => PositionViewModel(),
    update: (context, auth, previousPositionArea) => PositionViewModel.fromAuth(
        auth.token, auth.userId, previousPositionArea),
  ),
];
