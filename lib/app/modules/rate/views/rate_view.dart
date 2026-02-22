import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rate_controller.dart';

class RateView extends GetView<RateController> {
  const RateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Rate Page")));
  }
}
