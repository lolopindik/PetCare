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

    if (breedsState.breeds.isEmpty && !breedsState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        breedsNotifier.loadNextPage();
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight * 0.06,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.search, size: 32, color: Colors.white),
                Gap(12),
              ],
            ),
          ),
          const Gap(12),
          Expanded(
            child: Skeletonizer(
              enabled: breedsState.isLoading && breedsState.breeds.isEmpty,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: breedsState.breeds.length,
                itemBuilder: (context, index) {
                  final breed = breedsState.breeds[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        breed['name'] ?? 'N/A',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (breedsState.hasMore &&
              !breedsState.isLoading &&
              breedsState.error == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await breedsNotifier.loadNextPage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Check more'),
                  ),
                  Gap(12),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightModeColors.gradientTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      // style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
