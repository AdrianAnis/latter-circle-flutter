import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbr/core/app_colors.dart';
import '../../controllers/home_controller.dart';

class GenreChip extends GetView<HomeController> {
  final String label;

  const GenreChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedGenre.value == label;

      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () {
            controller.selectedGenre.value = label;

            if (label == "Semua") {
              controller.fetchMovies(genreId: null);
            } else {
              final genreId = controller.genreMap[label];
              controller.fetchMovies(genreId: genreId);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    });
  }
}
