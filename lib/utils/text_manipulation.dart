import 'dart:io';

import 'package:otzaria/models/books.dart';

String stripHtmlIfNeeded(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
}

String removeVolwels(String s) {
  s = s.replaceAll('־', ' ');
  return s.replaceAll(RegExp(r'[\u0591-\u05C7]'), '');
}

String highLight(String data, String searchQuery) {
  if (searchQuery.isNotEmpty) {
    return data.replaceAll(searchQuery, '<font color=red>$searchQuery</font>');
  }
  return data;
}

String getTitleFromPath(String path) {
  return path.split(Platform.pathSeparator).last.split('.').first;
}

Future<String> refFromIndex(
    int index, Future<List<TocEntry>> tableOfContents) async {
  List<TocEntry> toc = await tableOfContents;
  List<String> texts = [];

  void searchToc(List<TocEntry> entries, int index) {
    for (final TocEntry entry in entries) {
      if (entry.index > index) {
        return;
      }
      if (entry.level > texts.length) {
        texts.add(entry.text);
      } else {
        texts[entry.level - 1] = entry.text;
      }

      searchToc(entry.children, index);
    }
  }

  searchToc(toc, index);

  return texts.join(',');
}
