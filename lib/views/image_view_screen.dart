import 'package:book/utils/contants.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({
    Key? key,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);
  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Stack(
          children: [
            Hero(
              tag: tag,
              child: Center(
                child: Image.network(imageUrl),
              ),
            ),
            // const BackButton(),
            Positioned(
              right: 20,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const CircleAvatar(
                  backgroundColor: customBlue,
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
