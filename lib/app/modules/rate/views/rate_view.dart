import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imbr/core/app_colors.dart';

import 'widgets/edit_rating_sheet.dart';

class RateView extends StatefulWidget {
  const RateView({super.key});

  @override
  State<RateView> createState() => _RateViewState();
}

class _RateViewState extends State<RateView> {
  void _showDeleteNotif(String title) {
    Get.snackbar(
      "Removed",
      "$title removed from ratings",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey.shade900.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(14),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.star_border, color: Colors.white, size: 20),
      shouldIconPulse: false,
      barBlur: 8,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('rated');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Rate Film Elitis"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) return const _EmptyState();

          final entries = box.keys.map((k) {
            final movie = box.get(k);
            return MapEntry(k, movie);
          }).toList();
          entries.sort((a, b) {
            final aData = a.value is Map ? a.value : {};
            final bData = b.value is Map ? b.value : {};
            final aTime = DateTime.tryParse(
              (aData['updatedAt'] ?? '').toString(),
            );
            final bTime = DateTime.tryParse(
              (bData['updatedAt'] ?? '').toString(),
            );
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final key = entries[index].key;
              final movie = entries[index].value;

              final int id = (movie?['id'] is num)
                  ? (movie?['id'] as num).toInt()
                  : -1;
              final String title = (movie?['title'] ?? 'Untitled').toString();
              final String? posterPath = movie?['posterPath']?.toString();
              final double rating = (movie?['rating'] is num)
                  ? (movie?['rating'] as num).toDouble()
                  : 0.0;

              final String? imageUrl =
                  (posterPath == null || posterPath.isEmpty)
                  ? null
                  : "https://image.tmdb.org/t/p/w500$posterPath";

              return Dismissible(
                key: ValueKey(key),
                direction: DismissDirection.endToStart,
                resizeDuration: const Duration(milliseconds: 200),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  box.delete(key);
                  _showDeleteNotif(title);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            imageUrl == null
                                ? Container(
                                    width: 60,
                                    height: 80,
                                    color: Colors.black.withOpacity(0.06),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  )
                                : Image.network(
                                    imageUrl,
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 80,
                                      color: Colors.black.withOpacity(0.06),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Rating: ${rating.toStringAsFixed(1)}/5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          Get.bottomSheet(
                            EditRatingSheet(
                              id: id,
                              title: title,
                              posterPath: posterPath ?? '',
                              currentRating: rating.toInt(),
                            ),
                            isScrollControlled: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_border, size: 34),
            ),
            const SizedBox(height: 14),
            const Text(
              "Belum ada film yang dirating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "Kasih rating di Home, nanti muncul di sini.",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
