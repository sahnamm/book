import 'dart:math';

import 'package:book/controllers/book_controller.dart';
import 'package:book/utils/contants.dart';
import 'package:book/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
    required this.title,
  }) : super(key: key);

  final String isbn;
  final String title;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;
  String? imageTag;

  @override
  void initState() {
    super.initState();

    // controller = Get.put(Provider.of<BookController>(context, listen: false));
    controller = Provider.of<BookController>(context, listen: false);
    controller!.refresh();
    controller!.fetchDetailBookApi(widget.isbn);
    imageTag = "imageZoom${Random().nextInt(100)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Consumer<BookController>(
        child: const Center(child: CircularProgressIndicator()),
        builder: (context, controller, child) {
          return controller.bookDetail == null
              ? child!
              : SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        bottom: 10,
                        top: 15,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewScreen(
                                        tag: imageTag!,
                                        imageUrl: controller.bookDetail!.image!,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: imageTag!,
                                  child: Image.network(
                                    controller.bookDetail!.image!,
                                    height: 150,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.bookDetail!.title!,
                                        style: titleTextStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.bookDetail!.authors!,
                                        style: authorTextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            Icons.star,
                                            color: index <
                                                    int.parse(controller
                                                        .bookDetail!.rating!)
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.bookDetail!.subtitle!,
                                        style: subtitleTextStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.bookDetail!.price!,
                                        style: priceTextTyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: customBlue,
                              ),
                              onPressed: () async {
                                Uri uri =
                                    Uri.parse(controller.bookDetail!.url!);
                                try {
                                  await canLaunchUrl(uri)
                                      ? await launchUrl(uri)
                                      : debugPrint("Failed to navigate!");
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              child: const Text(buyButton),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.bookDetail!.desc!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text("Read More", style: moresTextTyle),
                          const SizedBox(height: 10),
                          const Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Year: ${controller.bookDetail!.year!}"),
                              Text("ISBN ${controller.bookDetail!.isbn13!}"),
                              Text("${controller.bookDetail!.pages!} Pages"),
                              Text(
                                  "Publisher: ${controller.bookDetail!.publisher!}"),
                              Text(
                                  "Language: ${controller.bookDetail!.language!}"),
                            ],
                          ),
                          const Divider(),
                          controller.similarBooks == null
                              ? child!
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Similar",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text("More", style: moresTextTyle),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller
                                            .similarBooks!.books!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final current = controller
                                              .similarBooks!.books![index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return DetailBookPage(
                                                      isbn: current.isbn13!,
                                                      title: current.title!,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    current.image!,
                                                    height: 100,
                                                  ),
                                                  Text(
                                                    current.title!,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
