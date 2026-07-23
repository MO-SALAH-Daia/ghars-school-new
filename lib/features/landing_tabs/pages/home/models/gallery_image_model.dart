class ImagesGallery {
  final int? imageID;
  final String? imageFile;

  ImagesGallery({this.imageID, this.imageFile});

  factory ImagesGallery.fromJson(Map<String, dynamic> json) {
    return ImagesGallery(
      imageID: json['imageID'] as int?,
      imageFile: json['imageFile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageID': imageID,
      'imageFile': imageFile,
    };
  }
}
