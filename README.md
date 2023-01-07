# DIMA 2022 
Idea progetto, per ora:
App utilizzata nei negozi di vestiti dai clienti con funzionalità: 
- login (sia cliente che commesso)
- scan di un tag/codice dal vestito per avere informazioni
- richiesta taglia/colore differente da camerino con notifica sull'app del commesso (Push Notification + Chat)
- tracciamento reparto in cui è l'utente a fini di business (Location GPS)

![alt text](https://i.imgur.com/JN76OwT.jpeg)
![alt text](https://i.imgur.com/9ZXhrxH.png)

## Screens
- SplashScreen
- OnBoarding
- Login/SignUp
- Homepage

## Boxes
- Settings 
- PDP
- PLP
- cart_box.dart - Cart
- RiepilogoOrdine
- Camerino
- barcode_scanner_box.dart - Scanner
- request_list_box.dart - ListaRichieste (Commessa)

## Da fare:
- Requests Page User
- Requests Page Clerk
- Request Detail da aprire nel side
- Add/Edit new product Clerk
- OrdersPage: cosa mettiamo nella SIDE??
- TESTING!
- DESIGN DOC
- PRESENTAZIONE

## WIP:
- LayoutBuilder in tutte le home per margine sotto
- Filters UI
    - non mantiene lo stato (se chiudo e riapro non mantiene le spunte)
    - UI del filtro Price da rivedere
- Homepage (PLP product_item_line height)
- Navigation (side non sempre sincronizzato nelle varie res)

## Fatto:
- Base app
- On Boarding
- Splash
- Auth Screen
- Cart
- Orders
- User Profile
- Menu

## Dependencies:
-  http
-  lottie
-  provider

## Read List:
-   https://medium.com/flutterworld/flutter-mvvm-architecture-f8bed2521958
