enum SandType { white, black }

enum RoomType { room, cottage }

class Resort {
  final String id;
  final String name;
  final String description;
  final SandType sandType;
  final double rating;
  final List<String> images;
  final String location;
  final List<RoomOption> roomOptions;
  final List<String> amenities;
  final bool isTopRated;

  Resort({
    required this.id,
    required this.name,
    required this.description,
    required this.sandType,
    required this.rating,
    required this.images,
    required this.location,
    required this.roomOptions,
    required this.amenities,
    this.isTopRated = false,
  });

  double get minPrice => roomOptions.map((room) => room.pricePerNight).reduce((a, b) => a < b ? a : b);
  double get maxPrice => roomOptions.map((room) => room.pricePerNight).reduce((a, b) => a > b ? a : b);
}

class RoomOption {
  final String id;
  final String name;
  final RoomType type;
  final double pricePerNight;
  final int maxOccupancy;
  final String description;
  final List<String> amenities;
  final List<String> images;

  RoomOption({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerNight,
    required this.maxOccupancy,
    required this.description,
    required this.amenities,
    required this.images,
  });
}

class BookingRequest {
  final String resortId;
  final List<RoomBooking> roomBookings;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalGuests;
  final double totalPrice;

  BookingRequest({
    required this.resortId,
    required this.roomBookings,
    required this.checkIn,
    required this.checkOut,
    required this.totalGuests,
    required this.totalPrice,
  });

  int get totalNights => checkOut.difference(checkIn).inDays;
}

class RoomBooking {
  final String roomOptionId;
  final int quantity;
  final double pricePerNight;

  RoomBooking({
    required this.roomOptionId,
    required this.quantity,
    required this.pricePerNight,
  });

  double get totalPrice => quantity * pricePerNight;
}

class PriceFilter {
  final double minPrice;
  final double maxPrice;

  PriceFilter({
    required this.minPrice,
    required this.maxPrice,
  });
}