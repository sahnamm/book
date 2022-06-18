import 'package:book/controllers/book_controller.dart';
import 'package:book/utils/contants.dart';
import 'package:book/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;
  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(bookListTitle)),
      body: Consumer<BookController>(
        child: const Center(child: CircularProgressIndicator()),
        builder: (context, value, child) {
          return Container(
            child: bookController!.bookList == null
                ? child
                : ListView.separated(
                    itemCount: bookController!.bookList!.books!.length,
                    itemBuilder: (context, index) {
                      final currentBook =
                          bookController!.bookList!.books![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailBookPage(
                              isbn: currentBook.isbn13!,
                              title: currentBook.title!,
                            ),
                          ));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Image.network(
                                currentBook.image!,
                                height: 200,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20.0,
                                  ),
                                  child: Container(
                                    height: 200,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentBook.title!,
                                          style: titleTextStyle,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          currentBook.subtitle!,
                                          style: subtitleTextStyle,
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            currentBook.price!,
                                            style: priceTextTyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
          );
        },
      ),
    );
  }
}
