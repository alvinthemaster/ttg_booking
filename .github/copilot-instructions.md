# TTG Resort Booking App

A Flutter mobile application for booking beach resorts with modern UI/UX design.

## Features
- Two resort types: White sand and Black sand beaches
- Multi-room and cottage booking capability
- Price range filtering (minimum and maximum)
- 5-star rating system
- Top 5 beach resorts based on ratings
- Complete beach resort listings
- Bottom navigation: Home, Book, Favorite, Profile
- Modern and user-friendly design

## Development Status
- [x] Project requirements clarified
- [x] Flutter project scaffolded
- [x] UI components implemented
- [x] Navigation structure created
- [x] Booking functionality added
- [x] Testing completed - App runs successfully on web
- [x] Documentation finalized

## Tech Stack
- Flutter
- Dart
- Material Design 3
- Provider (State Management)
- Google Fonts

## How to Run
1. Navigate to project directory: `cd ttg_booking`
2. Install dependencies: `flutter pub get`
3. Run on web: `flutter run -d web-server --web-port 8080`
4. Open browser at: `http://localhost:8080`

## Project Structure
- **Models**: Resort, BookingRequest, RoomOption data models
- **Providers**: State management for resorts, favorites, and bookings
- **Screens**: Home, Book, Favorite, Profile, and detail screens
- **Widgets**: Reusable UI components like ResortCard, FilterSection

The app successfully demonstrates all requested features including resort filtering, booking system, favorites management, and modern UI design.