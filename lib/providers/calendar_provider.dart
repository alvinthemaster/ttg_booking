import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/resort.dart';

enum SlotAvailability { available, booked, limited }

class AvailabilitySlot {
  final DateTime date;
  final SlotAvailability availability;
  final int totalRooms;
  final int availableRooms;
  final double basePrice;

  AvailabilitySlot({
    required this.date,
    required this.availability,
    required this.totalRooms,
    required this.availableRooms,
    required this.basePrice,
  });

  double get occupancyRate => (totalRooms - availableRooms) / totalRooms;
  bool get isFullyBooked => availableRooms == 0;
  bool get hasLimitedAvailability => availableRooms <= (totalRooms * 0.3);
}

class CalendarProvider extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedResortId;
  final Map<String, Map<DateTime, AvailabilitySlot>> _resortAvailability = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Getters
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  String? get selectedResortId => _selectedResortId;
  CalendarFormat get calendarFormat => _calendarFormat;

  // Initialize availability data for all resorts
  void initializeAvailability(List<Resort> resorts) {
    _resortAvailability.clear();
    
    for (Resort resort in resorts) {
      _resortAvailability[resort.id] = _generateAvailabilityData(resort);
    }
    notifyListeners();
  }

  // Generate mock availability data for a resort
  Map<DateTime, AvailabilitySlot> _generateAvailabilityData(Resort resort) {
    Map<DateTime, AvailabilitySlot> availability = {};
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(const Duration(days: 365)); // One year ahead

    // Total rooms/cottages for the resort
    int totalRooms = resort.roomOptions.fold(0, (sum, room) => sum + 5); // Assume 5 units per room type

    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      // Create realistic availability patterns
      int availableRooms = _calculateAvailableRooms(date, totalRooms);
      double basePrice = _calculateDynamicPrice(date, resort.minPrice, availableRooms, totalRooms);
      
      SlotAvailability slotType;
      if (availableRooms == 0) {
        slotType = SlotAvailability.booked;
      } else if (availableRooms <= (totalRooms * 0.3)) {
        slotType = SlotAvailability.limited;
      } else {
        slotType = SlotAvailability.available;
      }

      availability[DateTime(date.year, date.month, date.day)] = AvailabilitySlot(
        date: date,
        availability: slotType,
        totalRooms: totalRooms,
        availableRooms: availableRooms,
        basePrice: basePrice,
      );
    }

    return availability;
  }

  // Calculate available rooms based on realistic patterns
  int _calculateAvailableRooms(DateTime date, int totalRooms) {
    // Weekend and holiday patterns
    bool isWeekend = date.weekday >= 6;
    bool isHoliday = _isHoliday(date);
    bool isSummerSeason = date.month >= 6 && date.month <= 8;
    bool isWinterHoliday = date.month == 12 || date.month == 1;

    // Base availability percentage
    double availabilityRate = 0.7; // 70% base availability

    // Adjust for patterns
    if (isWeekend) availabilityRate -= 0.2;
    if (isHoliday) availabilityRate -= 0.3;
    if (isSummerSeason) availabilityRate -= 0.15;
    if (isWinterHoliday) availabilityRate -= 0.1;

    // Add some randomness
    availabilityRate += (DateTime.now().millisecond % 20 - 10) / 100;
    
    // Ensure reasonable bounds
    availabilityRate = availabilityRate.clamp(0.0, 1.0);

    return (totalRooms * availabilityRate).round();
  }

  // Calculate dynamic pricing based on availability
  double _calculateDynamicPrice(DateTime date, double basePrice, int available, int total) {
    double occupancyRate = (total - available) / total;
    bool isWeekend = date.weekday >= 6;
    bool isHoliday = _isHoliday(date);
    bool isPeakSeason = date.month >= 6 && date.month <= 8 || date.month == 12;

    double multiplier = 1.0;
    
    // Demand-based pricing
    if (occupancyRate > 0.8) {
      multiplier += 0.5;
    } else if (occupancyRate > 0.6) multiplier += 0.3;
    else if (occupancyRate > 0.4) multiplier += 0.1;
    
    // Weekend pricing
    if (isWeekend) multiplier += 0.2;
    
    // Holiday pricing
    if (isHoliday) multiplier += 0.4;
    
    // Seasonal pricing
    if (isPeakSeason) multiplier += 0.3;

    return basePrice * multiplier;
  }

  // Simple holiday detection (extend as needed)
  bool _isHoliday(DateTime date) {
    // Christmas period
    if (date.month == 12 && date.day >= 20) return true;
    // New Year period
    if (date.month == 1 && date.day <= 5) return true;
    // Easter period (simplified - around April)
    if (date.month == 4 && date.day >= 1 && date.day <= 10) return true;
    // Independence Day
    if (date.month == 7 && date.day == 4) return true;
    // Thanksgiving week
    if (date.month == 11 && date.day >= 20 && date.day <= 27) return true;
    
    return false;
  }

  // Get availability for a specific resort and date
  AvailabilitySlot? getAvailability(String resortId, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _resortAvailability[resortId]?[normalizedDate];
  }

  // Get all availability for a resort in a given month
  Map<DateTime, AvailabilitySlot> getMonthAvailability(String resortId, DateTime month) {
    Map<DateTime, AvailabilitySlot> monthData = {};
    final resortData = _resortAvailability[resortId];
    
    if (resortData != null) {
      for (var entry in resortData.entries) {
        if (entry.key.year == month.year && entry.key.month == month.month) {
          monthData[entry.key] = entry.value;
        }
      }
    }
    
    return monthData;
  }

  // Update selected day
  void setSelectedDay(DateTime? day) {
    _selectedDay = day;
    notifyListeners();
  }

  // Update focused day
  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  // Update calendar format
  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  // Set selected resort
  void setSelectedResort(String resortId) {
    _selectedResortId = resortId;
    notifyListeners();
  }

  // Get available dates for booking (for date range selection)
  List<DateTime> getAvailableDates(String resortId, {int daysAhead = 30}) {
    List<DateTime> availableDates = [];
    final resortData = _resortAvailability[resortId];
    
    if (resortData != null) {
      DateTime startDate = DateTime.now();
      for (int i = 0; i < daysAhead; i++) {
        DateTime checkDate = startDate.add(Duration(days: i));
        DateTime normalizedDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
        
        AvailabilitySlot? slot = resortData[normalizedDate];
        if (slot != null && slot.availability != SlotAvailability.booked) {
          availableDates.add(normalizedDate);
        }
      }
    }
    
    return availableDates;
  }

  // Book a slot (simulate booking)
  bool bookSlot(String resortId, DateTime date, int roomsNeeded) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final slot = _resortAvailability[resortId]?[normalizedDate];
    
    if (slot != null && slot.availableRooms >= roomsNeeded) {
      // Update availability
      _resortAvailability[resortId]![normalizedDate] = AvailabilitySlot(
        date: slot.date,
        availability: slot.availableRooms - roomsNeeded <= 0 
            ? SlotAvailability.booked 
            : (slot.availableRooms - roomsNeeded <= (slot.totalRooms * 0.3) 
                ? SlotAvailability.limited 
                : SlotAvailability.available),
        totalRooms: slot.totalRooms,
        availableRooms: slot.availableRooms - roomsNeeded,
        basePrice: slot.basePrice,
      );
      
      notifyListeners();
      return true;
    }
    
    return false;
  }
}