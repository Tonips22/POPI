// lib/utils/accessible_routes.dart
import 'package:flutter/material.dart';

Route<T> buildAccessibleFadeRoute<T>({
  required BuildContext context,
  required Widget page,
}) {
  // accessibleNavigation = true cuando el usuario ha pedido reducir animaciones
  final media = MediaQuery.of(context);
  final bool reduceMotion = media.accessibleNavigation;

  if (reduceMotion) {
    // SIN animación: cambio inmediato de pantalla
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  // Con fade suave
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
