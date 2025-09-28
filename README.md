# TTG Resort Booking App

A modern Flutter mobile application for booking beach resorts with an intuitive and user-friendly design.

## Features

### 📅 **Calendar Availability System**
- **Monthly Calendar View**: Interactive calendar showing availability for entire months
- **Real-time Availability**: See available, limited, or fully booked dates at a glance
- **Dynamic Pricing**: Prices adjust based on demand, seasonality, and availability
- **Detailed Day Information**: Tap any date for detailed availability and pricing
- **Smart Booking Integration**: Direct booking from calendar with pre-selected dates

### 🏖️ Resort Types
- **White Sand Beaches**: Pristine white sand beach resorts
- **Black Sand Beaches**: Unique volcanic black sand beach resorts

### 🏨 Booking Options
- **Multiple Room Types**: Choose between rooms and cottages
- **Multi-Room Booking**: Book multiple rooms/cottages in a single reservation
- **Flexible Guest Count**: Accommodate different group sizes

### 🔍 Advanced Filtering
- **Sand Type Filter**: Filter by white or black sand beaches
- **Price Range**: Set minimum and maximum price filters
- **Star Rating**: Filter by minimum star rating (1-5 stars)

### ⭐ Featured Content
- **Top 5 Resorts**: Showcases the highest-rated resorts
- **Complete Resort Listings**: Browse all available resorts
- **Detailed Resort Information**: View amenities, descriptions, and room options

### 📱 Navigation
Bottom navigation bar with four main sections:
- **Home**: Browse and filter resorts
- **Calendar**: View resort availability calendar with real-time data
- **Favorite**: Save and access favorite resorts
- **Profile**: User profile and app settings

## Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **UI/UX**: Material Design 3
- **Fonts**: Google Fonts (Poppins)
- **Icons**: Material Icons + Flutter Rating Bar

## Dependencies

- `flutter`: Flutter framework
- `provider`: State management solution
- `google_fonts`: Custom font integration
- `flutter_rating_bar`: Star rating widgets
- `table_calendar`: Interactive calendar widget for availability display
- `intl`: Internationalization and date formatting
- `shared_preferences`: Local data persistence
- `http`: Network requests (for future API integration)
- `flutter_svg`: SVG image support

## Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ttg_booking
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app on Android**
   ```bash
   flutter run -d <android-device-id>
   # Or for Android emulator
   flutter run -d emulator-5554
   ```

4. **For Android Studio Emulator**
   - Open Android Studio
   - Start an AVD (Android Virtual Device)
   - Run: `flutter devices` to see available devices
   - Use the device ID with `flutter run -d <device-id>`

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── resort.dart          # Data models
├── providers/
│   ├── resort_provider.dart # Resort data management
│   ├── favorite_provider.dart # Favorites management
│   ├── booking_provider.dart # Booking management
│   └── calendar_provider.dart # Calendar availability management
├── screens/
│   ├── main_screen.dart     # Bottom navigation wrapper
│   ├── home_screen.dart     # Resort browsing and filtering
│   ├── calendar_screen.dart # Interactive availability calendar
│   ├── favorite_screen.dart # Favorite resorts
│   ├── profile_screen.dart  # User profile
│   ├── resort_detail_screen.dart # Resort details
│   ├── booking_process_screen.dart # Booking flow
│   └── booking_detail_screen.dart # Booking details
└── widgets/
    ├── resort_card.dart     # Resort display card
    ├── top_resort_card.dart # Featured resort card
    ├── filter_section.dart  # Filtering controls
    └── booking_card.dart    # Booking display card
```

## Features in Detail

### Calendar Availability System
- Interactive monthly calendar view for each resort
- Color-coded availability status (Available/Limited/Fully Booked)
- Real-time room availability numbers displayed on each date
- Dynamic pricing based on demand, seasonality, and availability
- Holiday and weekend detection with adjusted pricing
- Detailed day information with booking integration
- Realistic booking patterns with weekend/holiday surge pricing

### Resort Discovery
- Beautiful card-based layout for resort listings
- High-quality placeholder graphics with gradient backgrounds
- Filter by sand type, price range, and star ratings
- Top-rated resort carousel highlighting the best options

### Booking System
- Interactive date picker for check-in/check-out
- Guest count selector
- Room/cottage quantity selection
- Real-time price calculation
- Booking confirmation and management

### Favorites System
- Heart icon to add/remove favorites
- Persistent favorite storage using SharedPreferences
- Dedicated favorites screen with management options

### Modern UI/UX
- Material Design 3 principles
- Consistent color scheme with ocean-inspired blues
- Smooth animations and transitions
- Responsive design for various screen sizes
- Intuitive navigation patterns

## Sample Data

The app includes sample resort data featuring:
- 6 diverse beach resorts
- Mix of white and black sand beaches
- Various price points and ratings
- Multiple room types and amenities
- Locations from around the world

## Future Enhancements

- [ ] Integration with real resort booking APIs
- [ ] User authentication and profiles
- [ ] Push notifications for booking updates
- [ ] Photo galleries for resorts and rooms
- [ ] Reviews and ratings system
- [ ] Payment gateway integration
- [ ] Offline mode support
- [ ] Multi-language support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support or questions, please contact: support@ttgresorts.com

---

Built with ❤️ using Flutter