class HttpEx implements Exception{
  final String msg;
  final int statusCode;

  HttpEx({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}