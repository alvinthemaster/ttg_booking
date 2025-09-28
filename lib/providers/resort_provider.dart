import 'package:flutter/foundation.dart';
import '../models/resort.dart';

class ResortProvider extends ChangeNotifier {
  List<Resort> _resorts = [];
  List<Resort> _filteredResorts = [];
  SandType? _selectedSandType;
  PriceFilter? _priceFilter;
  double _minRating = 1.0;

  List<Resort> get resorts => _filteredResorts;
  List<Resort> get allResorts => _resorts;
  SandType? get selectedSandType => _selectedSandType;
  PriceFilter? get priceFilter => _priceFilter;
  double get minRating => _minRating;

  ResortProvider() {
    _initializeResorts();
  }

  void _initializeResorts() {
    _resorts = [
      Resort(
        id: '1',
        name: 'Paradise White Sands',
        description: 'Luxurious beachfront resort with pristine white sand beaches and crystal clear waters.',
        sandType: SandType.white,
        rating: 4.8,
        images: ['assets/images/resort1.jpg'],
        location: 'Boracay, Philippines',
        isTopRated: true,
        amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Beach Access'],
        roomOptions: [
          RoomOption(
            id: '1-1',
            name: 'Deluxe Ocean View Room',
            type: RoomType.room,
            pricePerNight: 150.0,
            maxOccupancy: 2,
            description: 'Spacious room with ocean view and modern amenities',
            amenities: ['AC', 'TV', 'Minibar', 'Ocean View'],
            images: ['assets/images/room1.jpg'],
          ),
          RoomOption(
            id: '1-2',
            name: 'Beachfront Cottage',
            type: RoomType.cottage,
            pricePerNight: 280.0,
            maxOccupancy: 4,
            description: 'Private cottage steps away from the beach',
            amenities: ['AC', 'TV', 'Kitchen', 'Private Beach Access'],
            images: ['assets/images/cottage1.jpg'],
          ),
        ],
      ),
      Resort(
        id: '2',
        name: 'Volcanic Black Beach Resort',
        description: 'Unique resort featuring stunning black sand beaches formed by volcanic activity.',
        sandType: SandType.black,
        rating: 4.6,
        images: ['assets/images/resort2.jpg'],
        location: 'Santorini, Greece',
        isTopRated: true,
        amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Sunset Views'],
        roomOptions: [
          RoomOption(
            id: '2-1',
            name: 'Volcano View Suite',
            type: RoomType.room,
            pricePerNight: 200.0,
            maxOccupancy: 2,
            description: 'Elegant suite with volcano and sea views',
            amenities: ['AC', 'TV', 'Balcony', 'Volcano View'],
            images: ['assets/images/room2.jpg'],
          ),
          RoomOption(
            id: '2-2',
            name: 'Cliffside Villa',
            type: RoomType.cottage,
            pricePerNight: 450.0,
            maxOccupancy: 6,
            description: 'Luxury villa perched on volcanic cliffs',
            amenities: ['AC', 'TV', 'Kitchen', 'Private Pool', 'Butler Service'],
            images: ['assets/images/villa1.jpg'],
          ),
        ],
      ),
      Resort(
        id: '3',
        name: 'Crystal White Haven',
        description: 'Peaceful retreat with powdery white sand and turquoise waters.',
        sandType: SandType.white,
        rating: 4.7,
        images: ['assets/images/resort3.jpg'],
        location: 'Maldives',
        isTopRated: true,
        amenities: ['WiFi', 'Overwater Spa', 'Restaurant', 'Water Sports'],
        roomOptions: [
          RoomOption(
            id: '3-1',
            name: 'Beach Villa',
            type: RoomType.room,
            pricePerNight: 320.0,
            maxOccupancy: 2,
            description: 'Overwater villa with direct lagoon access',
            amenities: ['AC', 'TV', 'Private Deck', 'Lagoon Access'],
            images: ['assets/images/villa2.jpg'],
          ),
        ],
      ),
      Resort(
        id: '4',
        name: 'Obsidian Shores Resort',
        description: 'Modern resort on dramatic black volcanic beaches.',
        sandType: SandType.black,
        rating: 4.5,
        images: ['assets/images/resort4.jpg'],
        location: 'Iceland',
        isTopRated: true,
        amenities: ['WiFi', 'Geothermal Spa', 'Restaurant', 'Northern Lights View'],
        roomOptions: [
          RoomOption(
            id: '4-1',
            name: 'Glacier View Room',
            type: RoomType.room,
            pricePerNight: 180.0,
            maxOccupancy: 2,
            description: 'Cozy room with glacier and ocean views',
            amenities: ['Heating', 'TV', 'Glacier View'],
            images: ['assets/images/room3.jpg'],
          ),
          RoomOption(
            id: '4-2',
            name: 'Aurora Cottage',
            type: RoomType.cottage,
            pricePerNight: 350.0,
            maxOccupancy: 4,
            description: 'Perfect for Northern Lights viewing',
            amenities: ['Heating', 'TV', 'Fireplace', 'Glass Roof'],
            images: ['assets/images/cottage2.jpg'],
          ),
        ],
      ),
      Resort(
        id: '5',
        name: 'Tropical White Paradise',
        description: 'Family-friendly resort with endless white sand beaches.',
        sandType: SandType.white,
        rating: 4.4,
        images: ['assets/images/resort5.jpg'],
        location: 'Cancun, Mexico',
        isTopRated: true,
        amenities: ['WiFi', 'Kids Club', 'Multiple Pools', 'All-Inclusive'],
        roomOptions: [
          RoomOption(
            id: '5-1',
            name: 'Family Suite',
            type: RoomType.room,
            pricePerNight: 250.0,
            maxOccupancy: 4,
            description: 'Spacious suite perfect for families',
            amenities: ['AC', 'TV', 'Connecting Rooms', 'Pool View'],
            images: ['assets/images/room4.jpg'],
          ),
        ],
      ),
      Resort(
        id: '6',
        name: 'Serene Sands Resort',
        description: 'Boutique resort with pristine white beaches and personalized service.',
        sandType: SandType.white,
        rating: 4.3,
        images: ['assets/images/resort6.jpg'],
        location: 'Seychelles',
        amenities: ['WiFi', 'Spa', 'Restaurant', 'Snorkeling'],
        roomOptions: [
          RoomOption(
            id: '6-1',
            name: 'Garden View Room',
            type: RoomType.room,
            pricePerNight: 120.0,
            maxOccupancy: 2,
            description: 'Comfortable room surrounded by tropical gardens',
            amenities: ['AC', 'TV', 'Garden View'],
            images: ['assets/images/room5.jpg'],
          ),
        ],
      ),
    ];
    _applyFilters();
  }

