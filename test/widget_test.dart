import 'dart:convert';

import 'package:dima2022/main.dart';
import 'package:dima2022/models/cart/cart.dart';
import 'package:dima2022/models/cart/cart_item.dart';
import 'package:dima2022/models/exceptions/app_exception.dart';
import 'package:dima2022/models/exceptions/http_exception.dart';
import 'package:dima2022/models/orders/order_item.dart';
import 'package:dima2022/models/orders/orders.dart';
import 'package:dima2022/models/position/position_area.dart';
import 'package:dima2022/models/product/category.dart';
import 'package:dima2022/models/product/product.dart';
import 'package:dima2022/models/product/product_type.dart';
import 'package:dima2022/models/product/products.dart';
import 'package:dima2022/models/request/request.dart';
import 'package:dima2022/models/request/request_status.dart';
import 'package:dima2022/models/request/requests.dart';
import 'package:dima2022/models/user/address.dart';
import 'package:dima2022/models/user/auth.dart';
import 'package:dima2022/models/user/user.dart';
import 'package:dima2022/services/auth_service.dart';
import 'package:dima2022/services/cart_service.dart';
import 'package:dima2022/services/orders_service.dart';
import 'package:dima2022/services/position_service.dart';
import 'package:dima2022/services/product_service.dart';
import 'package:dima2022/services/products_service.dart';
import 'package:dima2022/services/request_service.dart';
import 'package:dima2022/services/requests_service.dart';
import 'package:dima2022/services/user_service.dart';
import 'package:dima2022/utils/constants.dart';
import 'package:dima2022/utils/providers.dart';
import 'package:dima2022/utils/routes.dart';
import 'package:dima2022/view/auth_screen.dart';

