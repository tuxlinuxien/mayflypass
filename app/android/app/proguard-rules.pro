# Google ML Kit barcode scanning (used by mobile_scanner) — keep from R8 shrinking
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-dontwarn com.google.mlkit.**

# mobile_scanner plugin
-keep class dev.steenbakker.mobile_scanner.** { *; }
