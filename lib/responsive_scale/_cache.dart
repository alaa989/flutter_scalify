import 'package:flutter/material.dart';

class _SimpleLRUCache<K, V> {
  final int capacity;
  final Map<K, V> _map = {};
  final List<K> _order = [];

  _SimpleLRUCache(this.capacity);

  V? operator [](K key) => _map[key];

  void operator []=(K key, V value) {
    if (_map.containsKey(key)) {
      // move to end
      _order.remove(key);
      _order.add(key);
      _map[key] = value;
      return;
    }
    if (_map.length >= capacity) {
      final evict = _order.removeAt(0);
      _map.remove(evict);
    }
    _map[key] = value;
    _order.add(key);
  }
}

// Provide caches with limited size to avoid unbounded memory growth
final _edgeInsetsCache = _SimpleLRUCache<int, EdgeInsets>(128);
final _borderRadiusCache = _SimpleLRUCache<int, BorderRadius>(128);

int _makeKeyFromDouble(double value, double scale) {
  final int a = (value * 1000).round();
  final int b = (scale * 1000).round();

  return (a * 31) + b;
}

/// Get cached EdgeInsets.all(value * scale)
EdgeInsets cachedAll(double value, double scale) {
  final key = _makeKeyFromDouble(value, scale);
  final existing = _edgeInsetsCache[key];
  if (existing != null) return existing;
  final e = EdgeInsets.all(value * scale);
  _edgeInsetsCache[key] = e;
  return e;
}

/// Get cached BorderRadius.circular(value * scale)
BorderRadius cachedCircularRadius(double value, double scale) {
  final key = _makeKeyFromDouble(value, scale);
  final existing = _borderRadiusCache[key];
  if (existing != null) return existing;
  final r = BorderRadius.circular(value * scale);
  _borderRadiusCache[key] = r;
  return r;
}
