import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/jwt.txt');
  }

  Future<File> writeJwt(jwt) async {
    final file = await _localFile;

    print('jwt to write : ' + jwt);
    // Write the file
    return file.writeAsString('$jwt');
  }

  Future<String> readJwt() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      print('content' + contents);
      return contents;
    } catch (e) {
      // If encountering an error, return ''
      return '';
    }
  }
}