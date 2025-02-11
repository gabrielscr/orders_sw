abstract class HttpService {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });

  Future<T> postForTokenOnly<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });

  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
  });

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? body,
  });
}
