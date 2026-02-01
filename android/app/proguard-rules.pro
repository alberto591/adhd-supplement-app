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
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# GSON & Flutter Local Notifications (Fixes TypeToken crash)
# Preserves generic signatures needed for de-serialization of scheduled notifications
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.Token { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep class * implements com.google.gson.reflect.TypeToken
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep public class com.dexterous.flutterlocalnotifications.models.** { *; }

