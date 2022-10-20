import 'package:file_picker/file_picker.dart';

class MediaService {
  MediaService() {}

  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? _result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (_result != null) {
      return _result.files[0];
    }
    return null;
  }

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) {
  //       return;
  //     } else {
  //       final File imageTemporary = File(image.path);
  //       return imageTemporary;
  //     }
  //   } on PlatformException catch (e) {
  //     print("Failed to pick image: $e");
  //   }
  // }
}
