class APIResponse<T> {
  const APIResponse(
      {this.data, this.errorMessage, this.errorCode, this.error = false});

  final T data;
  final bool error;
  final int errorCode;
  final String errorMessage;
}
