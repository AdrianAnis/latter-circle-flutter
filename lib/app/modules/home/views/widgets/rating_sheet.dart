import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/app/modules/home/controllers/home_controller.dart';
import 'package:imbr/app/modules/home/views/home_view.dart';
import 'package:imbr/core/app_colors.dart';

class RatingSheetState extends State<RatingSheet> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
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
            widget.movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
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

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: selectedRating == 0
                  ? null
                  : () {
                      final c = Get.find<HomeController>();
                      c.setRating(widget.movie, selectedRating.toDouble());
                      Navigator.pop(context);
                    },
              child: const Text(
                "Save Rating",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