  List<Resort> get topRatedResorts {
    var topResorts = _resorts.where((resort) => resort.isTopRated).toList();
    topResorts.sort((a, b) => b.rating.compareTo(a.rating));
    return topResorts.take(5).toList();
  }

  void setSandTypeFilter(SandType? sandType) {
    _selectedSandType = sandType;
    _applyFilters();
    notifyListeners();
  }

  void setPriceFilter(double minPrice, double maxPrice) {
    _priceFilter = PriceFilter(minPrice: minPrice, maxPrice: maxPrice);
    _applyFilters();
    notifyListeners();
  }

  void setMinRatingFilter(double rating) {
    _minRating = rating;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedSandType = null;
    _priceFilter = null;
    _minRating = 1.0;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredResorts = _resorts.where((resort) {
      bool matchesSandType = _selectedSandType == null || resort.sandType == _selectedSandType;
      bool matchesRating = resort.rating >= _minRating;
      bool matchesPrice = _priceFilter == null || 
          (resort.minPrice <= _priceFilter!.maxPrice && resort.maxPrice >= _priceFilter!.minPrice);
      
      return matchesSandType && matchesRating && matchesPrice;
    }).toList();
  }

  Resort? getResortById(String id) {
    try {
      return _resorts.firstWhere((resort) => resort.id == id);
    } catch (e) {
      return null;
    }
  }
}