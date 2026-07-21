class RouteArgument {
  dynamic id;
  Map<String, dynamic>? argumentsMap;

  RouteArgument({this.id, this.argumentsMap});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsMap.toString()}}';
  }
}
