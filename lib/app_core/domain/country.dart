// class Country {
//   String? code;
//   String? name;
//   String? flag;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Country &&
//           runtimeType == other.runtimeType &&
//           code == other.code &&
//           name == other.name &&
//           flag == other.flag;
//
//   @override
//   int get hashCode => Object.hash(code, name, flag);
//
//   Country({this.code, this.name, this.flag});
//
//   Country.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     name = json['name'];
//     flag = json['flag'];
//   }
// }
