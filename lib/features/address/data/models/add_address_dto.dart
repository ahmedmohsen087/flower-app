import 'package:json_annotation/json_annotation.dart';

part 'add_address_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class AddAddressDto {
  @JsonKey(name: "street")
  String? street;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "long")
  String? long;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "_id")
  String? id;

  AddAddressDto({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
    this.id,
  });

  factory AddAddressDto.fromJson(Map<String, dynamic> json) {
    return AddAddressDto(
      street: json['street'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      lat: (json['lat'] ?? json['latitude'])?.toString(),
      long: (json['long'] ?? json['lng'] ?? json['longitude'])?.toString(),
      username: json['username'] as String?,
      id: (json['_id'] ?? json['id']) as String?,
    );
  }

  Map<String, dynamic> toJson() => _$AddAddressDtoToJson(this);
}
