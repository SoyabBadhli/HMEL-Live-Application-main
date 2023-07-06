// import 'package:flutter/cupertino.dart';

// class LecParamsProvider with ChangeNotifier {
//   List selectedParams = [
//     {"p_name": "Earth filling reqd.", "selected_val": ""},
//     {"p_name": "Earth/rock cutting reqd.", "selected_val": ""},
//     {"p_name": "LT O/H Line", "selected_val": ""},
//     {"p_name": "O/H Tel.Line", "selected_val": ""},
//     {"p_name": "Trees", "selected_val": ""},
//     {
//       "p_name": "Proximity to culvert (farther from culvert desirable)",
//       "selected_val": ""
//     },
//     {"p_name": "Soil Type (Soft)", "selected_val": ""},
//     {"p_name": "Availability of Power", "selected_val": ""},
//     {"p_name": "Availability of Water", "selected_val": ""},
//     {"p_name": "Visibility from Road", "selected_val": ""},
//     {"p_name": "No Presence of Divider", "selected_val": ""},
//     {"p_name": "Outside Octroi Limits", "selected_val": ""},
//   ];

//   List<String> paramVal = ["Yes", "No", "NA"];
//   bool isLoaded = false;

//   // Future<void> trackUserApi() async {
//   //   trackUserModel = await TrackUserRepo().trackUserRepoApi();
//   //   notifyListeners();
//   // }

//   ///isLoaded
//   bool getIsLoaded() {
//     return isLoaded;
//   }

//   void setIsLoaded(bool value) {
//     isLoaded = value;
//     notifyListeners();
//   }

//   ///Params
//   String? getParamsValue(int index) {
//     return selectedParams[index]["p_name"];
//   }

//   void setParamsValue(int index, String value) {
//     selectedParams[index]["selected_val"] = value;
//     notifyListeners();
//   }
// }
