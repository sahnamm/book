import 'package:book/controllers/book_controller.dart';
import 'package:book/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);

  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: Consumer<BookController>(
        // child: const Center(child: CircularProgressIndicator()),
        builder: (context, controller, child) {
          return controller.bookDetail == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                    imageUrl: controller.bookDetail!.image!,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              controller.bookDetail!.image!,
                              height: 150,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.bookDetail!.title!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controller.bookDetail!.authors!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
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
                                            ? Colors.yellow
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    controller.bookDetail!.subtitle!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    controller.bookDetail!.price!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              // fixedSize: Size(double.infinity, 50),
                              ),
                          onPressed: () async {
                            Uri uri = Uri.parse(controller.bookDetail!.url!);
                            try {
                              await canLaunchUrl(uri)
                                  ? await launchUrl(uri)
                                  : print("Failed to navigate!");
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Text(
                            "BUY",
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(controller.bookDetail!.desc!),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Year: ${controller.bookDetail!.year!}"),
                          Text("ISBN ${controller.bookDetail!.isbn13!}"),
                          Text("${controller.bookDetail!.pages!} Pages"),
                          Text(
                              "Publisher: ${controller.bookDetail!.publisher!}"),
                          Text("Language: ${controller.bookDetail!.language!}"),
                          // Text(bookDetail!.rating!),
                        ],
                      ),
                      const Divider(),
                      controller.similarBooks == null
                          ? const CircularProgressIndicator()
                          : Container(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    controller.similarBooks!.books!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final current =
                                      controller.similarBooks!.books![index];
                                  return Container(
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
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
