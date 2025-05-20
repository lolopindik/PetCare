import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/riverpod/pet_recommendations.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage {
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(petRecommendationProvider);
            ref.invalidate(foodProvider);
            ref.invalidate(vitaminsProvider);
            ref.invalidate(medicinesProvider);
            DebugLogger.print('Data refreshed via pull-to-refresh');
          },
          color: LightModeColors.gradientTeal,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: false,
                backgroundColor: LightModeColors.primaryColor,
                title: const Text(
                  'Pet Care Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Gap(16)),
              _buildSection(
                context,
                ref,
                title: 'Recommended Food',
                provider: foodProvider,
              ),
              _buildSection(
                context,
                ref,
                title: 'Vitamins',
                provider: vitaminsProvider,
              ),
              _buildSection(
                context,
                ref,
                title: 'Medicines',
                provider: medicinesProvider,
              ),
              const SliverToBoxAdapter(child: Gap(24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required ProviderBase<AsyncValue<List<Map<String, dynamic>>>> provider,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: LightModeColors.primaryColor,
                  ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ref.watch(provider).when(
                  data: (items) => _buildItemList(context, items),
                  loading: () => const Center(
                    child: CupertinoActivityIndicator(radius: 16),
                  ),
                  error: (err, stack) {
                    DebugLogger.print(
                        'Error loading $title: $err\nStack: $stack');
                    return Center(
                      child: Text(
                        'Failed to load $title: $err',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(
      BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No items available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(
          context,
          item['name'] as String? ?? 'Unknown',
          item['description'] as String? ?? 'No description',
          item['imageUrl'] as String? ?? '',
        );
      },
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    String title,
    String description,
    String imageUrl,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isImageUrlValid = imageUrl.isNotEmpty && imageUrl != '';

    return GestureDetector(
      onTap: () {
        DebugLogger.print('Tapped on $title');
      },
      child: Container(
        width: screenWidth * 0.7,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: isImageUrlValid
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 15,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          DebugLogger.print(
                              'Image load error for $title: $url - Error: $error');
                          return Container(
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Icon(
                                Icons.pets,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 100,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.pets,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
