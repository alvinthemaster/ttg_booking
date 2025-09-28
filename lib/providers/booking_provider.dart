import 'package:flutter/foundation.dart';
import '../models/resort.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingRequest> _bookings = [];
  BookingRequest? _currentBooking;

  List<BookingRequest> get bookings => _bookings;
  BookingRequest? get currentBooking => _currentBooking;

  void startBooking(String resortId) {
    _currentBooking = BookingRequest(
      resortId: resortId,
      roomBookings: [],
      checkIn: DateTime.now().add(const Duration(days: 1)),
      checkOut: DateTime.now().add(const Duration(days: 3)),
      totalGuests: 1,
      totalPrice: 0.0,
    );
    notifyListeners();
  }

  void updateCheckInDate(DateTime date) {
    if (_currentBooking != null) {
      _currentBooking = BookingRequest(
        resortId: _currentBooking!.resortId,
        roomBookings: _currentBooking!.roomBookings,
        checkIn: date,
        checkOut: _currentBooking!.checkOut.isBefore(date.add(const Duration(days: 1))) 
            ? date.add(const Duration(days: 1)) 
            : _currentBooking!.checkOut,
        totalGuests: _currentBooking!.totalGuests,
        totalPrice: _calculateTotalPrice(),
      );
      notifyListeners();
    }
  }

  void updateCheckOutDate(DateTime date) {
    if (_currentBooking != null && date.isAfter(_currentBooking!.checkIn)) {
      _currentBooking = BookingRequest(
        resortId: _currentBooking!.resortId,
        roomBookings: _currentBooking!.roomBookings,
        checkIn: _currentBooking!.checkIn,
        checkOut: date,
        totalGuests: _currentBooking!.totalGuests,
        totalPrice: _calculateTotalPrice(),
      );
      notifyListeners();
    }
  }

  void updateTotalGuests(int guests) {
    if (_currentBooking != null) {
      _currentBooking = BookingRequest(
        resortId: _currentBooking!.resortId,
        roomBookings: _currentBooking!.roomBookings,
        checkIn: _currentBooking!.checkIn,
        checkOut: _currentBooking!.checkOut,
        totalGuests: guests,
        totalPrice: _currentBooking!.totalPrice,
      );
      notifyListeners();
    }
  }

  void addRoomBooking(String roomOptionId, double pricePerNight) {
    if (_currentBooking != null) {
      final existingBookingIndex = _currentBooking!.roomBookings
          .indexWhere((booking) => booking.roomOptionId == roomOptionId);
      
      List<RoomBooking> updatedBookings = List.from(_currentBooking!.roomBookings);
      
      if (existingBookingIndex >= 0) {
        updatedBookings[existingBookingIndex] = RoomBooking(
          roomOptionId: roomOptionId,
          quantity: updatedBookings[existingBookingIndex].quantity + 1,
          pricePerNight: pricePerNight,
        );
      } else {
        updatedBookings.add(RoomBooking(
          roomOptionId: roomOptionId,
          quantity: 1,
          pricePerNight: pricePerNight,
        ));
      }

      _currentBooking = BookingRequest(
        resortId: _currentBooking!.resortId,
        roomBookings: updatedBookings,
        checkIn: _currentBooking!.checkIn,
        checkOut: _currentBooking!.checkOut,
        totalGuests: _currentBooking!.totalGuests,
        totalPrice: _calculateTotalPrice(),
      );
      notifyListeners();
    }
  }

  void removeRoomBooking(String roomOptionId) {
    if (_currentBooking != null) {
      final existingBookingIndex = _currentBooking!.roomBookings
          .indexWhere((booking) => booking.roomOptionId == roomOptionId);
      
      if (existingBookingIndex >= 0) {
        List<RoomBooking> updatedBookings = List.from(_currentBooking!.roomBookings);
        
        if (updatedBookings[existingBookingIndex].quantity > 1) {
          updatedBookings[existingBookingIndex] = RoomBooking(
            roomOptionId: roomOptionId,
            quantity: updatedBookings[existingBookingIndex].quantity - 1,
            pricePerNight: updatedBookings[existingBookingIndex].pricePerNight,
          );
        } else {
          updatedBookings.removeAt(existingBookingIndex);
        }

        _currentBooking = BookingRequest(
          resortId: _currentBooking!.resortId,
          roomBookings: updatedBookings,
          checkIn: _currentBooking!.checkIn,
          checkOut: _currentBooking!.checkOut,
          totalGuests: _currentBooking!.totalGuests,
          totalPrice: _calculateTotalPrice(),
        );
        notifyListeners();
      }
    }
  }

  int getRoomQuantity(String roomOptionId) {
    if (_currentBooking == null) return 0;
    
    final booking = _currentBooking!.roomBookings
        .where((booking) => booking.roomOptionId == roomOptionId)
        .firstOrNull;
    
    return booking?.quantity ?? 0;
  }

  double _calculateTotalPrice() {
    if (_currentBooking == null) return 0.0;
    
    double totalPerNight = 0.0;
    for (var roomBooking in _currentBooking!.roomBookings) {
      totalPerNight += roomBooking.totalPrice;
    }
    
    return totalPerNight * _currentBooking!.totalNights;
  }

  void confirmBooking() {
    if (_currentBooking != null && _currentBooking!.roomBookings.isNotEmpty) {
      _bookings.add(_currentBooking!);
      _currentBooking = null;
      notifyListeners();
    }
  }

  void cancelCurrentBooking() {
    _currentBooking = null;
    notifyListeners();
  }

  void cancelBooking(int index) {
    if (index >= 0 && index < _bookings.length) {
      _bookings.removeAt(index);
      notifyListeners();
    }
  }
}