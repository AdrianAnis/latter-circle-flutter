import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  void _showDeleteNotif(String title) {
    Get.snackbar(
      "Removed",
      "$title removed from watchlist",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey.shade900.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(14),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
      shouldIconPulse: false,
      barBlur: 8,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('watchlist');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Watchlist"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
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
                      child: const Icon(Icons.bookmark_border, size: 34),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Watchlist masih kosong",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Tambah film dari Home, nanti muncul di sini.",
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final entries = box.keys.map((k) {
            final movie = box.get(k);
            return MapEntry(k, movie);
          }).toList();
          entries.sort((a, b) => b.key.toString().compareTo(a.key.toString()));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final key = entries[index].key;
              final movie = entries[index].value;

              final String title = (movie?['title'] ?? 'Untitled').toString();
              final String? posterPath = movie?['posterPath']?.toString();

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
                        child: imageUrl == null
                            ? Container(
                                width: 60,
                                height: 80,
                                color: Colors.black.withOpacity(0.06),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported),
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
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
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
