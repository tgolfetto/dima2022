class ProtectedService {
  // The user's authentication token
  String? authToken;
  // The ID of the user
  String? userId;

  // Constructor for ProtectedService
  // @param authToken the user's authentication token
  // @param userId the ID of the user
  ProtectedService(this.authToken, this.userId);
}
