/* import 'package:flutter_riverpod/flutter_riverpod.dart';


part 'search_state.freezed.dart';

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final searchProducts = ref.read(searchProductsUseCaseProvider);
  return SearchNotifier(searchProducts);
});

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchProducts _searchProducts;

  SearchNotifier(this._searchProducts) : super(const SearchState.initial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const SearchState.empty();
      return;
    }

    state = const SearchState.loading();

    final result = await _searchProducts(query);
    
    result.fold(
      (failure) => state = SearchState.error(failure.message),
      (products) => state = products.isEmpty 
          ? const SearchState.empty()
          : SearchState.loaded(products),
    );
  }
} */