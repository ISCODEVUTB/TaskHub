import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void smartPop(BuildContext context, {required String fallbackRoute}) {
  if (Navigator.of(context).canPop()) {
    context.pop();
  } else {
    context.go(fallbackRoute);
  }
} 