import 'package:flutter/foundation.dart';

class CartCountManager {
  final ValueNotifier<int> _cartCountNotifier = ValueNotifier(0);

  int get cartCount => _cartCountNotifier.value;

  set cartCount(int value) => _cartCountNotifier.value = value;

  ValueNotifier<int> get cartCountNotifier => _cartCountNotifier;
}
