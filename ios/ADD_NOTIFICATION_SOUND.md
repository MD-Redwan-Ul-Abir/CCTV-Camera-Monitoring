# Add Notification Sound to iOS Project

## Steps to add the notification sound file to Xcode:

1. **Open Xcode project:**
   - Navigate to the `ios` folder in Terminal
   - Run: `open Runner.xcworkspace`

2. **Add sound file to Xcode:**
   - In Xcode, right-click on the `Runner` folder in the left sidebar
   - Select "Add Files to Runner..."
   - Navigate to and select `notificationaudio.mp3` in the `ios/Runner/` directory
   - **IMPORTANT:** Make sure to check the following options:
     - ✅ "Copy items if needed" (should be checked)
     - ✅ "Create groups" (should be selected)
     - ✅ "Add to targets: Runner" (should be checked)
   - Click "Add"

3. **Verify the file was added:**
   - In the left sidebar, you should now see `notificationaudio.mp3` under the Runner folder
   - Click on the Runner target in the left sidebar
   - Go to "Build Phases" tab
   - Expand "Copy Bundle Resources"
   - Verify that `notificationaudio.mp3` is listed there
   - If it's not there, click the "+" button and add it

4. **Clean and rebuild:**
   - In Xcode menu: Product → Clean Build Folder (⇧⌘K)
   - Then build and run the app

## Alternative Method (if above doesn't work):

If the sound doesn't play, you can try using the default iOS notification sound by changing line 129 in `lib/infrastructure/services/notificationHelperService.dart`:

```dart
// Change from:
sound: '$notificationSound.mp3',

// To (for default sound):
// sound: 'default',
```

## Testing:

After adding the sound file:
1. Build and run the app on a physical iOS device (sounds don't work in simulator)
2. Send a test notification
3. You should hear the custom notification sound

---

**Note:** The notification sound file `notificationaudio.mp3` is already in the `ios/Runner/` directory. You just need to add it to the Xcode project using the steps above.
