import 'package:file_picker/file_picker.dart';

Future<String> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, allowMultiple: false, allowCompression: true);

  if (result != null) {
    //if user picked something
    final file = result.files.single.path;
    return file!;
  } else {
    //if user didnt pick something
    return '';
  }
}
