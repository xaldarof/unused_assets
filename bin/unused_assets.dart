import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption("path");
  var parsed = parser.parse(args);

  final root = Directory(
      "${Directory.current.path}${Platform.pathSeparator}${parsed['path']}");

  final dartFiles = _findFiles(root);
  if (dartFiles.isNotEmpty) {
    for (var file in dartFiles) {
      _visit(file);
    }
  } else {
    print("Nothing found !");
  }
}

_visit(File file) {
  var line = 0;
  file.readAsLinesSync().forEach((element) {
    line++;
    if (element.contains(".png")) {
      print("Found in line [$line]: $element");
    }
  });
}

List<File> _findFiles(Directory dir) {
  final result = <File>[];
  dir.listSync().forEach((entity) {
    if (entity is File) {
      print(entity.path);
      result.add(entity);
    } else if (entity is Directory) {
      _findFiles(entity);
    }
  });
  return result;
}
