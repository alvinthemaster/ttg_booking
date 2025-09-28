import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';
import '../providers/resort_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resortProvider = context.read<ResortProvider>();
      final calendarProvider = context.read<CalendarProvider>();
      calendarProvider.initializeAvailability(resortProvider.allResorts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resort Calendar'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Consumer2<CalendarProvider, ResortProvider>(
        builder: (context, calendarProvider, resortProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Resort Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Resort',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: calendarProvider.selectedResortId,
                          hint: const Text('Choose a resort'),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: resortProvider.allResorts.map((resort) {
                            return DropdownMenuItem<String>(
                              value: resort.id,
                              child: Text(
                                resort.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              calendarProvider.setSelectedResort(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Calendar or Prompt
                Expanded(
                  child: calendarProvider.selectedResortId == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month, size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Select a resort above to view its availability calendar',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : _buildCalendarWidget(calendarProvider, resortProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarWidget(CalendarProvider calendarProvider, ResortProvider resortProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selected Resort Info
            if (calendarProvider.selectedResortId != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D94).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.beach_access, color: Color(0xFF2E7D94)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        resortProvider.getResortById(calendarProvider.selectedResortId!)?.name ?? 'Unknown Resort',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Availability Legend
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(Colors.green, 'Available'),
                  _buildLegendItem(Colors.orange, 'Limited'),
                  _buildLegendItem(Colors.red, 'Booked'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Calendar
            Expanded(
              child: TableCalendar<AvailabilitySlot>(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: calendarProvider.focusedDay,
                calendarFormat: CalendarFormat.month,
                eventLoader: (day) {
                  final slot = calendarProvider.getAvailability(calendarProvider.selectedResortId!, day);
                  return slot != null ? [slot] : [];
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF2E7D94),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return _buildCalendarDay(day, calendarProvider, false);
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return _buildCalendarDay(day, calendarProvider, true);
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return _buildSelectedCalendarDay(day, calendarProvider);
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF2E7D94)),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF2E7D94)),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  calendarProvider.setSelectedDay(selectedDay);
                  calendarProvider.setFocusedDay(focusedDay);
                  _showDayDetails(selectedDay, calendarProvider, resortProvider);
                },
                onPageChanged: (focusedDay) {
                  calendarProvider.setFocusedDay(focusedDay);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCalendarDay(DateTime day, CalendarProvider calendarProvider, bool isToday) {
    final slot = calendarProvider.getAvailability(calendarProvider.selectedResortId!, day);
    
    Color backgroundColor = Colors.grey[200]!;
    Color textColor = Colors.grey;
    
    if (slot != null) {
      switch (slot.availability) {
        case SlotAvailability.available:
          backgroundColor = Colors.green[100]!;
          textColor = Colors.green[800]!;
          break;
        case SlotAvailability.limited:
          backgroundColor = Colors.orange[100]!;
          textColor = Colors.orange[800]!;
          break;
        case SlotAvailability.booked:
          backgroundColor = Colors.red[100]!;
          textColor = Colors.red[800]!;
          break;
      }
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: isToday ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
            if (slot != null && slot.availability != SlotAvailability.booked)
              Text(
                '${slot.availableRooms}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCalendarDay(DateTime day, CalendarProvider calendarProvider) {
    final slot = calendarProvider.getAvailability(calendarProvider.selectedResortId!, day);
    
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D94),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (slot != null && slot.availability != SlotAvailability.booked)
              Text(
                '${slot.availableRooms}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDayDetails(DateTime day, CalendarProvider calendarProvider, ResortProvider resortProvider) {
    final slot = calendarProvider.getAvailability(calendarProvider.selectedResortId!, day);
    final resort = resortProvider.getResortById(calendarProvider.selectedResortId!);
    final formatter = DateFormat('EEEE, MMM dd, yyyy');
    
    if (slot == null || resort == null) return;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatter.format(day),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                resort.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2E7D94),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Availability Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(slot.availability),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(slot.availability),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Available Rooms: ${slot.availableRooms} of ${slot.totalRooms}',
                style: const TextStyle(fontSize: 16),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Starting from \$${slot.basePrice.toStringAsFixed(0)} per night',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D94),
                ),
              ),
              
              const SizedBox(height: 20),
              
              if (slot.availability != SlotAvailability.booked)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking ${resort.name} for ${formatter.format(day)}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Book This Date'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(SlotAvailability availability) {
    switch (availability) {
      case SlotAvailability.available:
        return Colors.green;
      case SlotAvailability.limited:
        return Colors.orange;
      case SlotAvailability.booked:
        return Colors.red;
    }
  }

  String _getStatusText(SlotAvailability availability) {
    switch (availability) {
      case SlotAvailability.available:
        return 'AVAILABLE';
      case SlotAvailability.limited:
        return 'LIMITED';
      case SlotAvailability.booked:
        return 'FULLY BOOKED';
    }
  }
}