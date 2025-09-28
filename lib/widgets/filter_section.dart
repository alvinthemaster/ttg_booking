import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resort.dart';
import '../providers/resort_provider.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResortProvider>(
      builder: (context, resortProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Sand Type Filter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sand Type:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: resortProvider.selectedSandType == null,
                        onSelected: (selected) {
                          if (selected) {
                            resortProvider.setSandTypeFilter(null);
                          }
                        },
                        selectedColor: const Color(0xFF2E7D94),
                        labelStyle: TextStyle(
                          color: resortProvider.selectedSandType == null ? Colors.white : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('White Sand'),
                        selected: resortProvider.selectedSandType == SandType.white,
                        onSelected: (selected) {
                          resortProvider.setSandTypeFilter(selected ? SandType.white : null);
                        },
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: resortProvider.selectedSandType == SandType.white ? Colors.white : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Black Sand'),
                        selected: resortProvider.selectedSandType == SandType.black,
                        onSelected: (selected) {
                          resortProvider.setSandTypeFilter(selected ? SandType.black : null);
                        },
                        selectedColor: Colors.grey[800],
                        labelStyle: TextStyle(
                          color: resortProvider.selectedSandType == SandType.black ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Rating Filter
              Row(
                children: [
                  const Text(
                    'Minimum Rating: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${resortProvider.minRating.toStringAsFixed(1)} ⭐',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E7D94),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: resortProvider.minRating,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                activeColor: const Color(0xFF2E7D94),
                onChanged: (value) {
                  resortProvider.setMinRatingFilter(value);
                },
              ),
              const SizedBox(height: 10),
              
              // Price Range Filter
              if (resortProvider.priceFilter != null) ...[
                Row(
                  children: [
                    const Text(
                      'Price Range: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${resortProvider.priceFilter!.minPrice.toStringAsFixed(0)} - \$${resortProvider.priceFilter!.maxPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E7D94),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              
              // Filter Actions
              Wrap(
                spacing: 12,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showPriceRangeDialog(context, resortProvider),
                    icon: const Icon(Icons.tune),
                    label: const Text('Price Range'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D94),
                      side: const BorderSide(color: Color(0xFF2E7D94)),
                    ),
                  ),
                  if (resortProvider.selectedSandType != null ||
                      resortProvider.priceFilter != null ||
                      resortProvider.minRating > 1.0)
                    TextButton.icon(
                      onPressed: () => resortProvider.clearFilters(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPriceRangeDialog(BuildContext context, ResortProvider resortProvider) {
    double minPrice = resortProvider.priceFilter?.minPrice ?? 0;
    double maxPrice = resortProvider.priceFilter?.maxPrice ?? 500;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Price Range'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Price range: \$${minPrice.toStringAsFixed(0)} - \$${maxPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Minimum Price:'),
                  Slider(
                    value: minPrice,
                    min: 0,
                    max: 400,
                    divisions: 20,
                    activeColor: const Color(0xFF2E7D94),
                    onChanged: (value) {
                      setState(() {
                        minPrice = value;
                        if (minPrice >= maxPrice) {
                          maxPrice = minPrice + 50;
                        }
                      });
                    },
                  ),
                  const Text('Maximum Price:'),
                  Slider(
                    value: maxPrice,
                    min: 50,
                    max: 500,
                    divisions: 18,
                    activeColor: const Color(0xFF2E7D94),
                    onChanged: (value) {
                      setState(() {
                        maxPrice = value;
                        if (maxPrice <= minPrice) {
                          minPrice = maxPrice - 50;
                        }
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    resortProvider.setPriceFilter(minPrice, maxPrice);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}