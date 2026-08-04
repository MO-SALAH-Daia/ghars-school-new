class INVGroupStageModel {
  INVGroupStageModel({
    this.itemGroupId,
    this.itemGroupCode,
    this.arabicName,
    this.englishName,
    this.number,
    this.parentId,
    this.groupType,
  });

  int? itemGroupId;
  String? itemGroupCode;
  String? arabicName;
  String? englishName;
  int? number;
  int? parentId;
  int? groupType;

  factory INVGroupStageModel.fromJson(Map<String, dynamic> json) => INVGroupStageModel(
        itemGroupId: json["itemGroupId"] as int?,
        itemGroupCode: json["itemGroupCode"] as String?,
        arabicName: json["arabicName"] as String?,
        englishName: json["englishName"] as String?,
        number: json["number"] as int?,
        parentId: json["parentId"] as int?,
        groupType: json["group_type"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "itemGroupId": itemGroupId,
        "itemGroupCode": itemGroupCode,
        "arabicName": arabicName,
        "englishName": englishName,
        "number": number,
        "parentId": parentId,
        "group_type": groupType,
      };
}
