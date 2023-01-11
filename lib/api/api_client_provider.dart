import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

@riverpod
Dio apiClient(_) {
  final dio = Dio();
  final logInterceptor = LogInterceptor();
  dio.interceptors.add(logInterceptor);
  return dio;
}
