import 'dart:convert';

import '../utilities/console_logger.dart';

/// A generic result wrapper that encapsulates success/failure states
sealed class Result<T> {
  const Result();

  factory Result.success({
    String? title,
    String? message,
    String? state,
    required T data,
  }) = Success<T>;

  factory Result.failure({
    String? title,
    String? message,
    String? state,
    required Object error,
    StackTrace? stackTrace,
  }) = Failure<T>;

  /// Creates a Result from an HTTP response with proper error handling
  /// If parser is not provided, returns the raw response body as data
  // Create a Result from an HTTP-like response. This accepts a dynamic
  // response to avoid pulling an explicit `http` dependency in the
  // offline-only build. The response is expected to have `statusCode`,
  // `body`, and `reasonPhrase` members when present.
  factory Result.fromHttpResponse({
    required dynamic response,
    T Function(Map<String, dynamic>?)? parser,
  }) {
    try {
      final int? statusCode = response?.statusCode as int?;
      final isSuccess =
          statusCode != null && statusCode >= 200 && statusCode < 300;

      if (isSuccess) {
        final T parsedData;

        final body = response?.body;
        if (parser != null) {
          parsedData = parser(
            body != null && (body as String).isNotEmpty
                ? json.decode(body) as Map<String, dynamic>?
                : null,
          );
        } else {
          parsedData = body as T;
        }

        return Result.success(
          title: 'HTTP Success',
          message: response?.reasonPhrase,
          state: statusCode.toString(),
          data: parsedData,
        );
      } else {
        return Result.failure(
          title: 'HTTP Error',
          message: response?.reasonPhrase,
          state: statusCode?.toString(),
          error: 'HTTP Error with status code: ${statusCode ?? 'unknown'}',
        );
      }
    } catch (e, stackTrace) {
      return Result.failure(
        title: 'Parse Error',
        message: 'Failed to parse response body with parser type of $T',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  String? get title => switch (this) {
    Success(title: final title) => title,
    Failure(title: final title) => title,
  };

  String? get message => switch (this) {
    Success(message: final message) => message,
    Failure(message: final message) => message,
  };

  String? get state => switch (this) {
    Success(state: final state) => state,
    Failure(state: final state) => state,
  };

  T? get data => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  Object? get error => switch (this) {
    Success() => null,
    Failure(error: final error) => error,
  };

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  R? onSuccess<R>(R Function(Success<T> success) success) => switch (this) {
    Success() => success(this as Success<T>),
    Failure() => null,
  };

  R? onFailure<R>(R Function(Failure<T> failure) failure) => switch (this) {
    Success() => null,
    Failure() => failure(this as Failure<T>),
  };

  R when<R>({
    required R Function(Success<T> success) success,
    required R Function(Failure<T> failure) failure,
  }) {
    return switch (this) {
      Success() => success(this as Success<T>),
      Failure() => failure(this as Failure<T>),
    };
  }
}

final class Success<T> extends Result<T> {
  @override
  final String? title;
  @override
  final String? message;
  @override
  final String? state;
  @override
  final T data;

  Success({this.title, this.message, this.state, required this.data});
}

final class Failure<T> extends Result<T> {
  @override
  final String? title;
  @override
  final String? message;
  @override
  final String? state;
  @override
  final Object error;
  final StackTrace? stackTrace;

  Failure({
    this.title,
    this.message,
    this.state,
    required this.error,
    this.stackTrace,
  }) {
    // Always log any error to console in debug mode
    ce(error, title: title, message: message, state: state);
  }
}
