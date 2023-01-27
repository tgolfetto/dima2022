import 'package:provider/provider.dart';

import '../view_models/content_view_models/content_view_model.dart';
import '../view_models/position_view_models/position_view_model.dart';
import '../view_models/user_view_models/auth_view_model.dart';
import '../view_models/cart_view_models/cart_view_model.dart';
import '../view_models/order_view_models/orders_view_model.dart';
import '../view_models/product_view_models/products_view_model.dart';
import '../view_models/request_view_models/request_list_view_model.dart';
import '../view_models/user_view_models/user_view_model.dart';

class Providers {
  // List of provider instances that will be used in the app
  static var authProviders = [
    // ChangeNotifierProvider for the AuthViewModel
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
    ),

    // ChangeNotifierProxyProvider for the ProductListViewModel
    ChangeNotifierProxyProvider<AuthViewModel, ProductListViewModel>(
      create: (context) => ProductListViewModel(),
      update: (context, auth, previousProducts) => auth.isAuthenticated
          ? ProductListViewModel.fromAuth(
              auth.token,
              auth.userId,
              previousProducts,
            )
          : ProductListViewModel(),
    ),

    // ChangeNotifierProxyProvider for the OrdersViewModel
    ChangeNotifierProxyProvider<AuthViewModel, OrdersViewModel>(
      create: (context) => OrdersViewModel(),
      update: (context, auth, previousOrders) => auth.isAuthenticated
          ? OrdersViewModel.fromAuth(auth.token, auth.userId, previousOrders)
          : OrdersViewModel(),
    ),

    // ChangeNotifierProxyProvider for the CartViewModel
    ChangeNotifierProxyProvider<AuthViewModel, CartViewModel>(
      create: (context) => CartViewModel(),
      update: (context, auth, previousOrders) => auth.isAuthenticated
          ? CartViewModel.fromAuth(auth.token, auth.userId)
          : CartViewModel(),
    ),

    // ChangeNotifierProxyProvider for the RequestListViewModel
    ChangeNotifierProxyProvider<AuthViewModel, RequestListViewModel>(
      create: (context) => RequestListViewModel(),
      update: (context, auth, previousRequests) => auth.isAuthenticated
          ? RequestListViewModel.fromAuth(
              auth.token,
              auth.userId,
              previousRequests,
            )
          : RequestListViewModel(),
    ),

    // ChangeNotifierProxyProvider for the UserViewModel
    ChangeNotifierProxyProvider<AuthViewModel, UserViewModel>(
      create: (context) => UserViewModel(),
      update: (context, auth, _) => auth.isAuthenticated
          ? UserViewModel.fromAuth(auth.token, auth.userId)
          : UserViewModel(),
    ),

// ChangeNotifierProxyProvider for the ContentViewModel
    ChangeNotifierProvider(
      create: (ctx) => ContentViewModel(),
    ),

    // ChangeNotifierProxyProvider for the PositionViewModel
    ChangeNotifierProxyProvider<AuthViewModel, PositionViewModel>(
      create: (context) => PositionViewModel(),
      update: (context, auth, previousPositionArea) => auth.isAuthenticated
          ? PositionViewModel.fromAuth(
              auth.token,
              auth.userId,
              previousPositionArea,
            )
          : PositionViewModel(),
    ),
  ];
}
