import 'dart:convert';

List<HomeMenuModel> homeMenuModelFromJson(String str) => List<HomeMenuModel>.from(json.decode(str).map((x) => HomeMenuModel.fromJson(x)));
String homeMenuModelToJson(List<HomeMenuModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeMenuModel {
  final String id;
  final String parentId;
  final String name;
  final String url;
  final String icon;
  final int orderPosition;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final List<HomeMenuModel> children;

  const HomeMenuModel({
    this.id = '',
    this.parentId = '',
    this.name = '',
    this.url = '',
    this.icon = '',
    this.orderPosition = 0,
    this.canView = false,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.children = const [],
  });

  factory HomeMenuModel.fromJson(Map<String, dynamic> json) => HomeMenuModel(
    id: json["id"],
    parentId: json["parentId"] ?? '',
    name: json["name"],
    url: json["url"],
    icon: json["icon"] ?? '',
    orderPosition: json["orderPosition"],
    canView: json["canView"],
    canCreate: json["canCreate"],
    canEdit: json["canEdit"],
    canDelete: json["canDelete"],
    children: List<HomeMenuModel>.from(json["children"].map((x) => HomeMenuModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parentId": parentId,
    "name": name,
    "url": url,
    "icon": icon,
    "orderPosition": orderPosition,
    "canView": canView,
    "canCreate": canCreate,
    "canEdit": canEdit,
    "canDelete": canDelete,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}
