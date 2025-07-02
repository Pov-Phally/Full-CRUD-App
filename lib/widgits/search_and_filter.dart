import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedSortOption;
  final ValueChanged<String> onSortOptionSelected;
  final void Function(String?) onChanged;

  const SearchAndFilterBar({super.key, required this.searchController, required this.selectedSortOption, required this.onSortOptionSelected, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
              ),
              onChanged: onChanged
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          onSelected: onSortOptionSelected,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'Price Ascending',
              child: Text('Price Ascending'),
            ),
            PopupMenuItem(
              value: 'Price Descending',
              child: Text('Price Descending'),
            ),
            PopupMenuItem(
              value: 'Stock Ascending',
              child: Text('Stock Ascending'),
            ),
            PopupMenuItem(
              value: 'Stock Descending',
              child: Text('Stock Descending'),
            ),
          ],
        ),
      ],
    );
  }
}