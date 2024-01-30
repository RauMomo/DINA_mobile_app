class PeersResponse {
  String type;
  List<Datum> data;

  PeersResponse({
    required this.type,
    required this.data,
  });

  factory PeersResponse.fromJson(Map<String, dynamic> json) => PeersResponse(
        type: json["type"] ?? '',
        data: (json["data"] as List<dynamic>).length > 0
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String station;
  String role;
  String name;
  bool busy;
  String userAgent;

  Datum({
    required this.id,
    required this.station,
    required this.role,
    required this.name,
    required this.busy,
    required this.userAgent,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        station: json["station"],
        role: json["role"],
        name: json["name"],
        busy: json["busy"],
        userAgent: json["user_agent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "station": station,
        "role": role,
        "name": name,
        "busy": busy,
        "user_agent": userAgent,
      };
}
