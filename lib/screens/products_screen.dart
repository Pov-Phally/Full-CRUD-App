import 'package:flutter/material.dart';
import 'package:full_crud_app/utils/export_services.dart';
import 'package:full_crud_app/widgits/product_tile.dart';
import 'package:full_crud_app/widgits/search_and_filter.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedSortOption = 'Price Ascending';

  late ProductProvider productProvider;

  @override
  void initState() {
    super.initState();
    productProvider = context.read<ProductProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.fetchProducts();
      productProvider.loadMore();
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        productProvider.hasMore &&
        !productProvider.isLoading) {
      productProvider.loadMore();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _sortProducts(String option) {
    switch (option) {
      case 'Price Ascending':
        productProvider.sortProductsByPriceAscending();
        break;
      case 'Price Descending':
        productProvider.sortProductsByPriceDescending();
        break;
      case 'Stock Ascending':
        productProvider.sortProductsByStockAscending();
        break;
      case 'Stock Descending':
        productProvider.sortProductsByStockDescending();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => exportToPDF(prov.filteredItems),
            tooltip: 'Export to PDF',
          ),
          IconButton(
            icon: const Icon(Icons.table_view),
            onPressed: () => exportToCSV(prov.filteredItems),
            tooltip: 'Export to CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          SearchAndFilterBar(
            searchController: searchController,
            selectedSortOption: _selectedSortOption,
            onSortOptionSelected: (option) {
              setState(() {
                _selectedSortOption = option;
                _sortProducts(option);
              });
            },
            onChanged: (value) {
              context.read<ProductProvider>().filterProductsByName(value!);
            },
          ),
          prov.isLoading && prov.filteredItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await prov.fetchProducts();
                    await prov.loadMore();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: prov.filteredItems.length,
                    itemBuilder: (_, i) {
                      if (i == prov.filteredItems.length + 1) {
                        if (prov.hasMore) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!prov.hasMore) {
                          return const Center(child: Text('No more products'));
                        }
                      }
                      return ProductTile(product: prov.filteredItems[i]);
                    },
                  ),
                ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add'),
      ),
    );
  }
}