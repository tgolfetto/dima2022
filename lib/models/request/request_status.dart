/*
RequestStatus: an enumeration representing the possible statuses of a request
*/
enum RequestStatus {
  pending,
  accepted,
  rejected,
  completed,
}

/*
Returns the RequestStatus value corresponding to the given string.
@param status the string to convert
@return the RequestStatus value corresponding to the given string
@throws Exception if the given string is not a valid RequestStatus value
@requires status != null
@ensures the returned value is equal to the RequestStatus value corresponding to the given string
*/
RequestStatus statusFromString(String status) {
  switch (status) {
    case 'pending':
      return RequestStatus.pending;
    case 'accepted':
      return RequestStatus.accepted;
    case 'rejected':
      return RequestStatus.rejected;
    case 'completed':
      return RequestStatus.completed;

    default:
      throw Exception('Invalid category');
  }
}
