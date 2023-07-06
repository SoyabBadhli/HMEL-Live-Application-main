import 'package:flutter/cupertino.dart';
import 'package:lec/model/models/fetch_params_model.dart';
import 'package:lec/model/repository/param_repo.dart';
import 'package:lec/model/repository/pending_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/screens/lec_params.dart';

class ParamsProviderCom with ChangeNotifier {
  bool isLoaded = false;
  Map? paramsDataPro;
  bool isTapped = false;
  String? lecParameterId;
  String? lecParameteId2;
  var fpmap;
  // static list
  List<String> paramVal = ["YES", "NO", "NA"];
  // static list
  List selectedParams = [
    {"p_name": "Earth filling reqd.", "selected_val": ""},
    {"p_name": "Earth/rock cutting reqd.", "selected_val": ""},
    {"p_name": "LT O/H Line", "selected_val": ""},
    {"p_name": "O/H Tel.Line", "selected_val": ""},
    {"p_name": "Trees", "selected_val": ""},
    {
      "p_name": "Proximity to culvert (farther from culvert desirable)",
      "selected_val": ""
    },
    {"p_name": "Soil Type (Soft)", "selected_val": ""},
    {"p_name": "Availability of Power", "selected_val": ""},
    {"p_name": "Availability of Water", "selected_val": ""},
    {"p_name": "Visibility from Road", "selected_val": ""},
    {"p_name": "No Presence of Divider", "selected_val": ""},
    {"p_name": "Outside Octroi Limits", "selected_val": ""}
  ];

  FetchParamsModel? fpModel;
  FetchParamsModel? updatedParamsPro; // update data

  ///isLoaded
  bool getIsLoaded() {
    return isLoaded;
  }

  void setIsLoaded(bool value) {
    isLoaded = value;
    notifyListeners();
  }

  ///isTapped
  bool getIsTapped() {
    return isTapped;
  }

  void setIsTapped(bool value) {
    isTapped = value;
    notifyListeners();
  }

  Future<void> loadRepoInProvider(
      String lec_id,
      String application_id,
      String accessToken,
      String earth_filling,
      String earth_rock_cutting,
      String LT_O_H_Line,
      String oh_tel_line,
      String trees,
      String proximity_to_culvert,
      String soil_type,
      String availability_power,
      String availability_water,
      String visibility_from_Road,
      String no_presence_divider,
      String outside_octroi_limits,
      String lec_param_id
      ) async {
    fpModel = await ParamsRepo().postParamsApi(
        lec_id,
        application_id,
        accessToken,
        earth_filling,
        earth_rock_cutting,
        LT_O_H_Line,
        oh_tel_line,
        trees,
        proximity_to_culvert,
        soil_type,
        availability_power,
        availability_water,
        visibility_from_Road,
        no_presence_divider,
        outside_octroi_limits,
        lec_param_id);
    // print("dataListProvider : ${dataListProvider!.length} ");
    if (paramsDataPro != null) {
      // here we get a id from a map
      lecParameterId = ('${paramsDataPro!["lec_parameter_id"]}');

      print('lecParameter ID ---97-$lecParameterId');

      setIsLoaded(true);
    }
    notifyListeners();
  }

  ///For Updation of Params
  ///
  Future<void> updateParamsInProvider(
      String lec_id,
      String application_id,
      String earth_filling,
      String earth_rock_cutting,
      String LT_O_H_Line,
      String oh_tel_line,
      String trees,
      String proximity_to_culvert,
      String soil_type,
      String availability_power,
      String availability_water,
      String visibility_from_Road,
      String no_presence_divider,
      String outside_octroi_limits,
      String lec_parameter_id,
      String access_token
      ) async {
    fpmap = await ParamsRepo().updateParamsApi(
        lec_id,
        application_id,
        earth_filling,
        earth_rock_cutting,
        LT_O_H_Line,
        oh_tel_line,
        trees,
        proximity_to_culvert,
        soil_type,
        availability_power,
        availability_water,
        visibility_from_Road,
        no_presence_divider,
        outside_octroi_limits,
        lec_parameter_id,
    );
    // print("dataListProvider : ${dataListProvider!.length} ");
    if (fpmap != null) {
      print('---------140 $fpmap');
      setIsLoaded(true);
    }
    notifyListeners();
  }

