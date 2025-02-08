abstract class HttpService {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, dynamic>? multipartData,
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
