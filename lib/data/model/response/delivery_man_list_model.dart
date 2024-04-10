class DeliveryManListModel {
  int? id;
  String? name;
  String? image;
  int? currentOrders;
  String? lat;
  String? lng;
  String? location;
  String? distance;

  DeliveryManListModel(
      {this.id,
        this.name,
        this.image,
        this.currentOrders,
        this.lat,
        this.lng,
        this.location,
        this.distance});

  DeliveryManListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    currentOrders = json['current_orders'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['current_orders'] = currentOrders;
    data['lat'] = lat;
    data['lng'] = lng;
    data['location'] = location;
    data['distance'] = distance;
    return data;
  }
}
