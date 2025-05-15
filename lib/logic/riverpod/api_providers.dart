import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/data/api/pet_api.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';

class BreedsState {
  final List<Map<String, dynamic>> breeds;
  final int currentPage;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  BreedsState({
    this.breeds = const [],
    this.currentPage = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  BreedsState copyWith({
    List<Map<String, dynamic>>? breeds,
    int? currentPage,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return BreedsState(
      breeds: breeds ?? this.breeds,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class BreedsNotifier extends StateNotifier<BreedsState> {
  final PetApi api;
  final int limit = 10;

  BreedsNotifier(this.api) : super(BreedsState());

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final newBreeds = await api.getAllBreeds(
        limit: limit,
        page: state.currentPage,
      );
      state = state.copyWith(
        breeds: [...state.breeds, ...newBreeds],
        currentPage: state.currentPage + 1,
        isLoading: false,
        hasMore: newBreeds.length == limit,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final breedsProvider = StateNotifierProvider<BreedsNotifier, BreedsState>((ref) {
  final api = ref.watch(apiProvider);
  return BreedsNotifier(api);
});

final apiProvider = Provider<PetApi>((ref) {
  final petTypeIndex = ref.watch(typeProvder).index;
  return petTypeIndex == 0 ? Dog() : Cat();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredBreedsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final breeds = ref.watch(breedsProvider).breeds;
  final searchQuery = ref.watch(searchQueryProvider).trim().toLowerCase();

  if (searchQuery.isEmpty) {
    return breeds;
  }

  return breeds.where((breed) {
    final name = breed['name']?.toString().toLowerCase() ?? '';
    return name.contains(searchQuery);
  }).toList();
});