  // Future<void> trackUserApi() async {
  //   trackUserModel = await TrackUserRepo().trackUserRepoApi();
  //   notifyListeners();
  // }

  ///Params
  String? getParamsValue(int index) {
    return selectedParams[index]["p_name"];
  }

  void setParamsValue(int index, String value) {
    selectedParams[index]["selected_val"] = value;
    notifyListeners();
  }

  ///Fetch Params
  Future<void> fetchParamsInProvider(
      String lec_id, String application_id,String accessToken) async {
    fpmap = await ParamsRepo().fetchParamsApi(lec_id, application_id,accessToken);
    debugPrint(
        "status: ${fpmap['status']} lec_parameter_id: ${fpmap['data'][0]['lec_parameter_id']} ");

    Future.delayed(Duration(seconds: 2), () {
      if (fpmap['status'] == true) {
        print("${fpmap['data'][0]['earth_filling']!}");
        setParamsValue(0, fpmap['data'][0]['earth_filling']!);
        setParamsValue(1, fpmap['data'][0]['earth_rock_cutting']!);
        setParamsValue(2, fpmap['data'][0]['LT_O_H_Line']!);
        setParamsValue(3, fpmap['data'][0]['oh_tel_line']!);
        setParamsValue(4, fpmap['data'][0]['trees']!);
        setParamsValue(5, fpmap['data'][0]['proximity_to_culvert']!);
        setParamsValue(6, fpmap['data'][0]['soil_type']!);
        setParamsValue(7, fpmap['data'][0]['availability_power']!);
        setParamsValue(8, fpmap['data'][0]['availability_water']!);
        setParamsValue(9, fpmap['data'][0]['visibility_from_Road']!);
        setParamsValue(10, fpmap['data'][0]['no_presence_divider']!);
        setParamsValue(11, fpmap['data'][0]['outside_octroi_limits']!);
      }
    });

    //provider.selectedParams[index]["selected_val"] = value.toString();
    //var status=  (fpModel?.status == 'true')? "true":"false";
    //print('Status...code ----143--$status');

    // print("dataListProvider : ${dataListProvider!.length} ");
    if (fpModel != null) {
      setIsLoaded(true);
    }
    notifyListeners();
  }

  fetchDataFromProvider() {
    setParamsValue(0, fpModel!.data![0]!.earthFilling!);
    setParamsValue(1, fpModel!.data![0]!.earthRockCutting!);
    setParamsValue(2, fpModel!.data![0]!.ltOHLine!);
    setParamsValue(3, fpModel!.data![0]!.ohTelLine!);
    setParamsValue(4, fpModel!.data![0]!.trees!);
    setParamsValue(5, fpModel!.data![0]!.proximityToCulvert!);
    setParamsValue(6, fpModel!.data![0]!.soilType!);
    setParamsValue(7, fpModel!.data![0]!.availabilityPower!);
    setParamsValue(8, fpModel!.data![0]!.availabilityWater!);
    setParamsValue(9, fpModel!.data![0]!.visibilityFromRoad!);
    setParamsValue(10, fpModel!.data![0]!.noPresenceDivider!);
    setParamsValue(11, fpModel!.data![0]!.outsideOctroiLimits!);
    //  fpModel!.status;
    notifyListeners();
  }

  void clearParams() {
    // debugPrint("clearParams: ${fpmap['data']}");
    for (int i = 0; i < selectedParams.length; i++) {
      selectedParams[i]["selected_val"] = "";
    }
    notifyListeners();
  }
}
