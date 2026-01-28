## NeuroStack Proguard Rules

# Keep RevenueCat classes
-keep class com.revenuecat.purchases.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Support for specific packages
-dontwarn com.revenuecat.purchases.**

# Ignore missing Play Core classes (standard Flutter release build fix)
-dontwarn com.google.android.play.core.**

# gRPC / BoringSSL (Ensure native methods are preserved)
-keep class io.grpc.** { *; }
-keep class com.google.protobuf.** { *; }
-dontwarn io.grpc.**

# App Specific Natives
-keep class com.neurostack2.app.MainActivity { *; }

# OkHttp (Used by many plugins)
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
