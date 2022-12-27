class HttpException implements Exception {
  //exception is an abstract class --> siamo obbligato ad implemetare dei metodi (toString che folgiamo ovveridare)

  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
