import 'package:flutter/cupertino.dart';

class PendingPhotoProvider with ChangeNotifier {

  List photos = [
    {"name": "Photo 1", "image_base64": "", "image_name": ""},
    {"name": "Photo 2", "image_base64": "", "image_name": ""},
    {"name": "Photo 3", "image_base64": "", "image_name": ""},
    {"name": "Photo 4", "image_base64": "", "image_name": ""},
    {"name": "Photo 5", "image_base64": "", "image_name": ""},
    {"name": "Photo 6", "image_base64": "", "image_name": ""},
    {"name": "Photo 7", "image_base64": "", "image_name": ""},
    {"name": "Photo 8", "image_base64": "", "image_name": ""},
    {"name": "Photo 9", "image_base64": "", "image_name": ""},
    {"name": "Photo 10", "image_base64": "", "image_name": ""}
  ];
  // List selectedParams = [
  //   {"p_name": "Earth filling reqd.", "selected_val": ""},
  //   {"p_name": "Earth/rock cutting reqd.", "selected_val": ""},
  //   {"p_name": "LT O/H Line", "selected_val": ""},
  //   {"p_name": "O/H Tel.Line", "selected_val": ""},
  //   {"p_name": "Trees", "selected_val": ""},
  //   {
  //     "p_name": "Proximity to culvert (farther from culvert desirable)",
  //     "selected_val": ""
  //   },
  //   {"p_name": "Soil Type (Soft)", "selected_val": ""},
  //   {"p_name": "Availability of Power", "selected_val": ""},
  //   {"p_name": "Availability of Water", "selected_val": ""},
  //   {"p_name": "Visibility from Road", "selected_val": ""},
  //   {"p_name": "No Presence of Divider", "selected_val": ""},
  //   {"p_name": "Outside Octroi Limits", "selected_val": ""},
  // ];

  // List<String> paramVal = ["Yes", "No", "NA"];
  bool isLoaded = false;

  // Future<void> trackUserApi() async {
  //   trackUserModel = await TrackUserRepo().trackUserRepoApi();
  //   notifyListeners();
  // }

  ///isLoaded
  bool getIsLoaded() {
    return isLoaded;
  }

  void setIsLoaded(bool value) {
    isLoaded = value;
    notifyListeners();
  }

  ///Params
  String? getParamsValue(int index) {
    return photos[index]["p_name"];
  }

  void setParamsValue(int index, String value) {
    photos[index]["selected_val"] = value;
    notifyListeners();
  }

  /// Photo
  // String? getPhotoData(int index) {
  //   return photos[index]["p_name"];
  // }

  ///ImageBase64
  void setImageBase64(int index, String value) {
    photos[index]['image_base64'] = value;
    notifyListeners();
  }

  ///ImageName
  void setImageName(int index, String value) {
    photos[index]['image_name'] = value;
    notifyListeners();
  }
}
