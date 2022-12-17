class ViewPoint {
  String? pntname;
  String? pntlong;
  String? pntlat;
  ViewPoint({this.pntlat, this.pntlong, this.pntname});
  factory ViewPoint.fromjson(Map<String, dynamic> responce) {
    return ViewPoint(
        pntname: responce['pntname'],
        pntlat: responce['pntlan'],
        pntlong: responce['pntlong']);
  }
}
