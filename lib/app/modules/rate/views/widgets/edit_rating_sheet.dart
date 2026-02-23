import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditRatingSheet extends StatefulWidget {
  final int id;
  final String title;
  final String posterPath;
  final int currentRating;

  const EditRatingSheet({
    super.key,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.currentRating,
  });

  @override
  State<EditRatingSheet> createState() => _EditRatingSheetState();
}

class _EditRatingSheetState extends State<EditRatingSheet> {
  late int selectedRating;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.currentRating;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('rated');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => selectedRating = index + 1),
                child: Icon(
                  Icons.star,
                  size: 36,
                  color: index < selectedRating
                      ? Colors.amber
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            selectedRating == 0 ? "Tap to rate" : "$selectedRating / 5",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Batal"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedRating == 0
                      ? null
                      : () {
                          box.put(widget.id, {
                            'id': widget.id,
                            'title': widget.title,
                            'posterPath': widget.posterPath,
                            'rating': selectedRating.toDouble(),
                            'updatedAt': DateTime.now().toIso8601String(),
                          });
                          Get.back();
                        },
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
