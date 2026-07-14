import 'package:flutter/services.dart' show AssetManifest, rootBundle;

class BrandIcons {
  static List<String> _paths = const [];

  /// Call once at startup (before runApp).
  static Future<void> init() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    _paths = manifest
        .listAssets()
        .where((p) => p.startsWith('assets/brands/') && p.endsWith('.svg'))
        .toList();
  }

  /// Returns the brand SVG asset path whose filename contains the (lowercased)
  /// issuer, or null if none / issuer too short to match safely.
  static String? resolve(String issuer) {
    final needle = issuer.trim().toLowerCase().replaceAll(' ', '-');
    if (needle.length < 2) return null; // guard: '' is contained in everything
    for (final path in _paths) {
      final name = path.split('/').last.replaceAll('.svg', '');
      if (name.contains(needle)) return path;
    }
    return null;
  }
}
