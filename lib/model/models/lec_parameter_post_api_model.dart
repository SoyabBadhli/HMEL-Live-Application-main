class LecParameterPostApi {

  final String lec_id;
  final String application_id;
  final String earth_filling;
  final String earth_rock_cutting;
  final String LT_O_H_Line;
  final String oh_tel_line;
  final String trees;
  final String proximity_to_culvert;
  final String soil_type;
  final String availability_power;
  final String availability_water;
  final String visibility_from_Road;
  final String no_presence_divider;
  final String outside_octroi_limits;
  final String lec_parameter_id;

  const LecParameterPostApi({required this.lec_id,
    required this.application_id,
    required this.earth_filling,
    required this.earth_rock_cutting,
    required this.LT_O_H_Line,
    required this.oh_tel_line,
    required this.trees,
    required this.proximity_to_culvert,
    required this.soil_type,
    required this.availability_power,
    required this.availability_water,
    required this.visibility_from_Road,
    required this.no_presence_divider,
    required this.outside_octroi_limits,
    required this.lec_parameter_id
  });

  factory LecParameterPostApi.fromJson(Map<String, dynamic> json) {
    return LecParameterPostApi(
      lec_id: json['lec_id'] ?? '',
      application_id: json['application_id'] ?? '',
      earth_filling: json['earth_filling'] ?? '',
      earth_rock_cutting: json['earth_rock_cutting'] ?? '',
      LT_O_H_Line: json['LT_O_H_Line'] ?? '',
      oh_tel_line: json['oh_tel_line'] ?? '',
      trees: json['trees'] ?? '',
      proximity_to_culvert: json['proximity_to_culvert'] ?? '',
      soil_type: json['soil_type'] ?? '',
      availability_power: json['availability_power'] ?? '',
      availability_water: json['availability_water'] ?? '',
      visibility_from_Road: json['visibility_from_Road'] ?? '',
      no_presence_divider: json['no_presence_divider'] ?? '',
      outside_octroi_limits: json['outside_octroi_limits'] ?? '',
      lec_parameter_id: json['lec_parameter_id'] ?? '',
    );
  }
}