import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view/on_boarding_screen.dart';
import 'package:dima2022/view/splash_screen.dart';
import 'package:dima2022/view/widgets/common/animated_resize.dart';
import 'package:dima2022/view/widgets/common/custom_theme.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/order_side/order_side.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/requests_side/request_side.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/scanner_instructions.dart';
import 'package:dima2022/view/widgets/sidebar_widgets/side_bar.dart';
import 'package:dima2022/view_models/cart_view_models/cart_item_view_model.dart';
import 'package:dima2022/view_models/cart_view_models/cart_view_model.dart';
import 'package:dima2022/view_models/content_view_models/content_view_model.dart';
import 'package:dima2022/view_models/order_view_models/order_view_model.dart';
import 'package:dima2022/view_models/order_view_models/orders_view_model.dart';
import 'package:dima2022/view_models/position_view_models/position_view_model.dart';
import 'package:dima2022/view_models/product_view_models/product_view_model.dart';
import 'package:dima2022/view_models/product_view_models/products_view_model.dart';
import 'package:dima2022/view_models/request_view_models/request_list_view_model.dart';
import 'package:dima2022/view_models/request_view_models/request_view_model.dart';
import 'package:dima2022/view_models/user_view_models/auth_view_model.dart';
import 'package:dima2022/view_models/user_view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout/layout.dart';
import 'package:nock/nock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const String authToken =
      "<YOUR AUTH TOKEN HERE>";
  const String userId = "xFt5SXvRdzQibaId5Wmuojf6oZO2";
  var mockAuthProviders = [
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProductListViewModel.fromAuth(
        authToken,
        userId,
        null,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => OrdersViewModel.fromAuth(
        authToken,
        userId,
        null,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => CartViewModel.fromAuth(authToken, userId),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          RequestListViewModel.fromAuth(authToken, userId, null),
    ),
    ChangeNotifierProvider(
      create: (context) => UserViewModel.fromAuth(authToken, userId),
    ),
    ChangeNotifierProvider(
      create: (ctx) => ContentViewModel(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => PositionViewModel.fromAuth(authToken, userId, null),
    ),
  ];

  var mockAuthClerkProviders = [
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProductListViewModel.fromAuth(
        authToken,
        'clerkId',
        null,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => OrdersViewModel.fromAuth(
        authToken,
        'clerkId',
        null,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => CartViewModel.fromAuth(authToken, 'clerkId'),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          RequestListViewModel.fromAuth(authToken, 'clerkId', null),
    ),
    ChangeNotifierProvider(
      create: (context) => UserViewModel.fromAuth(authToken, 'clerkId'),
    ),
    ChangeNotifierProvider(
      create: (ctx) => ContentViewModel(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => PositionViewModel.fromAuth(authToken, 'clerkId', null),
    ),
  ];

  group('Widgets, Services and View Models', () {
    setUpAll(() {
      nock.init();
    });

    setUp(() {
      nock.cleanAll();
      // Auth
      final mockAuthL = nock("https://identitytoolkit.googleapis.com").post(
          "/v1/accounts:signInWithPassword?key=<YOUR API KEY>",
          json.encode(
            {
              'email': '<YOUR ACCOUNT EMAIL HERE>',
              'password': '<YOUR ACCOUNT PWD HERE>',
              'returnSecureToken': true,
            },
          ))
        ..persist()
        ..reply(
          200,
          '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"xFt5SXvRdzQibaId5Wmuojf6oZO2","email":"<YOUR ACCOUNT EMAIL HERE>","displayName":"","idToken":"<YOUR AUTH TOKEN HERE>","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
        );
      final mockAuthClerk = nock("https://identitytoolkit.googleapis.com").post(
          "/v1/accounts:signInWithPassword?key=<YOUR API KEY>",
          '{"email":"clerk@dima.it","password":"qwerty","returnSecureToken":true}')
        ..persist()
        ..reply(
          200,
          '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"clerkId","email":"clerk@dima.it","displayName":"","idToken":"<YOUR AUTH TOKEN HERE>","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
        );
      final mockAuthS = nock("https://identitytoolkit.googleapis.com").post(
          "/v1/accounts:signUp?key=<YOUR API KEY>",
          json.encode(
            {
              'email': '<YOUR ACCOUNT EMAIL HERE>',
              'password': '<YOUR ACCOUNT PWD HERE>',
              'returnSecureToken': true,
            },
          ))
        ..persist()
        ..reply(
          200,
          '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"xFt5SXvRdzQibaId5Wmuojf6oZO2","email":"<YOUR ACCOUNT EMAIL HERE>","displayName":"","idToken":"<YOUR AUTH TOKEN HERE>","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
        );

      // User
      var mockUser = nock("<YOUR FIREBASE URL>")
          .get(startsWith("/users/$userId.json"))
        ..persist()
        ..reply(200,
            '{"address":"Via Milano 1","email":"<YOUR ACCOUNT EMAIL HERE>","favorite_categories":["Men"],"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","is_clerk":false,"name":"Thomas Golfetto","phone":"+393390000000","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","reward_points":0,"shoe_size":45,"size":"45"}');
      var mockClerk = nock("<YOUR FIREBASE URL>")
          .get(startsWith("/users/clerkId.json"))
        ..persist()
        ..reply(200,
            '{"address":"Via Milano 1","email":"clerk@dima.it","favorite_categories":["Men"],"id":"clerkId","is_clerk":true,"name":"Thomas Golfetto","phone":"+393390000000","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","reward_points":0,"shoe_size":45,"size":"45"}');

      var mockUserDelete =
          nock("<YOUR FIREBASE URL>")
              .delete("/users/$userId.json?auth=$authToken")
            ..persist()
            ..reply(200, '');
      var mockUserUpdate =
          nock("<YOUR FIREBASE URL>").put(
              "/users/$userId.json?auth=$authToken",
              '{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":null,"email":"<YOUR ACCOUNT EMAIL HERE>","phone":null,"address":null,"profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":null,"shoe_size":null,"reward_points":0,"favorite_brands":[],"favorite_categories":[]}')
            ..persist()
            ..reply(200, '');
      var mockUserUpdate2 =
          nock("<YOUR FIREBASE URL>").put(
              "/users/$userId.json?auth=$authToken",
              '{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Marco","email":"fake@test.it","phone":"339000001","address":"Milan","profile_image_url":"img2.png","is_clerk":false,"size":"big","shoe_size":44,"reward_points":0,"favorite_brands":["Margiela"],"favorite_categories":["Men","Dresses"]}')
            ..persist()
            ..reply(200, '');

      // Products
      var mockProducts = nock(
              "<YOUR FIREBASE URL>")
          .get("/products.json?auth=$authToken")
        ..persist()
        ..reply(200,
            '{"-MEPxPT8F5BFAZbWokNc":{"brand":"adidas x Gucci","categories":["Men","Tops"],"color":"Red","description":"This is a red t-shirt made of 100% cotton.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","madeIn":"USA","material":"Cotton","price":19.99,"rating":4.5,"sizes":[38,40],"stock":10,"title":"Felpa con cerniera adidas x Gucci","type":"Clothing"},"-NEPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Men","Bottoms"],"color":"Blue","description":"These are blue jeans made of 99% cotton and 1% spandex.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1662417035/717104_ZAKBX_1000_001_100_0000_Light-Camicia-in-pizzo-GG-geometrico.jpg","madeIn":"China","material":"Cotton, Spandex","price":29.99,"rating":4,"sizes":[38,40],"stock":5,"title":"Camicia in pizzo GG geometrico","type":"Clothing"},"-RAPxPT8F5BFAZbWokNb":{"brand":"Gucci","categories":["Women","Dresses"],"color":"Dark violet","description":"This silk chiffon dress is infused with a romantic note through classic accents. Presented with long sleeves, ruffles, pleats and frills, the piece plays with vintage details in subtle ways to reflect the Houses creative narrative.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXF1E9FB_Center_0_0_1200x1200/1669918555/731262_ZHS78_5585_001_100_0000_Light-Silk-chiffon-dress.jpg","madeIn":"Italy","material":"100% Silk","price":2200.0,"rating":4,"sizes":[38,40],"stock":5,"title":"Silk chiffon dress","type":"Clothing"},"-REPxPT8F5BFAZbWokNb":{"brand":"Gucci","categories":["Women","Dresses"],"color":"Magenta","description":"Translating to Original Gucci Creations, this double-breasted jacket presents the Gucci Créations Originales label as a play on traditional sartorial tags. The elegant piece is presented with a precious full canvas construction and peak lapel, while a bright shade of magnet adds an unexpected feel.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXF1E9FB_Center_0_0_1200x1200/1664388069/726517_ZADVL_5896_001_100_0000_Light-Double-breasted-gauze-jacket.jpg","madeIn":"Italy","material":"100% Cupro","price":2400,"rating":4,"sizes":[38,40],"stock":5,"title":"Double-breasted gauze jacket","type":"Clothing"},"-WAPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Women","Bottoms"],"color":"Beige","description":"These are blue jeans made of 99% cotton and 1% spandex.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1669815053/712108_ZAKXW_2254_001_100_0000_Light-adidas-x-Gucci-GG-canvas-skirt.jpg","madeIn":"Italy","material":"Fabric: 71% Cotton, 29% Polyester","price":1400,"rating":4,"sizes":[38,40],"stock":5,"title":"adidas x Gucci GG canvas skirt","type":"Clothing"},"-WIPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Men","Bottoms"],"color":"Black and Green","description":"A second chapter in the adidas and Gucci collection, where the Web continues to juxtapose with the three white stripes and the GG monogram combines with the Trefoil. Pulling inspiration from the Creative Director’s memories of the 80s and 90s, emblematic House’s motifs mix with those of the historic sportswear brand adidas resulting in a series of hybrid looks. This soft wool cardigan features contrasting green intarsia cable knit and ivory 3-Stripe intarsia on the front.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1669815183/717703_XKCQF_1145_001_100_0000_Light-adidas-x-Gucci-wool-cardigan.jpg","madeIn":"Italy","material":"100% Wool.","price":1800,"rating":4,"sizes":[38,40],"stock":5,"title":"adidas x Gucci wool cardigan","type":"Clothing"}}');
      var mockProductsFav =
          nock("<YOUR FIREBASE URL>")
              .get("/userFavorites/$userId.json?auth=$authToken")
            ..persist()
            ..reply(200, '{"-MEPxPT8F5BFAZbWokNc":true}');
      var mockProductsClerkFav =
          nock("<YOUR FIREBASE URL>")
              .get("/userFavorites/clerkId.json?auth=$authToken")
            ..persist()
            ..reply(200, '{"-MEPxPT8F5BFAZbWokNc":true}');
      var mockProductsAdd =
          nock("<YOUR FIREBASE URL>").post(
              "/products.json?auth=$authToken",
              '{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38,40],"gender":"Men","madeIn":"USA"}')
            ..persist()
            ..reply(200, '{"name":"-MEPxPT8F5BFAZbWokNc"}');
      var mockProductsUpd =
          nock("<YOUR FIREBASE URL>").patch(
              "/products/-MEPxPT8F5BFAZbWokNc.json?auth=$authToken",
              '{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38,40],"gender":"Men","madeIn":"USA"}')
            ..persist()
            ..reply(200, '');
      var mockProductsUpd2 =
          nock("<YOUR FIREBASE URL>").patch(
              "/products/-MEPxPT8F5BFAZbWokNc.json?auth=$authToken",
              '{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"brand","material":"Cotton","color":"Red","sizes":[38,40],"gender":"Men","madeIn":"USA"}')
            ..persist()
            ..reply(200, '');

      var mockProductsDel =
          nock("<YOUR FIREBASE URL>")
              .delete("/products/-MEPxPT8F5BFAZbWokNc.json?auth=$authToken")
            ..persist()
            ..reply(200, '');

      // Product
      var mockProduct =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/userFavorites/$userId/product.json?auth=$authToken"),
              'true')
            ..persist()
            ..reply(200, '');
      var mockProduct2 =
          nock("<YOUR FIREBASE URL>").put(
              startsWith(
                  "/userFavorites/$userId/-MEPxPT8F5BFAZbWokNc.json?auth=$authToken"),
              json.encode(
                false,
              ))
            ..persist()
            ..reply(200, '');

      // Requests
      var mockRequestsList = nock(
              "<YOUR FIREBASE URL>")
          .get(startsWith("/requests.json?auth=$authToken"))
        ..persist()
        ..reply(200,
            '{"1":{"1":{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"pending"}}}');
      var mockRequests = nock(
              "<YOUR FIREBASE URL>")
          .get(startsWith("/requests/$userId.json?auth=$authToken"))
        ..persist()
        ..reply(200,
            '{"1":{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"pending"}}');
      var mockRequestsAdd =
          nock("<YOUR FIREBASE URL>").post(
              startsWith("/requests/$userId.json?auth=$authToken"),
              '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"accepted"}')
            ..persist()
            ..reply(200, '{"name":"-NMiZ-9hUAiMDnT6TvSV"}');
      var mockRequestsAdd2 =
          nock("<YOUR FIREBASE URL>").post(
              startsWith("/requests/$userId.json?auth=$authToken"),
              '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"accepted"}')
            ..persist()
            ..reply(200, '{"name":"-NMiZ-9hUAiMDnT6TvSV"}');
      var mockRequestsDelete = nock(
              "<YOUR FIREBASE URL>")
          .delete(startsWith(
              "/requests/$userId/-NMiZ-9hUAiMDnT6TvSV.json?auth=$authToken"))
        ..persist()
        ..reply(200, '');
      var mockRequestsDelete2 =
          nock("<YOUR FIREBASE URL>")
              .delete(startsWith("/requests/$userId/1.json?auth=$authToken"))
            ..persist()
            ..reply(200, '');
      var mockRequestsUpdate =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/requests/$userId/1.json"),
              '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"accepted"}')
            ..persist()
            ..reply(200, '');
      var mockRequestsUpdate2 =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/requests/$userId/1.json"),
              '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"<YOUR ACCOUNT EMAIL HERE>","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"accepted"}')
            ..persist()
            ..reply(200, '');

      // Position
      String positionArea =
          '{"A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"name":"man_area","users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}';
      var mockPosition =
          nock("<YOUR FIREBASE URL>")
              .get(startsWith("/locations/man_area.json"))
            ..persist()
            ..reply(200, positionArea);
      var mockPositionUpdate =
          nock("<YOUR FIREBASE URL>").patch(
              startsWith("/locations/man_area.json?auth=$authToken"),
              '{"name":"man_area","A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}')
            ..persist()
            ..reply(200, '');
      var mockPositionUpdate2 =
      nock("<YOUR FIREBASE URL>").patch(
          startsWith("/locations/man_area.json?auth=$authToken"),
          '{"name":"woman_area","A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}')
        ..persist()
        ..reply(200, '');

      // Cart
      String cart =
          '{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}}';
      var mockCart = nock("<YOUR FIREBASE URL>")
          .get(startsWith("/carts/$userId.json"))
        ..persist()
        ..reply(200, cart);
      var mockCartUpdate =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/carts/$userId.json?auth=$authToken"),
              '{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","productId":"-MEPxPT8F5BFAZbWokNc","title":"Felpa con cerniera adidas x Gucci","quantity":1,"price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg"}}')
            ..persist()
            ..reply(200, '');
      var mockCartUpdate2 =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/carts/$userId.json?auth=$authToken"),
              '{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","productId":"-MEPxPT8F5BFAZbWokNc","title":"Felpa con cerniera adidas x Gucci","quantity":2,"price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg"}}')
            ..persist()
            ..reply(200, '');
      var mockCartUpdate3 =
          nock("<YOUR FIREBASE URL>")
              .put(startsWith("/carts/$userId.json?auth=$authToken"), '{}')
            ..persist()
            ..reply(200, '');
      var mockCartViewUpdate =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/carts/$userId.json?auth=$authToken"),
              '{"productId":{"id":"pid","productId":"productId","title":"title","quantity":1,"price":19.99,"imageUrl":"imageUrl"}}')
            ..persist()
            ..reply(200, '');
      var mockCartViewUpdate2 =
          nock("<YOUR FIREBASE URL>").put(
              startsWith("/carts/$userId.json?auth=$authToken"),
              '{"productId":{"id":"pid","productId":"productId","title":"title","quantity":2,"price":19.99,"imageUrl":"imageUrl"}}')
            ..persist()
            ..reply(200, '');

      // Orders
      var mockOrder = nock("<YOUR FIREBASE URL>")
          .get(startsWith("/orders/$userId.json"))
        ..persist()
        ..reply(200,
            '{"-NKxEVAjjTC7U2MXOgv4":{"amount":19.99,"dateTime":"2023-01-04T15:44:53.136","products":[{"id":"2023-01-04 15:44:06.443","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}]},"-NMidhlUFMmbnGlL_pTd":{"amount":19.99,"dateTime":"2023-01-26T16:15:38.705","products":[{"id":"2023-01-23 19:33:37.349","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}]}}');
      var mockOrderAdd =
          nock("<YOUR FIREBASE URL>").post(
              startsWith("/orders/$userId.json?auth=$authToken"),
              '{"amount":100.0,"dateTime":"2023-01-26T22:17:10.084151","products":[{"id":"id","productId":"pid","title":"title","quantity":1,"price":100.0,"imageUrl":"img.jpg"}]}')
            ..persist()
            ..reply(200, '{"name":"id"}');
      var mockOrderAdd2 =
          nock("<YOUR FIREBASE URL>").post(
              startsWith("/orders/$userId.json?auth=$authToken"),
              '{"amount":39.98,"dateTime":"2023-02-01T00:00:00.000","products":[{"id":"2023-01-23 19:33:37.349","productId":"-MEPxPT8F5BFAZbWokNc","title":"Felpa con cerniera adidas x Gucci","quantity":2,"price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg"}]}')
            ..persist()
            ..reply(200, '{"name":"id"}');

      // Shared Preferences
      SharedPreferences.setMockInitialValues({
        "userData": json.encode({
          "token": authToken,
          "userId": userId,
          "expityDate": '2025-01-26 18:39:28'
        })
      });
    });

    testWidgets('Main test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      final nextButton = find.text('Next');
      expect(nextButton, findsOneWidget);
    });

    testWidgets('OnBoarding test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      final skipButton = find.byKey(const Key('skipButton'));
      expect(skipButton, findsOneWidget);
      await tester.tap(skipButton);
      await tester.pump();
      final signupButton = find.byKey(const Key('signupButton'));
      expect(signupButton, findsOneWidget);
    });

    testWidgets('SplashScreen test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: Providers.authProviders,
          child: Builder(
            builder: (_) =>
                MaterialApp(
                    title: CustomTheme.appTitle,
                    theme: CustomTheme().materialTheme,
                    debugShowCheckedModeBanner: false,
                    home: const Layout(child: SplashScreen())),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key('splashScreen')), findsOneWidget);
    });

    Future<void> authenticateAndDisplayHome(tester) async {
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: Layout(
                child: Layout(
                  child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) =>
                          Scaffold(
                            body: auth.isAuthenticated
                                ? const HomePage()
                                : const AuthScreen().authScreenPage(context),
                          )),
                ),
              ),
              routes: Routes.routeList,
            )),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key('emailField')), '<YOUR ACCOUNT EMAIL HERE>');
      await tester.enterText(find.byKey(const Key('passField')), '<YOUR ACCOUNT PWD HERE>');
      await tester.tap(find.byKey(const Key('signupInsteadButton')));
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('confirmPassField')), '<YOUR ACCOUNT PWD HERE>');
      await tester.tap(find.byKey(const Key('signupInsteadButton')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Auth test', (tester) async {
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('PlpTitle')), findsOneWidget);
    });

    testWidgets('PDP test', (tester) async {
      await authenticateAndDisplayHome(tester);
      await tester.tap(find.byKey(const Key('productLineItem')).first);
      await tester.pump();
      expect(find.byKey(const Key('PdpWidget')), findsOneWidget);
    });

    testWidgets('LineItem test', (tester) async {
      await authenticateAndDisplayHome(tester);
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('lineItemAddToCart-MEPxPT8F5BFAZbWokNc')));
      await tester.tap(find.byKey(const Key('lineItemAddToCart-MEPxPT8F5BFAZbWokNc')).first, warnIfMissed: false);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('lineItemRequest-MEPxPT8F5BFAZbWokNc')));
      await tester.tap(find.byKey(const Key('lineItemAddToCart-MEPxPT8F5BFAZbWokNc')).first, warnIfMissed: false);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
    });

    testWidgets('Add to Cart test', (tester) async {
      await authenticateAndDisplayHome(tester);
      await tester.tap(find.byKey(const Key('productLineItem')).first);
      await tester.pump();
      expect(find.byKey(const Key('PdpWidget')), findsOneWidget);
      expect(find.byKey(const Key('addToCartButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('addToCartButton')));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.byKey(const Key('cartIconButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('cartIconButton')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('cartOrderNowButton')));
      await tester.tap(find.byKey(const Key('cartOrderNowButton')));
      await tester.pump();
    });

    testWidgets('Empty Cart test', (tester) async {
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('cartIconButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('cartIconButton')));
      await tester.pump();
      await tester.drag(find.byKey(const ValueKey('2023-01-23 19:33:37.349')),
          const Offset(-1000.0, 0.0));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('cartItemDismiss')), findsOneWidget);
      await tester.tap(find.byKey(const Key('cartItemDismiss')));
      await tester.pump();
      await tester.pump();
    });

    testWidgets('Filter test', (tester) async {
      await authenticateAndDisplayHome(tester);
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('filterButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('filterButton')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('filterPage')), findsOneWidget);
    });

    testWidgets('Profile test', (tester) async {
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('userIconButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('userIconButton')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('userNextButton')));
      await tester.tap(find.byKey(const Key('userNextButton')),
          warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('userNextButton')).last);
      await tester.tap(find.byKey(const Key('userNextButton')).last,
          warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      await tester.pump();
      await tester.pump();
    });

    testWidgets('Order test', (tester) async {
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('menuIcon3')), findsOneWidget);
      await tester.tap(find.byKey(const Key('menuIcon3')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('orderMain')), findsOneWidget);
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: Layout(
                child: Layout(
                  child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) => const Scaffold(
                            body: OrderSide(),
                          )),
                ),
              ),
              routes: Routes.routeList,
            )),
      );
      await tester.pump();
      expect(find.byKey(const Key('orderSide')), findsOneWidget);
    });

    testWidgets('Request User test', (tester) async {
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('menuIcon2')), findsOneWidget);
      await tester.tap(find.byKey(const Key('menuIcon2')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('requestUserPage')), findsOneWidget);
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: Layout(
                child: Layout(
                  child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) => const Scaffold(
                            body: RequestSide(),
                          )),
                ),
              ),
              routes: Routes.routeList,
            )),
      );
      await tester.pump();
      expect(find.byKey(const Key('requestUserSide')), findsOneWidget);
    });

    testWidgets('Request Clerk test', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthClerkProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: Layout(
                child: Layout(
                  child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) => Scaffold(
                            body: auth.isAuthenticated
                                ? const HomePage()
                                : const AuthScreen().authScreenPage(context),
                          )),
                ),
              ),
              routes: Routes.routeList,
            )),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key('emailField')), 'clerk@dima.it');
      await tester.enterText(find.byKey(const Key('passField')), 'qwerty');
      await tester.pump();
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('menuIcon2')), findsOneWidget);
      await tester.tap(find.byKey(const Key('menuIcon2')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('requestClerkPage')), findsOneWidget);
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: Layout(
                child: Layout(
                  child: Consumer<AuthViewModel>(
                      builder: (context, auth, child) => const Scaffold(
                            body: RequestSide(),
                          )),
                ),
              ),
              routes: Routes.routeList,
            )),
      );
      await tester.pump();
      expect(find.byKey(const Key('requestClerkSide')), findsOneWidget);
    });

    testWidgets('Barcode test', (tester) async {
      /*
      await authenticateAndDisplayHome(tester);
      expect(find.byKey(const Key('menuIcon1')), findsOneWidget);
      await tester.tap(find.byKey(const Key('menuIcon1')));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('barcodeMain')), findsOneWidget);
      */
      await tester.pumpWidget(
        MultiProvider(
            providers: mockAuthProviders,
            child: MaterialApp(
              title: CustomTheme.appTitle,
              theme: CustomTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: const Layout(
                  child: Scaffold(
                body: ScannerInstructions(),
              )),
              routes: Routes.routeList,
            )),
      );
      await tester.pump();
      expect(find.byKey(const Key('barcodeSide')), findsOneWidget);
    });

    testWidgets('AnimatedResize test', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: CustomTheme.appTitle,
          theme: CustomTheme().materialTheme,
          debugShowCheckedModeBanner: false,
          home: const Layout(
            child: AnimatedResize(
              child: Text('test'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('animatedResize')), findsOneWidget);
    });

    testWidgets('AuthService login', (WidgetTester tester) async {
      AuthService service = AuthService();
      late Auth l;
      l = await service.login('<YOUR ACCOUNT EMAIL HERE>', '<YOUR ACCOUNT PWD HERE>');
      expect(l.userId, 'xFt5SXvRdzQibaId5Wmuojf6oZO2');
      l.logout();
    });

    testWidgets('AuthService signup', (WidgetTester tester) async {
      AuthService service = AuthService();
      late Auth l;
      l = await service.signup('<YOUR ACCOUNT EMAIL HERE>', '<YOUR ACCOUNT PWD HERE>');
      expect(l.userId, 'xFt5SXvRdzQibaId5Wmuojf6oZO2');
      l.logout();
    });

    testWidgets('CartService', (WidgetTester tester) async {
      CartService service = CartService(authToken, userId);
      late Cart c;
      c = await service.getCart();
      await service.updateCart(c);
      expect(c.itemCount, 1);
    });

    testWidgets('OrdersService', (WidgetTester tester) async {
      OrdersService service = OrdersService(authToken, userId);
      late List<OrderItem> o;
      o = await service.fetchOrders();
      expect(o.length, 2);
      //List<CartItem> cartProducts = [CartItem(id: 'id', productId: 'pid', title: 'title', quantity: 1, price: 100, imageUrl: 'img.jpg')];
      //OrderItem item = await service.addOrder(cartProducts, 100);
      //expect(item.id, 'id');
    });

    testWidgets('PositionService', (WidgetTester tester) async {
      PositionService service = PositionService(authToken, userId);
      late PositionArea p;
      p = await service.fetchAndSetPositionArea();
      expect(p.name, 'man_area');
      p = await service.updatePositionArea(p);
      expect(p.name, 'man_area');
    });

    testWidgets('ProductService', (WidgetTester tester) async {
      ProductService.authToken = authToken;
      ProductService.userId = userId;
      ProductService service = ProductService();
      bool res = await service
          .toggleFavoriteStatus(Product(id: 'product', isFavorite: true));
      expect(res, true);
    });

    testWidgets('ProductsService', (WidgetTester tester) async {
      ProductsService service = ProductsService(authToken, userId);
      List<Product> res = await service.fetchAndSetProducts();
      expect(res.isNotEmpty, true);
      Product p = Product.fromJson(
          "-MEPxPT8F5BFAZbWokNc",
          json.decode(
              '{"brand":"adidas x Gucci","categories":["Men","Tops"],"color":"Red","description":"This is a red t-shirt made of 100% cotton.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","madeIn":"USA","material":"Cotton","price":19.99,"rating":4.5,"sizes":[38,40],"stock":10,"title":"Felpa con cerniera adidas x Gucci","type":"Clothing"}'),
          null);
      Product r = await service.addProduct(p);
      expect(r.id, '-MEPxPT8F5BFAZbWokNc');
      Product u = await service.updateProduct("-MEPxPT8F5BFAZbWokNc", p);
      expect(u.id, '-MEPxPT8F5BFAZbWokNc');
      Products d =
      await service.deleteProduct(Products([p]), '-MEPxPT8F5BFAZbWokNc');
      List<Product> delRes = d.items;
      expect(delRes.length, 0);
    });

    testWidgets('RequestService', (WidgetTester tester) async {
      RequestService.authToken = authToken;
      RequestService.userId = userId;
      RequestService service = RequestService();
      RequestListService listService = RequestListService(authToken, userId);
      List<Request> requests = await listService.fetchAllRequests();
      expect(requests.length, 1);
      requests = await listService.fetchRequests();
      expect(requests.length, 1);
      Request myR = requests[0];
      Request accept = requests[0];
      accept.status = RequestStatus.accepted;
      service.updateRequest(accept);
      expect(accept.status, RequestStatus.accepted);
      Request res = await listService.addRequest(myR);
      expect(res.id, "-NMiZ-9hUAiMDnT6TvSV");
      requests = await listService.removeRequest(requests, myR);
      expect(requests.length, 1);
    });

    testWidgets('UserService', (WidgetTester tester) async {
      UserService service = UserService(authToken, userId);
      service.createUser('<YOUR ACCOUNT EMAIL HERE>');
      User u = await service.getUser();
      expect(u.email.isNotEmpty, true);
      u = await service.getUserById(userId);
      expect(u.email.isNotEmpty, true);
      service.deleteUser(userId);
    });

    testWidgets('User View Model test', (WidgetTester tester) async {
      AuthViewModel authViewModel = AuthViewModel();
      await authViewModel.signup('<YOUR ACCOUNT EMAIL HERE>', '<YOUR ACCOUNT PWD HERE>');
      await authViewModel.login('<YOUR ACCOUNT EMAIL HERE>', '<YOUR ACCOUNT PWD HERE>');
      expect(authViewModel.token, authToken);
      expect(authViewModel.userId, userId);
      expect(authViewModel.isAuthenticated, true);
      await authViewModel.tryAutoLogin();
      await authViewModel.logout();
      expect(authViewModel.isAuthenticated, false);

      UserViewModel userViewModel = UserViewModel.fromAuth(authToken, userId);
      await userViewModel.getUser();
      await userViewModel.getUserById(userId);
      userViewModel.id = userId;
      userViewModel.name = 'Marco';
      userViewModel.email = 'fake@test.it';
      userViewModel.phone = '339000001';
      userViewModel.address = 'Milan';
      userViewModel.profileImageUrl = 'img2.png';
      userViewModel.size = 'big';
      userViewModel.shoeSize = 44;
      userViewModel.addFavoriteBrand('Margiela');
      userViewModel.removeFavoriteBrand('Zegna');
      userViewModel.addFavoriteCategory(ItemCategory.Dresses);
      userViewModel.removeFavoriteCategory(ItemCategory.Formal);
      await userViewModel.saveChanges();
      expect(userViewModel.name, 'Thomas Golfetto');
      expect(userViewModel.email, '<YOUR ACCOUNT EMAIL HERE>');
      expect(userViewModel.phone, '+393390000000');
      expect(userViewModel.address, 'Via Milano 1');
      expect(userViewModel.isClerk, false);
      expect(userViewModel.profileImageUrl,
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541');
      expect(userViewModel.size, '45');
      expect(userViewModel.shoeSizeString, '45');
      expect(userViewModel.favoriteBrands, []);
      expect(userViewModel.favoriteCategories, [ItemCategory.Men]);
      expect(userViewModel.hashCode, userId.hashCode);
      expect(userViewModel == userViewModel, true);
    });

    testWidgets('Cart Item View Model test', (WidgetTester tester) async {
      CartItemViewModel cartItemViewModel =
          CartItemViewModel.fromExistingCartItem(CartItem(
              id: 'id',
              productId: 'productId',
              title: 'title',
              quantity: 1,
              price: 9.99,
              imageUrl: 'img.png'));
      expect(cartItemViewModel.id, 'id');
      expect(cartItemViewModel.productId, 'productId');
      expect(cartItemViewModel.title, 'title');
      expect(cartItemViewModel.quantity, 1);
      expect(cartItemViewModel.price, 9.99);
      expect(cartItemViewModel.imageUrl, 'img.png');
      cartItemViewModel.incrementQuantity();
      cartItemViewModel.decrementQuantity();
      expect(cartItemViewModel.quantity, 1);
    });

    testWidgets('Content View Model test', (WidgetTester tester) async {
      ContentViewModel contentViewModel = ContentViewModel();
      contentViewModel.updateMainContentIndex(16);
      contentViewModel.updateSideBarIndex(18);
      contentViewModel.updateProductId('pid');
      contentViewModel.setFilters({'test':true});
      expect(contentViewModel.productId, 'pid');
      expect(contentViewModel.mainContentIndex, 16);
      expect(contentViewModel.sideBarIndex, 18);
      expect(contentViewModel.filters['test'], true);
    });

    testWidgets('Order View Model test', (WidgetTester tester) async {
      OrderViewModel orderViewModel = OrderViewModel.fromExistingCartItem(OrderItem(id: 'id', amount: 100, products: [CartItem(id: 'id', productId: 'productId', title: 'title', quantity: 2, price: 9.99, imageUrl: 'img.png')], dateTime: DateTime.now()));
      expect(orderViewModel.getSingleItems(), 2);
      expect(orderViewModel.amount, 100);
      expect(orderViewModel.id.isNotEmpty, true);
      expect(orderViewModel.products.length, 1);
      expect(orderViewModel.dateTime.day, DateTime.now().day);
      OrdersViewModel ordersViewModel = OrdersViewModel.fromAuth(authToken, userId, null);
      await ordersViewModel.fetchAndSetOrders();
      expect(ordersViewModel.getTotalCount(), 2);
      expect(ordersViewModel.items.isNotEmpty, true);
      expect(ordersViewModel.getAverageAmount(), 19.99);
      expect(ordersViewModel.getMaxAmount(), 19.99);
      expect(ordersViewModel.getMinAmount(), 19.99);
      expect(ordersViewModel.groupOrdersByMonth().keys.first, 'January');
      expect(ordersViewModel.getOrdersPerMonthData().keys.first, 'January');
      expect(ordersViewModel.computeExpensiveMonth(), 'January');
    });

    testWidgets('Position View Model test', (WidgetTester tester) async {
      PositionViewModel positionViewModel =
          PositionViewModel.fromAuth(authToken, userId, null);
      await positionViewModel.fetchAndSetPositionArea();
      PositionArea p = positionViewModel.position;
      expect(p.name, 'man_area');
      p.name = 'woman_area';
      positionViewModel.updatePositionArea(p);
      expect(positionViewModel.position.name, 'woman_area');
      expect(positionViewModel.pointInRectangle(0.0, 0.0), false);
      expect(
          positionViewModel.vector({'latitude': 100.0, 'longitude': 100.0},
              {'latitude': 110.0, 'longitude': 100.0})['latitude'],
          10.0);
      expect(
          positionViewModel.dot({'latitude': 3.0, 'longitude': 2.0},
              {'latitude': 3.0, 'longitude': 2.0}),
          13.0);
      await tester.pumpWidget(
        MultiProvider(
          providers: mockAuthProviders,
          child: Builder(
              builder: (_) => MaterialApp(
                  title: CustomTheme.appTitle,
                  home: Layout(
                    child: Layout(
                        child: Consumer<AuthViewModel>(
                            builder: (context, auth, child) =>
                                const PositionTest())),
                  ))),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Product View Model test', (WidgetTester tester) async {
      ProductListViewModel productListViewModel = ProductListViewModel.fromAuth(authToken, userId, null);
      await productListViewModel.fetchAndSetProducts();
      List<ProductViewModel> items = productListViewModel.items;
      expect(productListViewModel.favoriteItems.length, 1);
      expect(productListViewModel.filterByMultipleCriteria({'priceMin':0.0,'priceMax':99999.0,'productTypes':[ProductType.Clothing],'categories':[ItemCategory.Men],'rating':0,'favorite':false}).length, 3);
      expect(productListViewModel.findById('-MEPxPT8F5BFAZbWokNc').price, 19.99);
      productListViewModel.addProduct(items.first);
      expect(productListViewModel.items.length, 6);
      productListViewModel.refreshProduct(items.first);
      items.first.setBrand('brand');
      productListViewModel.updateProduct('-MEPxPT8F5BFAZbWokNc', items.first);
      expect(productListViewModel.findById('-MEPxPT8F5BFAZbWokNc').getProduct.brand, 'brand');
      productListViewModel.deleteProduct('-MEPxPT8F5BFAZbWokNc');
      expect(productListViewModel.items.length, 5);
      ProductViewModel p = items.first;
      p.toggleFavoriteStatus();
      expect(p.isFavorite, false);
      p.setId('id');
      p.setTitle('title');
      p.setDescription('description');
      p.setPrice(0.00);
      p.setImageUrl('imageUrl');
      p.setIsFavorite(true);
      p.setCategories([ItemCategory.Dresses.name]);
      p.setType(ProductType.Beauty);
      p.setStock(1);
      p.setRating(4);
      p.setBrand('brand');
      p.setMaterial('material');
      p.setColor('color');
      p.setSize('1');
      p.setGender('man');
      p.setMadeIn('madeIn');
      expect(p.id, 'id');
      expect(p.title, 'title');
      expect(p.description, 'description');
      expect(p.price, 0.0);
      expect(p.imageUrl, 'imageUrl');
      expect(p.isFavorite, true);
      expect(p.categories.length, 1);
      expect(p.type, ProductType.Beauty);
    });

    testWidgets('Request View Model test', (WidgetTester tester) async {
      RequestListViewModel requestListViewModel =
          RequestListViewModel.fromAuth(authToken, userId, null);
      await requestListViewModel.fetchRequests();
      await requestListViewModel.fetchAllRequests();
      List<RequestViewModel> requests = requestListViewModel.requests;
      RequestViewModel request = requests.first;
      expect(requestListViewModel.pendingRequests.length, 1);
      expect(requestListViewModel.outstandingRequests.length, 0);
      UserViewModel userViewModel = UserViewModel.fromAuth(authToken, userId);
      await userViewModel.getUser();
      requests.first.assignClerk(userViewModel);
      requestListViewModel.addRequest(requests.first);
      requestListViewModel.updateAssignedRequests();
      expect(requestListViewModel.assignedRequests.length, 1);
      expect(requestListViewModel.groupByRequestStatus().keys.first,
          RequestStatus.accepted);
      expect(requestListViewModel.groupRequestsByUser().keys.first,
          'xFt5SXvRdzQibaId5Wmuojf6oZO2');
      expect(requestListViewModel.groupRequestsByProduct().keys.first,
          '-MEPxPT8F5BFAZbWokNc');
      expect(
          requestListViewModel.countRequestsByProduct()['-MEPxPT8F5BFAZbWokNc'],
          1);
      expect(requestListViewModel.findById('1').status, RequestStatus.accepted);
      expect(requestListViewModel.requests.length, 1);
      requestListViewModel.removeRequest(requests.first);
      expect(requestListViewModel.requests.length, 0);

      expect(request.id, '1');
      expect(request.status, RequestStatus.accepted);
      expect(request.request.id, '1');
      expect(request.user.id, userId);
      expect(
          request.message, 'May I receive this product in the dressing room?');
      request.assignClerk(userViewModel);
      request.assignClerk(userViewModel);
      expect(request.clerk!.id, userId);
    });

  });

  group('Models and utilities', ()
  {
    testWidgets('Utils test', (WidgetTester tester) async {
      Map<String, WidgetBuilder> routeList = Routes.routeList;
      expect(routeList[AuthScreen.routeName] != null, true);
      expect(routeList[OnBoarding.routeName] != null, true);
      expect(routeList[SplashScreen.routeName] != null, true);
      expect(userAvatar.isNotEmpty, true);
      expect(baseUrl.isNotEmpty, true);
      expect(ApiKey.isNotEmpty, true);
      expect(baseAuthUrl.isNotEmpty, true);
      expect(Providers.authProviders.isNotEmpty, true);
    });

    testWidgets('Cart Model test', (WidgetTester tester) async {
      Cart cart = Cart.fromJson(json.decode('{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}}'));
      expect(cart.items.isNotEmpty, true);
      expect(cart.toJson().isNotEmpty, true);
      expect(cart.itemCount, 1);
      expect(cart.totalAmount, 19.99);
      cart.addItem('-MEPxPT8F5BFAZbWokNn', 'img.png', 10.0, 'title');
      cart.addSingleItem('-MEPxPT8F5BFAZbWokNn');
      expect(cart.itemCount, 2);
      cart.removeSingleItem('-MEPxPT8F5BFAZbWokNn');
      cart.removeItem('-MEPxPT8F5BFAZbWokNc');
      expect(cart.itemCount, 1);
      cart.clear();
    });

    testWidgets('Exception test', (WidgetTester tester) async {
      AppException e = AppException('message','prefix - ');
      expect(e.toString(), "prefix - message");
      FetchDataException fe = FetchDataException('message');
      expect(fe.toString(), "Error During Communication: message");
      BadRequestException be = BadRequestException('message');
      expect(be.toString(), "Invalid Request: message");
      UnauthorisedException ue = UnauthorisedException('message');
      expect(ue.toString(), "Unauthorised Request: message");
      InvalidInputException ie = InvalidInputException('message');
      expect(ie.toString(), "Invalid Input: message");
      HttpException he = HttpException('message');
      expect(he.toString(), 'message');
    });

    testWidgets('Orders Model test', (WidgetTester tester) async {
      OrderItem item = OrderItem.fromJson('prodId', json.decode('{"amount":19.99,"dateTime":"2023-01-04T15:44:53.136","products":[{"id":"2023-01-04 15:44:06.443","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}]}'));
      expect(item.toString().isNotEmpty, true);
      Orders o = Orders([item]);
      expect(o.items.length, 1);
      o.setOrders([item]);
      o.addOrder(item);
      expect(o.items.length, 2);
    });

    testWidgets('Position Model test', (WidgetTester tester) async {
      PositionArea p = PositionArea.fromJson(json.decode('{"A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"name":"man_area","users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}'));
      expect(p.toJson().isNotEmpty, true);
      expect(p.toString().isNotEmpty, true);
      p.addTimeLog('user', DateTime.now().toIso8601String());
    });

    testWidgets('Product Model test', (WidgetTester tester) async {
      expect(categoryFromString('Formal'), ItemCategory.Formal);
      expect(categoryToString(ItemCategory.Dresses),'Dresses');
      expect(typeFromString('Other'), ProductType.Other);
      Product p = Product.fromJson(
          "-MEPxPT8F5BFAZbWokNc",
          json.decode(
              '{"brand":"adidas x Gucci","categories":["Men","Tops"],"color":"Red","description":"This is a red t-shirt made of 100% cotton.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","madeIn":"USA","material":"Cotton","price":19.99,"rating":4.5,"sizes":[38,40],"stock":10,"title":"Felpa con cerniera adidas x Gucci","type":"Clothing"}'),
          null);
      expect(p.toJson().isNotEmpty, true);
      expect(p.toString().isNotEmpty, true);
      p.setFavValue(true);
      Products products = Products([p]);
      expect(products.items.length, 1);
      expect(products.favoriteItems.length, 1);
      expect(products.findById('-MEPxPT8F5BFAZbWokNc').isFavorite, true);
      products.setItems([p]);
      products.addItem(p);
      products.updateItem('-MEPxPT8F5BFAZbWokNc', p);
      expect(products.items.length, 2);
      expect(products.getExistingProductIndex('-MEPxPT8F5BFc'), -1);
      expect(products.getExistingProduct('-MEPxPT8F5BFc'), null);
      products.deleteProduct('-MEPxPT8F5BFAZbWokNc');
      expect(products.items.length, 0);
    });

    testWidgets('Request Model test', (WidgetTester tester) async {
      expect(statusFromString('completed'),RequestStatus.completed);
      Product p = Product.fromJson(
          "-MEPxPT8F5BFAZbWokNc",
          json.decode(
              '{"brand":"adidas x Gucci","categories":["Men","Tops"],"color":"Red","description":"This is a red t-shirt made of 100% cotton.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","madeIn":"USA","material":"Cotton","price":19.99,"rating":4.5,"sizes":[38,40],"stock":10,"title":"Felpa con cerniera adidas x Gucci","type":"Clothing"}'),
          null);
      Request request = Request(id: 'reqId', user: User(id: 'userId', email: 'test@test.it'), products: [p]);
      expect(request.toJson().isNotEmpty, true);
      expect(request.toString().isNotEmpty, true);
      request.updateStatus(RequestStatus.rejected);
      expect(request.status, RequestStatus.rejected);
      request.assignClerk(User(id: 'clerk', email: 'clerk@cc.it'));
      expect(request.clerk?.id, 'clerk');
      request.unassignClerk();
      expect(request.clerk, null);
      request.assignClerk(User(id: 'clerk', email: 'clerk@cc.it'));
      Requests requests = Requests([request]);
      expect(requests.items.isNotEmpty, true);
      requests.setAssignedRequests('clerk');
      expect(requests.getAssignedRequests.isNotEmpty, true);
      requests.updateItem('reqId', Request(id: 'reqId', user: User(id: 'userId', email: 'test@test.it'), products: [p], message: 'msg'));
      expect(requests.findById('reqId').message, 'msg');
      expect(requests.groupAssignedRequestsByStatus()[RequestStatus.completed], null);
    });

    testWidgets('User Model test', (WidgetTester tester) async {
      Address address = Address(
        street: 'Via x',
        city: 'Milan',
        state: 'Italy',
        zipCode: '20111',
        country: 'IT',
      );
      expect(address.city, 'Milan');
      Auth auth = Auth();
      auth.setAuthData(authToken, userId, DateTime.now());
      auth.token = authToken;
      auth.userId = userId;
      auth.expiryDate = DateTime.now().add(const Duration(days: 1));
      auth.authTimer = null;
      expect(auth.token, authToken);
      expect(auth.userId, userId);
      expect(auth.expiryDate?.isAfter(DateTime.now()), true);
      expect(auth.authTimer, null);
      auth.logout();
      expect(auth.token, null);
      User u = User.fromJson(json.decode(
          '{"id":"$userId","address":"Via Milano 1","email":"<YOUR ACCOUNT EMAIL HERE>","favorite_categories":["Men"],"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","is_clerk":false,"name":"Thomas Golfetto","phone":"+393390000000","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","reward_points":0,"shoe_size":45,"size":"45"}'));
      expect(u.toJson().isNotEmpty, true);
      expect(u.toString().isNotEmpty, true);
      u.id = 'fakeId';
      expect(u.id, 'fakeId');
      u.name = 'marco';
      expect(u.name, 'marco');
      u.email = 'marco@test.it';
      expect(u.email, 'marco@test.it');
      u.phone = '339000000';
      expect(u.phone, '339000000');
      u.address = address.city;
      expect(u.address, 'Milan');
      u.profileImageUrl = 'img.png';
      expect(u.profileImageUrl, 'img.png');
      u.size = '48';
      expect(u.size, '48');
      u.shoeSize = 45;
      expect(u.shoeSize, 45);
      u.addFavoriteBrand('Maison Margiela');
      u.removeFavoriteBrand('Gucci');
      expect(u.favoriteBrands.length, 1);
      u.addFavoriteCategory(ItemCategory.Activewear);
      u.removeFavoriteCategory(ItemCategory.Dresses);
      expect(u.favoriteCategories.length, 2);
    });

    testWidgets('Routes test', (tester) async {
      for (String k in Routes.routeList.keys) {
        expect(Routes.routeList[k] != null, true);
      }
    });
  });
}

class PositionTest extends StatelessWidget {
  const PositionTest({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<PositionViewModel>(context, listen: false)
        .listenLocation(context);
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: null,
        body: Container());
  }
}
