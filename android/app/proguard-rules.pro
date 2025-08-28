# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.kts.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# VLC Player specific rules
-keep class org.videolan.libvlc.** { *; }
-keep class org.videolan.medialibrary.** { *; }
-keep class org.videolan.vlc.** { *; }
-keepclassmembers class org.videolan.libvlc.** { *; }
-keepclassmembers class org.videolan.medialibrary.** { *; }
-keepclassmembers class org.videolan.vlc.** { *; }

# VLC JNI
-keep class org.videolan.libvlc.interfaces.** { *; }
-keep class org.videolan.libvlc.Media { *; }
-keep class org.videolan.libvlc.Media$* { *; }
-keep class org.videolan.libvlc.MediaPlayer { *; }
-keep class org.videolan.libvlc.MediaPlayer$* { *; }
-keep class org.videolan.libvlc.MediaList { *; }
-keep class org.videolan.libvlc.MediaList$* { *; }
-keep class org.videolan.libvlc.MediaDiscoverer { *; }
-keep class org.videolan.libvlc.MediaDiscoverer$* { *; }
-keep class org.videolan.libvlc.LibVLC { *; }
-keep class org.videolan.libvlc.LibVLC$* { *; }

# Flutter VLC Player
-keep class io.flutter.plugins.** { *; }
-keep class software.solid.fluttervlcplayer.** { *; }

# Native methods
-keepclasseswithmembernames class * {
    native <methods>;
}