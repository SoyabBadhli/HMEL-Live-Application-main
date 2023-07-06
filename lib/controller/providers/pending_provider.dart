import 'package:flutter/cupertino.dart';
import 'package:lec/model/repository/pending_repo.dart';

class PendingProvider with ChangeNotifier {

  bool isLoaded = false;
  List? pendDataPro;
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
    pendDataPro = await PendingRepo().getPendingApi();

    print(" from 31-----listpending..-------- $pendDataPro");

    if (pendDataPro == null) {
      setIsLoaded(false);
    }else if(pendDataPro !=null){
      setIsLoaded(true);
    }else{}
    notifyListeners();
  }
}
