# Beach Booking System - Complete API Documentation

## Overview

The Beach Booking System now has a complete booking flow:

1. **Properties**: Business owners can list their properties (rooms/venues) for rent
2. **Customer Browsing**: Customers can browse and search available properties
3. **Reservations**: Customers can book properties, creating reservations
4. **Real-time Dashboard**: Business owners immediately see new bookings in their dashboard

## Authentication

All API endpoints require authentication using Laravel Sanctum.

```http
Authorization: Bearer {token}
```

## API Endpoints

### Authentication

#### Login

```http
POST /api/auth/login
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "password"
}
```

#### Logout

```http
POST /api/auth/logout
Authorization: Bearer {token}
```

---

### Property Browsing (For Customers)

#### Browse Available Properties

```http
GET /api/v1/properties
Authorization: Bearer {token}

Query Parameters:
- location: Filter by location
- guests: Minimum guest capacity
- min_price: Minimum price per night
- max_price: Maximum price per night
- amenities[]: Array of required amenities
- check_in: Check-in date (YYYY-MM-DD)
- check_out: Check-out date (YYYY-MM-DD)
- search: Search in title, location, description
- sort_by: price|rating|guests|created_at
- sort_direction: asc|desc
- per_page: Results per page (default: 20)
```

#### View Property Details

```http
GET /api/v1/properties/{property_id}
Authorization: Bearer {token}
```

#### Check Property Availability

```http
POST /api/v1/properties/{property_id}/check-availability
Authorization: Bearer {token}
Content-Type: application/json

{
    "check_in_date": "2025-10-15",
    "check_out_date": "2025-10-18",
    "guests": 4
}
```

---

### Property Management (For Business Owners)

#### Get My Properties

```http
GET /api/v1/bookings
Authorization: Bearer {token}
```

#### Create New Property

```http
POST /api/v1/bookings
Authorization: Bearer {token}
Content-Type: application/json

{
    "title": "Beachfront Villa",
    "description": "Beautiful villa with ocean view",
    "location": "Boracay Island",
    "price_per_night": 5000,
    "max_guests": 6,
    "bedrooms": 3,
    "bathrooms": 2,
    "amenities": ["WiFi", "Air Conditioning", "Pool"],
    "house_rules": "No smoking, No pets",
    "available_from": "2025-10-01",
    "available_until": "2026-03-31",
    "images": [
        "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD..."
    ]
}
```

#### Update Property

```http
PUT /api/v1/bookings/{booking_id}
Authorization: Bearer {token}
Content-Type: application/json
```

#### Delete Property

```http
DELETE /api/v1/bookings/{booking_id}
Authorization: Bearer {token}
```

#### Toggle Property Availability

```http
POST /api/v1/bookings/{booking_id}/toggle-availability
Authorization: Bearer {token}
```

---

### Reservations (Customer Bookings)

#### Get My Reservations

```http
GET /api/v1/reservations
Authorization: Bearer {token}

Query Parameters:
- type: customer|business_owner (default: business_owner for business owners)
- status: pending|confirmed|checked_in|checked_out|cancelled|completed
- from_date: Filter reservations from this date
- to_date: Filter reservations until this date
- search: Search in property title/location
```

**For Customers** (to see their bookings):

```http
GET /api/v1/reservations?type=customer
Authorization: Bearer {token}
```

**For Business Owners** (to see bookings for their properties):

```http
GET /api/v1/reservations
Authorization: Bearer {token}
```

#### Make a Reservation (Customer Books Property)

```http
POST /api/v1/reservations
Authorization: Bearer {token}
Content-Type: application/json

{
    "booking_id": 1,
    "check_in_date": "2025-10-15",
    "check_out_date": "2025-10-18",
    "number_of_guests": 4,
    "special_requests": "Early check-in if possible"
}
```

#### View Reservation Details

```http
GET /api/v1/reservations/{reservation_id}
Authorization: Bearer {token}
```

#### Update Reservation Status (Business Owner)

```http
PATCH /api/v1/reservations/{reservation_id}/status
Authorization: Bearer {token}
Content-Type: application/json

{
    "status": "confirmed",
    "cancellation_reason": "Optional, required if status is cancelled"
}
```

Possible statuses:

-   `confirmed`: Business owner confirms the booking
-   `cancelled`: Business owner cancels the booking
-   `checked_in`: Customer has checked in
-   `checked_out`: Customer has checked out
-   `completed`: Booking is completed

#### Cancel Reservation (Customer)

```http
PATCH /api/v1/reservations/{reservation_id}/cancel
Authorization: Bearer {token}
Content-Type: application/json

{
    "cancellation_reason": "Change of plans"
}
```

---

### Dashboard Statistics

#### Get Business Dashboard Stats

```http
GET /api/v1/dashboard/stats
Authorization: Bearer {token}
```

Returns:

```json
{
    "success": true,
    "data": {
        "stats": {
            "total_reservations": 25,
            "pending_reservations": 3,
            "confirmed_reservations": 15,
            "active_reservations": 18,
            "today_reservations": 2,
            "total_revenue": 125000.0,
            "monthly_revenue": 45000.0
        },
        "recent_reservations": [
            {
                "id": 1,
                "customer_name": "John Doe",
                "booking_title": "Beachfront Villa",
                "check_in_date": "2025-10-15",
                "status": "confirmed",
                "final_amount": 15000.0,
                "created_at": "2025-09-28 14:30:00"
            }
        ]
    }
}
```

---

## Real-time Dashboard Updates

### How It Works

1. **Customer books a property** via mobile app:

    ```http
    POST /api/v1/reservations
    ```

2. **Reservation is created** with status "pending"

3. **Business owner's dashboard immediately shows**:

    - New reservation in "Recent Bookings"
    - Updated statistics (pending_reservations +1, today_reservations +1)
    - Real-time notification (if implemented with WebSockets/Pusher)

4. **Business owner can then**:
    - View reservation details
    - Confirm or cancel the booking
    - Update reservation status throughout the stay

### Mobile App Integration

For immediate dashboard updates in your Flutter app:

1. **Polling approach**: Call `GET /api/v1/dashboard/stats` every 30 seconds
2. **Real-time approach**: Implement WebSocket/Pusher notifications (recommended)
3. **Hybrid approach**: Combine both for reliability

### Example Flutter Implementation

```dart
// Check for new reservations every 30 seconds
Timer.periodic(Duration(seconds: 30), (timer) async {
  final stats = await ApiService.getDashboardStats();
  updateDashboard(stats);
});

// Or listen for real-time updates (if WebSockets implemented)
void listenForReservationUpdates() {
  pusher.subscribe('business-owner-${userId}')
    .bind('new-reservation', (data) {
      showNotification('New booking received!');
      refreshDashboard();
    });
}
```

---

## Response Format

All API responses follow this format:

```json
{
    "success": true,
    "message": "Operation successful",
    "data": { ... },
    "meta": { ... } // For paginated results
}
```

Error responses:

```json
{
    "success": false,
    "message": "Error description",
    "error": "Detailed error message",
    "errors": { ... } // Validation errors
}
```

---

## Database Schema Summary

### Tables

-   `users`: Business owners and customers
-   `bookings`: Property listings by business owners
-   `booking_images`: Property photos
-   `reservations`: Customer bookings of properties

### Key Relationships

-   `reservations.booking_id` → `bookings.id`
-   `reservations.customer_id` → `users.id`
-   `reservations.business_owner_id` → `users.id`

This complete system now supports the full booking workflow you described!
