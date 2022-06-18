import 'dart:convert';

import 'package:book/models/book_detail_response.dart';
import 'package:book/models/book_list_response.dart';
import 'package:book/utils/api_helper.dart';
import 'package:flutter/material.dart';

class BookController extends ChangeNotifier {
  BookListResponse? bookList;
  fetchBookApi() async {
    var url = "https://api.itbook.store/1.0/new";
    var response = await APIHelper.sharedInstance.doGet(url: url);
    if (response?.statusCode == 200) {
      final jsonBookList = jsonDecode(response!.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      notifyListeners();
    }
  }

  BookDetailResponse? bookDetail;
  fetchDetailBookApi(String isbn) async {
    var url = "https://api.itbook.store/1.0/books/$isbn";
    var response = await APIHelper.sharedInstance.doGet(url: url);
    if (response?.statusCode == 200) {
      final jsonDetail = jsonDecode(response!.body);
      bookDetail = BookDetailResponse.fromJson(jsonDetail);
      notifyListeners();
      fetchSimilarBookApi(bookDetail!.title!);
    }
  }

  BookListResponse? similarBooks;
  fetchSimilarBookApi(String title) async {
    var url = "https://api.itbook.store/1.0/search//$title";
    var response = await APIHelper.sharedInstance.doGet(url: url);
    if (response?.statusCode == 200) {
      final jsonDetail = jsonDecode(response!.body);
      similarBooks = BookListResponse.fromJson(jsonDetail);
      notifyListeners();
    }
  }

  refresh() {
    bookDetail = null;
    similarBooks = null;
  }
}
