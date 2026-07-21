import 'dart:developer';

// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  bool isVideo = false;

  final ImagePicker picker = ImagePicker();

  XFile? _selectedImage;

  bool get hasSelectedImage => _selectedImage != null;
  XFile? pickedXFile;

  XFile get selectedImage => _selectedImage!;

  removeSelectedImage() {
    _selectedImage = null;
  }

  Future<XFile?> getImage({required bool? fromGallery}) async {
    pickedXFile = await picker.pickImage(
        source: fromGallery! ? ImageSource.gallery : ImageSource.camera);
    if (pickedXFile != null) {
      _selectedImage = XFile(pickedXFile!.path);
    }
    log('xXx Original Image: $_selectedImage');
    return _selectedImage;
  }

  getVideo({required bool? fromGallery}) async {
    pickedXFile = await picker.pickVideo(
        source: fromGallery! ? ImageSource.gallery : ImageSource.camera);
    if (pickedXFile != null) {
      _selectedImage = XFile(pickedXFile!.path);
    }
    log('xXx Original Image: $_selectedImage');
    return _selectedImage;
  }

//******************************************************************************
  /// File picker
  XFile? _selectedFile;

  bool get hasSelectedFile => _selectedFile != null;

  XFile get selectedFile => _selectedFile!;

  removeSelectedFile() {
    _selectedFile = null;
  }
  //
  // Future<XFile?> getSingleFile() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: false);
  //   if (result != null) {
  //     _selectedFile = XFile(result.files.single.path!);
  //   }
  //   return _selectedFile;
  // }
}
