import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dima2022/main.dart';
import 'package:dima2022/models/cart/cart.dart';
import 'package:dima2022/models/cart/cart_item.dart';
import 'package:dima2022/models/orders/order_item.dart';
import 'package:dima2022/models/position/position_area.dart';
import 'package:dima2022/models/product/product.dart';
import 'package:dima2022/models/user/auth.dart';
import 'package:dima2022/services/auth_service.dart';
import 'package:dima2022/services/cart_service.dart';
import 'package:dima2022/services/orders_service.dart';
import 'package:dima2022/services/position_service.dart';
import 'package:dima2022/services/product_service.dart';
import 'package:dima2022/utils/providers.dart';
import 'package:dima2022/utils/routes.dart';
import 'package:dima2022/view/auth_screen.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view/splash_screen.dart';
import 'package:dima2022/view_models/user_view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout/layout.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:nock/nock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:fake_async/fake_async.dart';

void main() {

  const String authToken =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwNWI0MDljNmYyMmM0MDNlMWY5MWY5ODY3YWM0OTJhOTA2MTk1NTgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGltYTIwMjItNDkxYzQiLCJhdWQiOiJkaW1hMjAyMi00OTFjNCIsImF1dGhfdGltZSI6MTY3NDY3NTA1NywidXNlcl9pZCI6InhGdDVTWHZSZHpRaWJhSWQ1V211b2pmNm9aTzIiLCJzdWIiOiJ4RnQ1U1h2UmR6UWliYUlkNVdtdW9qZjZvWk8yIiwiaWF0IjoxNjc0Njc1MDU3LCJleHAiOjE2NzQ2Nzg2NTcsImVtYWlsIjoidGhvbWFzQHRob21hcy5pdCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0aG9tYXNAdGhvbWFzLml0Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.QU4f4YUGGguJYXtFlRNkn5yIaB1FYn94l25uBBE5gMsTaCsVw9tX_8PArH8fc98_BSQ0eQWK_yzPq2yn8lEebNKAVwA0PsdQp_CQwD0MZ4ihcUS3sttcVtLGrMo6h0j6Je-qB9D8hxO19EnINmqlWsveJnAFHp8hZVkwgvj3LLtv7EqcKp5NNCQyQc6_Q5a2XX-vp3Jet23IdrpxxuMwiUmlUCr_7sJFhkHPSCl4VGJjq_WgtIgPUrfKEnt8yvhkyCnbROFdBsFaK-zALS6IqSC1OnzFa8DZL4aJoF-XqY3ZuXLs-8hqT774x6mhG7q4AQG8f0w_Q7na5HOizyHCtw";
  const String userId = "xFt5SXvRdzQibaId5Wmuojf6oZO2";

  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();

    // Auth
    final mockAuthL = nock("https://identitytoolkit.googleapis.com").post(
        "/v1/accounts:signInWithPassword?key=AIzaSyCjphU9SWwimRUhpIjGGzQRlqfSd72H-Zc",
        json.encode(
          {
            'email': 'thomas@thomas.it',
            'password': 'thomas',
            'returnSecureToken': true,
          },
        ))
      ..reply(
        200,
        '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"xFt5SXvRdzQibaId5Wmuojf6oZO2","email":"thomas@thomas.it","displayName":"","idToken":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwNWI0MDljNmYyMmM0MDNlMWY5MWY5ODY3YWM0OTJhOTA2MTk1NTgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGltYTIwMjItNDkxYzQiLCJhdWQiOiJkaW1hMjAyMi00OTFjNCIsImF1dGhfdGltZSI6MTY3NDY3NTA1NywidXNlcl9pZCI6InhGdDVTWHZSZHpRaWJhSWQ1V211b2pmNm9aTzIiLCJzdWIiOiJ4RnQ1U1h2UmR6UWliYUlkNVdtdW9qZjZvWk8yIiwiaWF0IjoxNjc0Njc1MDU3LCJleHAiOjE2NzQ2Nzg2NTcsImVtYWlsIjoidGhvbWFzQHRob21hcy5pdCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0aG9tYXNAdGhvbWFzLml0Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.QU4f4YUGGguJYXtFlRNkn5yIaB1FYn94l25uBBE5gMsTaCsVw9tX_8PArH8fc98_BSQ0eQWK_yzPq2yn8lEebNKAVwA0PsdQp_CQwD0MZ4ihcUS3sttcVtLGrMo6h0j6Je-qB9D8hxO19EnINmqlWsveJnAFHp8hZVkwgvj3LLtv7EqcKp5NNCQyQc6_Q5a2XX-vp3Jet23IdrpxxuMwiUmlUCr_7sJFhkHPSCl4VGJjq_WgtIgPUrfKEnt8yvhkyCnbROFdBsFaK-zALS6IqSC1OnzFa8DZL4aJoF-XqY3ZuXLs-8hqT774x6mhG7q4AQG8f0w_Q7na5HOizyHCtw","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
      );
    final mockAuthS = nock("https://identitytoolkit.googleapis.com").post(
        "/v1/accounts:signUp?key=AIzaSyCjphU9SWwimRUhpIjGGzQRlqfSd72H-Zc",
        json.encode(
          {
            'email': 'thomas@thomas.it',
            'password': 'thomas',
            'returnSecureToken': true,
          },
        ))
      ..reply(
        200,
        '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"xFt5SXvRdzQibaId5Wmuojf6oZO2","email":"thomas@thomas.it","displayName":"","idToken":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwNWI0MDljNmYyMmM0MDNlMWY5MWY5ODY3YWM0OTJhOTA2MTk1NTgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGltYTIwMjItNDkxYzQiLCJhdWQiOiJkaW1hMjAyMi00OTFjNCIsImF1dGhfdGltZSI6MTY3NDY3NTA1NywidXNlcl9pZCI6InhGdDVTWHZSZHpRaWJhSWQ1V211b2pmNm9aTzIiLCJzdWIiOiJ4RnQ1U1h2UmR6UWliYUlkNVdtdW9qZjZvWk8yIiwiaWF0IjoxNjc0Njc1MDU3LCJleHAiOjE2NzQ2Nzg2NTcsImVtYWlsIjoidGhvbWFzQHRob21hcy5pdCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0aG9tYXNAdGhvbWFzLml0Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.QU4f4YUGGguJYXtFlRNkn5yIaB1FYn94l25uBBE5gMsTaCsVw9tX_8PArH8fc98_BSQ0eQWK_yzPq2yn8lEebNKAVwA0PsdQp_CQwD0MZ4ihcUS3sttcVtLGrMo6h0j6Je-qB9D8hxO19EnINmqlWsveJnAFHp8hZVkwgvj3LLtv7EqcKp5NNCQyQc6_Q5a2XX-vp3Jet23IdrpxxuMwiUmlUCr_7sJFhkHPSCl4VGJjq_WgtIgPUrfKEnt8yvhkyCnbROFdBsFaK-zALS6IqSC1OnzFa8DZL4aJoF-XqY3ZuXLs-8hqT774x6mhG7q4AQG8f0w_Q7na5HOizyHCtw","registered":true,"refreshToken":"APJWN8f-Ql1aF1UQsZmqEMDjmifcIApPt5TcOklkHETU8m_WrbqoooNV_oHpMwzdiYLCn0cyxGVpMfFYWuK5xIEQfzPEtkKm-Oqrz_qJyekVxMSxsBIUgS4e67eV-PMZZhKwPKof44VRVc9E5kgkJ8LIY4TDGZ-u5sp-nRBA5tzec-JCTUOLRiAE2LCS2cgclIuQX5mz_lIfk86ACzAQr0gc4SvZH7MqjQ","expiresIn":"3600"}',
      );

    // User
    var mockUser = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .get(startsWith("/users/$userId.json"))
      ..reply(200,
          '{"address":"Via Milano 1","email":"thomas@thomas.it","favorite_categories":["Men"],"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","is_clerk":false,"name":"Thomas Golfetto","phone":"+393390000000","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","reward_points":0,"shoe_size":45,"size":"45"}');
    var mockUserDelete =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .delete("/users/$userId.json?auth=$authToken")
          ..reply(200, '');
    var mockUserUpdate =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .put("/users/$userId.json?auth=$authToken")
          ..reply(200, '');

    // Products
    var mockProducts = nock(
            "https://dima2022-491c4-default-rtdb.firebaseio.com")
        .get("/products.json?auth=$authToken")
      ..reply(200,
          '{"-MEPxPT8F5BFAZbWokNc":{"brand":"adidas x Gucci","categories":["Men","Tops"],"color":"Red","description":"This is a red t-shirt made of 100% cotton.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","madeIn":"USA","material":"Cotton","price":19.99,"rating":4.5,"sizes":[38,40],"stock":10,"title":"Felpa con cerniera adidas x Gucci","type":"Clothing"},"-NEPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Men","Bottoms"],"color":"Blue","description":"These are blue jeans made of 99% cotton and 1% spandex.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1662417035/717104_ZAKBX_1000_001_100_0000_Light-Camicia-in-pizzo-GG-geometrico.jpg","madeIn":"China","material":"Cotton, Spandex","price":29.99,"rating":4,"sizes":[38,40],"stock":5,"title":"Camicia in pizzo GG geometrico","type":"Clothing"},"-RAPxPT8F5BFAZbWokNb":{"brand":"Gucci","categories":["Women","Dresses"],"color":"Dark violet","description":"This silk chiffon dress is infused with a romantic note through classic accents. Presented with long sleeves, ruffles, pleats and frills, the piece plays with vintage details in subtle ways to reflect the Houses creative narrative.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXF1E9FB_Center_0_0_1200x1200/1669918555/731262_ZHS78_5585_001_100_0000_Light-Silk-chiffon-dress.jpg","madeIn":"Italy","material":"100% Silk","price":2200,"rating":4,"sizes":[38,40],"stock":5,"title":"Silk chiffon dress","type":"Clothing"},"-REPxPT8F5BFAZbWokNb":{"brand":"Gucci","categories":["Women","Dresses"],"color":"Magenta","description":"Translating to Original Gucci Creations, this double-breasted jacket presents the Gucci Créations Originales label as a play on traditional sartorial tags. The elegant piece is presented with a precious full canvas construction and peak lapel, while a bright shade of magnet adds an unexpected feel.","gender":"Men","imageUrl":"https://media.gucci.com/style/HEXF1E9FB_Center_0_0_1200x1200/1664388069/726517_ZADVL_5896_001_100_0000_Light-Double-breasted-gauze-jacket.jpg","madeIn":"Italy","material":"100% Cupro","price":2400,"rating":4,"sizes":[38,40],"stock":5,"title":"Double-breasted gauze jacket","type":"Clothing"},"-WAPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Women","Bottoms"],"color":"Beige","description":"These are blue jeans made of 99% cotton and 1% spandex.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1669815053/712108_ZAKXW_2254_001_100_0000_Light-adidas-x-Gucci-GG-canvas-skirt.jpg","madeIn":"Italy","material":"Fabric: 71% Cotton, 29% Polyester","price":1400,"rating":4,"sizes":[38,40],"stock":5,"title":"adidas x Gucci GG canvas skirt","type":"Clothing"},"-WIPxPT8F5BFAZbWokNb":{"brand":"adidas x Gucci","categories":["Men","Bottoms"],"color":"Black and Green","description":"A second chapter in the adidas and Gucci collection, where the Web continues to juxtapose with the three white stripes and the GG monogram combines with the Trefoil. Pulling inspiration from the Creative Director’s memories of the 80s and 90s, emblematic House’s motifs mix with those of the historic sportswear brand adidas resulting in a series of hybrid looks. This soft wool cardigan features contrasting green intarsia cable knit and ivory 3-Stripe intarsia on the front.","gender":"Women","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1669815183/717703_XKCQF_1145_001_100_0000_Light-adidas-x-Gucci-wool-cardigan.jpg","madeIn":"Italy","material":"100% Wool.","price":1800,"rating":4,"sizes":[38,40],"stock":5,"title":"adidas x Gucci wool cardigan","type":"Clothing"}}');

    // Product
    var mockProduct = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .put(startsWith("/userFavorites/$userId/product.json?auth=$authToken"), 'true')
      ..reply(200, '');

    // Requests
    var mockRequests =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .get(startsWith("/requests/$userId.json"))
          ..reply(200, '');
    var mockRequestsAdd =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com").post(
            startsWith("/requests/$userId.json"),
            '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"thomas@thomas.it","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"pending"}')
          ..reply(200, '{"name":"-NMiZ-9hUAiMDnT6TvSV"}');
    var mockRequestsDelete =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .delete(startsWith("/requests/$userId.json"))
          ..reply(200, '');
    var mockRequestsUpdate =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com").put(
            startsWith("/requests/$userId.json"),
            '{"user":{"id":"xFt5SXvRdzQibaId5Wmuojf6oZO2","name":"Thomas Golfetto","email":"thomas@thomas.it","phone":"+393390000000","address":"Via Milano 1","profile_image_url":"https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541","is_clerk":false,"size":"45","shoe_size":45,"reward_points":0,"favorite_brands":[],"favorite_categories":["Men"]},"clerk":null,"products":{"-MEPxPT8F5BFAZbWokNc":{"title":"Felpa con cerniera adidas x Gucci","description":"This is a red t-shirt made of 100% cotton.","price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","categories":["Men","Tops"],"type":"Clothing","stock":10,"rating":4.5,"brand":"adidas x Gucci","material":"Cotton","color":"Red","sizes":[38],"gender":"Men","madeIn":"USA"}},"message":"May I receive this product in the dressing room?","status":"accepted"}')
          ..reply(200, '');

    // Position
    String positionArea =
        '{"A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"name":"man_area","users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}';
    var mockPosition =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .get(startsWith("/locations/man_area.json"))
          ..reply(200, positionArea);
    var mockPositionUpdate =
        nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
            .patch(startsWith("/locations/man_area.json?auth=$authToken"), '{"name":"man_area","A":{"latitude":45.517544,"longitude":9.098277},"B":{"latitude":45.439906,"longitude":9.250999},"C":{"latitude":45.441099,"longitude":9.122074},"D":{"latitude":45.439906,"longitude":9.238359},"users":{"AoYHY9BJpCM6y1gEmL0kyVkFnm32":["2023-01-23T17:08:21.258","2023-01-23T17:08:36.924","2023-01-23T17:09:22.712","2023-01-23T17:13:10.583"],"xFt5SXvRdzQibaId5Wmuojf6oZO2":["2023-01-05T20:20:36.794","2023-01-05T20:20:36.794","2023-01-05T20:21:53.913","2023-01-05T20:22:18.817","2023-01-05T20:22:46.979","2023-01-05T20:24:07.902","2023-01-05T20:26:20.256","2023-01-05T20:44:42.403","2023-01-05T20:47:09.481","2023-01-05T20:47:26.286","2023-01-05T20:52:54.077","2023-01-05T20:53:16.190","2023-01-19T17:10:43.047","2023-01-19T17:13:04.098","2023-01-19T17:13:23.819","2023-01-19T17:14:26.355","2023-01-19T17:17:30.759","2023-01-19T17:18:40.432","2023-01-20T16:24:27.743","2023-01-20T16:35:09.455","2023-01-20T16:37:10.712","2023-01-20T16:37:23.943","2023-01-20T16:37:35.367","2023-01-20T16:38:52.728","2023-01-20T16:39:22.715","2023-01-20T16:39:34.168","2023-01-20T16:39:51.819","2023-01-20T16:42:01.925","2023-01-20T16:42:14.177","2023-01-20T16:43:00.977","2023-01-20T16:45:42.823","2023-01-20T16:46:24.688","2023-01-20T16:46:53.618","2023-01-20T16:47:06.180","2023-01-20T16:47:55.389","2023-01-20T16:48:50.524","2023-01-20T16:49:11.438","2023-01-20T16:56:35.242","2023-01-20T17:08:45.306","2023-01-20T17:10:55.454","2023-01-20T17:13:05.348","2023-01-20T17:14:52.885","2023-01-20T17:15:15.374","2023-01-20T17:19:12.195","2023-01-20T17:21:29.911","2023-01-23T12:15:39.644","2023-01-23T12:28:23.161","2023-01-23T12:32:05.291","2023-01-23T12:32:38.036","2023-01-23T12:34:24.512","2023-01-23T12:37:13.266","2023-01-23T12:38:01.218","2023-01-23T12:54:56.594","2023-01-23T12:55:08.954","2023-01-23T13:10:38.149","2023-01-23T13:11:08.885","2023-01-23T13:15:58.122","2023-01-23T15:33:44.464","2023-01-23T15:35:05.933","2023-01-23T16:15:03.283","2023-01-23T16:16:13.009","2023-01-23T16:24:40.063","2023-01-23T16:27:33.325","2023-01-23T16:28:24.737","2023-01-23T16:41:09.209","2023-01-23T16:42:04.141","2023-01-23T17:16:40.804","2023-01-23T17:17:08.453","2023-01-23T17:17:28.028","2023-01-23T17:17:48.566","2023-01-23T17:18:27.828","2023-01-23T17:33:26.915","2023-01-23T17:43:26.462","2023-01-23T17:44:56.721","2023-01-23T17:45:38.153","2023-01-23T17:46:05.218","2023-01-23T17:47:04.667","2023-01-23T17:47:48.265","2023-01-23T18:01:03.758","2023-01-23T18:02:03.804","2023-01-23T18:02:58.080","2023-01-23T18:06:41.075","2023-01-23T18:14:00.970","2023-01-23T18:30:50.173","2023-01-23T18:31:44.983","2023-01-23T19:08:48.937","2023-01-23T19:10:15.593","2023-01-23T19:11:40.288","2023-01-24T14:37:48.900","2023-01-24T14:38:16.326","2023-01-24T15:56:25.535","2023-01-24T16:03:59.515","2023-01-24T16:15:00.026","2023-01-24T16:15:22.111","2023-01-24T16:42:24.693","2023-01-24T16:45:40.098","2023-01-24T16:49:19.874","2023-01-24T16:53:00.396","2023-01-24T16:55:57.004","2023-01-24T16:56:30.068","2023-01-24T16:56:42.027","2023-01-24T16:56:55.971","2023-01-24T17:03:25.469","2023-01-24T17:19:19.080","2023-01-24T17:20:37.367","2023-01-24T17:21:18.042","2023-01-24T17:22:47.595","2023-01-25T17:28:57.877","2023-01-25T17:34:46.126","2023-01-25T17:35:24.797","2023-01-25T17:43:54.577","2023-01-25T17:44:47.243","2023-01-25T17:49:33.531","2023-01-25T17:59:05.300","2023-01-25T18:19:33.446","2023-01-25T18:20:05.005"]}}')
          ..reply(200, '');

    // Cart
    String cart =
        '{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}}';
    var mockCart = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .get(startsWith("/carts/$userId.json"))
      ..reply(200, cart);
    var mockCartUpdate = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .put(startsWith("/carts/$userId.json?auth=$authToken"), '{"-MEPxPT8F5BFAZbWokNc":{"id":"2023-01-23 19:33:37.349","productId":"-MEPxPT8F5BFAZbWokNc","title":"Felpa con cerniera adidas x Gucci","quantity":1,"price":19.99,"imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg"}}')
          ..reply(200, '');

    // Orders
    var mockOrder = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .get(startsWith("/orders/$userId.json"))
      ..reply(200,
          '{"-NKxEVAjjTC7U2MXOgv4":{"amount":19.99,"dateTime":"2023-01-04T15:44:53.136","products":[{"id":"2023-01-04 15:44:06.443","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}]},"-NMidhlUFMmbnGlL_pTd":{"amount":19.99,"dateTime":"2023-01-26T16:15:38.705","products":[{"id":"2023-01-23 19:33:37.349","imageUrl":"https://media.gucci.com/style/HEXE0E8E5_Center_0_0_1200x1200/1672418808/724623_XJEGU_7476_001_100_0000_Light-Felpa-con-cerniera-adidas-x-Gucci.jpg","price":19.99,"productId":"-MEPxPT8F5BFAZbWokNc","quantity":1,"title":"Felpa con cerniera adidas x Gucci"}]}}');
    var mockOrderAdd = nock("https://dima2022-491c4-default-rtdb.firebaseio.com")
        .post(startsWith("/orders/$userId.json?auth=$authToken"),'{"amount":100.0,"dateTime":"2023-01-26T22:17:10.084151","products":[{"id":"id","productId":"pid","title":"title","quantity":1,"price":100.0,"imageUrl":"img.jpg"}]}')
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
  /*
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
        providers: authProviders,
        child: Builder(
          builder: (_) => MaterialApp(
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


  testWidgets('Auth test', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: authProviders,
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
        find.byKey(const Key('emailField')), 'thomas@thomas.it');
    await tester.enterText(find.byKey(const Key('passField')), 'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPassField')), 'thomas');
    await tester.tap(find.byKey(const Key('signupInsteadButton')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
    //expect(find.byKey(const ValueKey('HomePageBody')), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3600));
  });
  */

  testWidgets('AuthService login', (WidgetTester tester) async {
    AuthService service = AuthService();
    late Auth l;
    l = await service.login('thomas@thomas.it', 'thomas');
    expect(l.userId, 'xFt5SXvRdzQibaId5Wmuojf6oZO2');
    l.logout();
  });

  testWidgets('AuthService signup', (WidgetTester tester) async {
    AuthService service = AuthService();
    late Auth l;
    l = await service.signup('thomas@thomas.it', 'thomas');
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
    bool res = await service.toggleFavoriteStatus(Product(id: 'product', isFavorite: true));
    expect(res, true);
  });


}
