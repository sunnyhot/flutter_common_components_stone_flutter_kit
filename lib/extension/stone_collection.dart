import 'package:flutter/material.dart';

extension StoneList<E> on List<E> {
  E get firstOrNull => this.isEmpty ? null : this[0];
  E get lastOrNull => this.isEmpty ? null : this[this.length - 1];
}