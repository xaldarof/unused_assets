import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption("sourcePath");
  parser.addOption("assetsPath");
  var parsed = parser.parse(args);

  final sourcePath = Directory(
      "${Directory.current.path}${Platform.pathSeparator}${parsed['sourcePath']}");
  final assetsPath = Directory(
      "${Directory.current.path}${Platform.pathSeparator}${parsed['assetsPath']}");

  final assetsFiles = _findFiles(assetsPath);
  final assetFileNames = _listAssets(assetsFiles);

  final sourceFiles = _findFiles(sourcePath);
  if (sourceFiles.isNotEmpty) {
    _travel(sourceFiles, assetFileNames);
  } else {
    print("Nothing found !");
  }
}

List<String> _listAssets(List<File> files) {
  return files.map((e) => e.path.split(Platform.pathSeparator).last).toList();
}

_travel(List<File> files, List<String> assets) {
  for (var file in files) {
    _visitFile(file, assets);
  }
}

_visitFile(File file, List<String> assets) {
  var line = 0;
  final name = file.path.split(Platform.pathSeparator).last;
  for (var asset in assets) {
    file.readAsLinesSync().forEach((element) {
      line++;
      if (element.contains(asset)) {
        print("FILE [$name]     LINE [$line]     PREVIEW [${element.trim()}]");
      }
    });
  }
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
