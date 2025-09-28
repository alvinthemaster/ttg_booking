# Running TTG Resort Booking App on Android Studio Emulator

## Prerequisites
1. **Android Studio** installed with Android SDK
2. **Flutter SDK** installed and added to PATH
3. **Android Studio AVD** (Android Virtual Device) set up

## Step-by-Step Instructions

### 1. Set Up Android Emulator
1. Open **Android Studio**
2. Go to **Tools** → **AVD Manager**
3. Create a new Virtual Device if you don't have one:
   - Click **"Create Virtual Device"**
   - Choose a phone (e.g., Pixel 7)
   - Select an API level (recommended: API 30+)
   - Click **"Finish"**
4. **Start the emulator** by clicking the play button

### 2. Verify Flutter Setup
```bash
# Check if Flutter recognizes your Android setup
flutter doctor

# Check available devices
flutter devices
```

### 3. Run the App
```bash
# Navigate to project directory
cd ttg_booking

# Get dependencies
flutter pub get

# Run on the Android emulator
flutter run -d <device-id>

# Or if only one device is available
flutter run
```

## Device ID Examples
- `emulator-5554` - First Android emulator
- `emulator-5556` - Second Android emulator
- Use `flutter devices` to see your specific device IDs

## Alternative Method: Using Android Studio
1. Open the project folder in **Android Studio**
2. Wait for the project to index
3. Make sure an **Android emulator is running**
4. Click the **"Run"** button (green triangle) or press **Shift+F10**

## Troubleshooting

### Common Issues:
1. **"No devices found"**
   - Make sure Android emulator is running
   - Check `flutter devices` command

2. **Build errors**
   - Run `flutter clean` then `flutter pub get`
   - Make sure Android SDK is properly configured

3. **Gradle build failures**
   - Ensure you have a stable internet connection
   - Check Android Studio SDK settings

### If the UI has layout issues:
The app is functional but may have some overflow warnings. You can still navigate and use all features:
- **Home**: Browse resorts with filtering
- **Calendar**: View availability calendar (select a resort first)
- **Favorites**: Manage favorite resorts
- **Profile**: User profile and settings

## Features Working:
✅ Resort browsing and filtering
✅ Calendar availability system
✅ Favorites management
✅ Resort detail views
✅ Booking system
✅ Navigation between screens

The calendar feature shows real-time availability with:
- **Green**: Available rooms
- **Orange**: Limited availability
- **Red**: Fully booked
- Dynamic pricing based on demand and seasonality

## Performance Tips:
- Use a phone emulator (not tablet) for better performance
- Enable hardware acceleration in AVD settings
- Close other applications while running the emulator