import 'package:flutter/material.dart';

/// 获取数据的错误类型
enum StoneFetchDataErrorType {
  /// 网络错误
  networkError,
  /// 获取失败
  fetchFailed,
  /// 没有数据
  noData,
  /// 没有列表
  noList,
}

/// 请求数据发生错误时的描述信息
///
/// 用于 [StoneFutureBody] 或 [StoneStreamBody]
class StoneFetchDataError extends Error {
  StoneFetchDataError({
    this.type = StoneFetchDataErrorType.fetchFailed,
    this.message,
  });

  /// 错误类型
  StoneFetchDataErrorType type;
  /// 错误提示
  String message;
}

/// 页面内容组件构建器
typedef StoneAsyncBodyContentBuilder<T> = Function(BuildContext context, T data);
/// 错误信息组件构建器
typedef StoneAsyncBodyErrorBuilder = Function(BuildContext context, StoneFetchDataError error, VoidCallback onRetry);

/// 将 [Stream] 或 [Future] 中的 error 转换为 [StoneFetchDataError]
typedef StoneAsyncBodyErrorConverter = StoneFetchDataError Function<ErrorType>(ErrorType error);

/// 基于 [FutureBuilder] 的页面内容脚手架
class StoneFutureBody<T> extends StatelessWidget {
  const StoneFutureBody({
    Key key,
    this.onRetry,
    this.initialData,
    @required this.future,
    @required this.loadingBuilder,
    @required this.contentBuilder,
    @required this.errorBuilder,
    this.errorConverter,
  }) : super(key: key);

  /// 重试回调
  final VoidCallback onRetry;
  /// 初始数据
  final T initialData;
  /// 异步任务
  final Future<T> future;

  /// 加载状态组件构建器
  final WidgetBuilder loadingBuilder;
  /// 页面内容组件构建器
  final StoneAsyncBodyContentBuilder<T> contentBuilder;
  /// 错误信息组件构建器
  final StoneAsyncBodyErrorBuilder errorBuilder;

  /// 将 [Stream] 或 [Future] 中的 error 转换为 [StoneFetchDataError]
  final StoneAsyncBodyErrorConverter errorConverter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none
            || snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder(context);
        }

        if (snapshot.hasError) {
          final error = () {
            if (snapshot.error is StoneFetchDataError) {
              return snapshot.error;
            }
            if (errorConverter != null) {
              return errorConverter(snapshot.error);
            }
            return StoneFetchDataError(type: StoneFetchDataErrorType.fetchFailed);
          }();

          return errorBuilder(context, error, onRetry);
        }

        return contentBuilder(context, snapshot.data);
      }
    );
  }
}

/// 基于 [StreamBuilder] 的页面内容脚手架
class StoneStreamBody<T> extends StatelessWidget {
  const StoneStreamBody({
    Key key,
    this.onRetry,
    this.initialData,
    @required this.stream,
    @required this.loadingBuilder,
    @required this.contentBuilder,
    @required this.errorBuilder,
    this.errorConverter,
  }) : super(key: key);

  /// 重试回调
  final VoidCallback onRetry;
  /// 初始数据
  final T initialData;
  /// 异步任务
  final Stream<T> stream;

  /// 加载状态组件构建器
  final WidgetBuilder loadingBuilder;
  /// 页面内容组件构建器
  final StoneAsyncBodyContentBuilder<T> contentBuilder;
  /// 错误信息组件构建器
  final StoneAsyncBodyErrorBuilder errorBuilder;

  /// 将 [Stream] 或 [Future] 中的 error 转换为 [StoneFetchDataError]
  final StoneAsyncBodyErrorConverter errorConverter;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return contentBuilder(context, snapshot.data);
        }

        if (!snapshot.hasError) {
          return loadingBuilder(context);
        }

        final error = () {
          if (snapshot.error is StoneFetchDataError) {
            return snapshot.error;
          }
          if (errorConverter != null) {
            return errorConverter(snapshot.error);
          }
          return StoneFetchDataError(type: StoneFetchDataErrorType.fetchFailed);
        }();

        return errorBuilder(context, error, onRetry);
      },
    );
  }
}