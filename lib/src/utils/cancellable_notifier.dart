import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:result_notifier/result_notifier.dart';

class CancellableNotifier<T> extends FutureNotifier<T> {
  CancellableNotifier({
    required this.id,
    required Future<T> Function(CancelToken) fetch,
    super.expiration = const Duration(seconds: 30),
  })  : super(
          (not) => fetch((not as CancellableNotifier).cancelToken),
          onReset: (not) => (not as CancellableNotifier)._onReset(),
        );

  final String id;
  final CancelToken cancelToken = CancelToken();

  void _onReset() {
    log('🗑 Canceling $id');
    cancelToken.cancel();
  }
}
