import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onStatusFilterChanged;
  final String initialSearchQuery;
  final String initialStatusFilter;

  const SearchFilterBar({
    Key? key,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    this.initialSearchQuery = '',
    this.initialStatusFilter = '',
  }) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController searchController;
  String selectedStatus = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialSearchQuery);
    selectedStatus = widget.initialStatusFilter;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              widget.onSearchChanged(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: selectedStatus.isEmpty,
                  onSelected: (selected) {
                    setState(() => selectedStatus = '');
                    widget.onStatusFilterChanged('');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('To-Do'),
                  selected: selectedStatus == 'To-Do',
                  onSelected: (selected) {
                    setState(() => selectedStatus = 'To-Do');
                    widget.onStatusFilterChanged('To-Do');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('In Progress'),
                  selected: selectedStatus == 'In Progress',
                  onSelected: (selected) {
                    setState(() => selectedStatus = 'In Progress');
                    widget.onStatusFilterChanged('In Progress');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Done'),
                  selected: selectedStatus == 'Done',
                  onSelected: (selected) {
                    setState(() => selectedStatus = 'Done');
                    widget.onStatusFilterChanged('Done');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
