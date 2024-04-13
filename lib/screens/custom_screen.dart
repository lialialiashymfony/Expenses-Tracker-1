import 'package:flutter/material.dart';
import 'package:my_app/components/asset_image_rounded.dart';
import 'package:my_app/components/asset_image_widget.dart';
import 'package:my_app/components/text_container.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 211, 221),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AssetImageWidget(
                imagePath: 'assets/images/sagara.jpg',
                width: 180,
                height: 180,
              ),
              AssetImageWidget(
                imagePath: 'assets/images/sagara.jpg',
                width: 180,
                height: 180,
              )
            ],
          ),
          const SizedBox(
            height: 10,
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AssetImageWidget(
                imagePath: 'assets/images/sagara.jpg',
                width: 180,
                height: 180,
              ),
              AssetImageWidget(
                imagePath: 'assets/images/sagara.jpg',
                width: 180,
                height: 180,
              )
            ],
          )
        ],
      ),
    );
  }
}
