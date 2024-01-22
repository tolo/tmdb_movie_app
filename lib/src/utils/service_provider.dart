import 'package:flutter/material.dart';

/// Functions signature for a providing a service via a [SimpleServiceProvider].
typedef ProvideService = Object Function(SimpleServiceProvider serviceLocator);

/// Probably the simplest and modestest provider of service lookup / dependency injection you'll ever see. Certainly
/// not the most clever.
class SimpleServiceProvider extends InheritedWidget {
  const SimpleServiceProvider({super.key, required Map<Type, ProvideService> services, required super.child})
      : _services = services;

  final Map<Type, ProvideService> _services;

  T get<T>() => _services[T]?.call(this) as T;

  static SimpleServiceProvider of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<SimpleServiceProvider>()!;
  }

  static T service<T>(BuildContext context) => SimpleServiceProvider.of(context).get<T>();

  @override bool updateShouldNotify(SimpleServiceProvider oldWidget) => false;
}

/// Simple convenience extension for [BuildContext] to get a service.
extension SimpleServiceProviderExtensions on BuildContext {
  T service<T>() => SimpleServiceProvider.service<T>(this);
}

/// Helper class for providing a singleton service.
class SingletonService {
  static ProvideService provide(ProvideService provideService) => SingletonService(provideService).service;

  SingletonService(this.provideService);

  final ProvideService provideService;
  Object? _singleton;

  Object service(SimpleServiceProvider serviceProvider) => _singleton ??= provideService(serviceProvider);
}
