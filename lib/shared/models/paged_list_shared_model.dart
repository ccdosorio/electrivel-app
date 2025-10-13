// External dependencies
import 'package:equatable/equatable.dart';

abstract class PageListSharedModel<T extends Object> extends Equatable {
  final List<T> items;
  final int totalPages;
  final int currentPage;

  const PageListSharedModel({this.items = const [], this.totalPages = 0, this.currentPage = 0});

  bool get isLastPage {
    return currentPage == totalPages;
  }
}