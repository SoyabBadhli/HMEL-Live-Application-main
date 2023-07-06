
import 'package:flutter/cupertino.dart';
import 'package:lec/model/repository/pending_repo.dart';

import '../../model/repository/complete_repo.dart';

class CompleteListProvider with ChangeNotifier {

  bool isLoaded = false;
  List? completeDataPro;
  bool isTapped = false;
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
  // Repo into the provider
  Future<void> loadRepoInProvider() async {
    //loder
    completeDataPro = await CompleRepo().getCompleApi();
    // print("dataListProvider : ${dataListProvider!.length} ");
    // loder

    print('------------34----$completeDataPro');
    if(completeDataPro == null){
      setIsLoaded(false);
    }else if(completeDataPro != null){
      setIsLoaded(true);
    }else{

    }
    // if (completeDataPro != null) {
    //   setIsLoaded(true);
    // }
    notifyListeners();
  }
}
