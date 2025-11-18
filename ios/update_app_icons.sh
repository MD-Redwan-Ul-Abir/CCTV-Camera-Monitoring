#!/bin/bash

# Script to help update Flutter app icons and launch images for iOS
# This script explains what you need to do but doesn't actually replace the images
# as you need to provide your own custom artwork

echo "App Store Review Warnings Found:"
echo "1. App icon is set to the default placeholder icon"
echo "2. Launch image is set to the default placeholder icon"
echo ""
echo "To fix these issues, you need to replace the default images with your custom artwork:"
echo ""
echo "For App Icons:"
echo "- You need to create 18 different sizes of your app icon (from 20x20 to 1024x1024)"
echo "- Save them as:"
echo "  - Icon-App-20x20@1x.png, Icon-App-20x20@2x.png, Icon-App-20x20@3x.png"
echo "  - Icon-App-29x29@1x.png, Icon-App-29x29@2x.png, Icon-App-29x29@3x.png"
echo "  - Icon-App-40x40@1x.png, Icon-App-40x40@2x.png, Icon-App-40x40@3x.png"
echo "  - Icon-App-60x60@2x.png, Icon-App-60x60@3x.png"
echo "  - Icon-App-76x76@1x.png, Icon-App-76x76@2x.png"
echo "  - Icon-App-83.5x83.5@2x.png"
echo "  - Icon-App-1024x1024@1x.png"
echo "- Replace the files in ios/Runner/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "For Launch Images:"
echo "- You need to create your launch screen images in 3 sizes:"
echo "  - LaunchImage.png (1x), LaunchImage@2x.png, LaunchImage@3x.png"
echo "- Replace the files in ios/Runner/Assets.xcassets/LaunchImage.imageset/"
echo ""
echo "Easiest approach:"
echo "1. Use an online icon generator or design tool to create all required sizes"
echo "2. Alternatively, use Flutter's built-in package: flutter_launcher_icons"
echo ""
echo "To use flutter_launcher_icons package:"
echo "1. Add to pubspec.yaml:"
echo '   dev_dependencies:'
echo '     flutter_launcher_icons: "^0.13.1"'
echo ""
echo "2. Add configuration to pubspec.yaml:"
echo '   flutter_launcher_icons:'
echo '     android: "launcher_icon"'
echo '     ios: true'
echo '     image_path: "assets/images/app_icon.png"  # Your source icon (at least 1024x1024)'
echo '     min_sdk_android: 21 # Android min SDK Version'
echo ""
echo "3. Run: flutter pub get"
echo "4. Run: dart run flutter_launcher_icons:main"
echo ""
echo "For launch screen customization, you can use flutter_native_splash package:"
echo "1. Add to pubspec.yaml:"
echo '   dev_dependencies:'
echo '     flutter_native_splash: "^2.3.6"'
echo ""
echo "2. Add configuration to pubspec.yaml:"
echo '   flutter_native_splash:'
echo '     color: "#ffffff"  # Your background color'
echo '     image: assets/images/splash.png  # Your splash image'
echo '     color_dark: "#121212"  # Dark mode background color (optional)'
echo '     image_dark: assets/images/splash_dark.png  # Dark mode splash image (optional)'
echo ""
echo "3. Run: dart run flutter_native_splash:create"
echo ""
echo "After replacing images, clean and rebuild:"
echo "flutter clean && flutter build ipa --export-method app-store"