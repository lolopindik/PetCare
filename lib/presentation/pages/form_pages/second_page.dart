import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/api_providers.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SecondPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final breedsState = ref.watch(breedsProvider);
    final breedsNotifier = ref.read(breedsProvider.notifier);
    final filteredBreeds = ref.watch(filteredBreedsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final ScrollController scrollController = ScrollController();
    final TextEditingController searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      ),
    );

    Timer? debounceTimer;

    if (breedsState.breeds.isEmpty && !breedsState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        breedsNotifier.loadNextPage();
      });
    }

    bool isLoadingMore = false;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.9 &&
          !isLoadingMore &&
          !breedsState.isLoading &&
          breedsState.hasMore &&
          breedsState.error == null) {
        isLoadingMore = true;
        await breedsNotifier.loadNextPage();
        isLoadingMore = false;
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 24),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                            onPressed: () {
                              searchController.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                    hintText: 'Search for breeds...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    debounceTimer?.cancel();
                    debounceTimer = Timer(const Duration(milliseconds: 300), () {
                      ref.read(searchQueryProvider.notifier).state = value;
                    });
                  },
                  onSubmitted: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Skeletonizer(
                enabled: breedsState.isLoading && breedsState.breeds.isEmpty,
                effect: ShimmerEffect(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                ),
                child: breedsState.error != null
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Error: ${breedsState.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(12),
                              ElevatedButton(
                                onPressed: () => breedsNotifier.loadNextPage(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredBreeds.isEmpty && !breedsState.isLoading
                        ? Center(
                            child: Text(
                              'No breeds found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : GridView.builder(
                            controller: scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount:
                                filteredBreeds.length + (breedsState.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredBreeds.length &&
                                  breedsState.isLoading) {
                                return Skeletonizer(
                                  enabled: true,
                                  effect: ShimmerEffect(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                  ),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.pets,
                                                size: 50,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Placeholder for breed name
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  LightModeColors.primaryColor,
                                                  LightModeColors.gradientTeal,
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              'Placeholder Breed',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final breed = filteredBreeds[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(16),
                                    //   child: breed['image'] != null
                                    //       ? Image.network(
                                    //           breed['image'],
                                    //           fit: BoxFit.cover,
                                    //           height: double.infinity,
                                    //           width: double.infinity,
                                    //           errorBuilder: (context, error, stackTrace) =>
                                    //               Container(
                                    //             color: Colors.grey[200],
                                    //             child: Icon.plus
                                    //               Icons.pets,
                                    //               size: 50,
                                    //               color: Colors.grey[400],
                                    //             ),
                                    //         )
                                    //       : Container(
                                    //           color: Colors.grey[200],
                                    //           child: Icon(
                                    //             Icons.pets,
                                    //             size: 50,
                                    //             color: Colors.grey[400],
                                    //           ),
                                    //         ),
                                    // ),
                                    //todo lated add real images from api
                                    Center(child: Text('No image yet :(')),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              LightModeColors.primaryColor,
                                              LightModeColors.gradientTeal,
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          breed['name'] ?? 'N/A',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
            if (!breedsState.hasMore &&
                searchQuery.isEmpty &&
                breedsState.error == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No more breeds to load',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (breedsState.breeds.isNotEmpty && breedsState.error == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  //todo add logic later
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightModeColors.gradientTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}