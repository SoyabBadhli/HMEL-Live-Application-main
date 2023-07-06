import 'package:flutter/cupertino.dart';
import 'package:lec/model/repository/pending_repo.dart';
import 'package:lec/model/repository/report_downlode_repo.dart';

import '../../model/repository/complete_repo.dart';

class ReportDownlodeProvider with ChangeNotifier {

  bool isLoaded = false;
  List? repotdownldoelist;
  bool isTapped = false;
  bool loginStatus = false;
  // Getter and Setter

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
       String lecid, String applicationid) async {
    print('----------34---lecid------$lecid');
    print('----------35---applicationId------$applicationid');
     repotdownldoelist = await ReportDowwnlodeRepo().getReportDownldoeParameter("$lecid", "$applicationid");
     print('------44---$repotdownldoelist');
     if (repotdownldoelist == null) {
       setIsLoaded(false);
     }else if(repotdownldoelist !=null){
       setIsLoaded(true);
     }else{}
     notifyListeners();
  }
}
