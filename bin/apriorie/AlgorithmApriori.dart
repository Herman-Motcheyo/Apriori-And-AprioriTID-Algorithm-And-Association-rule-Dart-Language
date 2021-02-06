import 'dart:collection';

import '../utilitaire/Utilitaire.dart';

class AlgorithmApriori {
  int supMin;
  bool ableToGenerateCk = true;
  bool ableToGenerateLk = true;

  AlgorithmApriori(int supMin) {
    this.supMin = supMin;
  }

  List<HashSet<String>> findLk(HashMap<int, HashSet<String>> tabTransaction,
      List<HashSet<String>> tabLk, List<String> tabL1, int k) {
    if (ableToGenerateLk == false) {
      return tabLk;
    } else {
      List CkSet = <HashSet<String>>[];
      if (k == 1) {
        CkSet = generateC2(tabL1);
      } else {
        CkSet = generateCk(tabLk);
      }
      k++;
      if (ableToGenerateCk == false) {
        return tabLk;
      } else {
        List LkSet = generateLk(tabTransaction, CkSet);
        if (ableToGenerateLk == false) {
          return tabLk;
        } else {
          print(
              '****************************            ************************');
          print(
              'candidats ${CkSet.length} taille de chaque candidat ${CkSet[0].length}');
          print('candidats valide ${LkSet.length}');
          print(
              '****************************            ************************');
          return findLk(tabTransaction, LkSet, tabL1, k);
        }
      }
    }
  }

  List<String> generateL1(
      HashMap<int, HashSet<String>> tabTransaction, List<String> tabItem) {
    var sup = 0;
    List tabL1 = <String>[];
    for (var i = 0; i < tabItem.length; i++) {
      var iterator = tabTransaction.values.iterator;
      while (iterator.moveNext()) {
        if (iterator.current.contains(tabItem[i]) == true) {
          sup++;
        }
      }
      if (sup >= supMin) {
        tabL1.add(tabItem[i]);
      }
      sup = 0;
    }
    return tabL1;
  }

  List<HashSet<String>> generateC2(List<String> tabL1) {
    List tabC2 = <HashSet<String>>[];
    for (var i = 0; i < tabL1.length; i++) {
      for (var j = i + 1; j < tabL1.length; j++) {
        HashSet Ck = HashSet<String>();
        Ck.add(tabL1[i]);
        Ck.add(tabL1[j]);
        tabC2.add(Ck);
      }
    }

    return tabC2;
  }

  List<HashSet<String>> generateCk(List<HashSet<String>> tab) {
    List tabCk = <HashSet<String>>[];
    var cmpt = 0;
    for (var i = 0; i < tab.length; i++) {
      for (var j = i + 1; j < tab.length; j++) {
        if (Utilitaire.isJoinnable(tab[i], tab[j]) == true) {
          HashSet Ck = HashSet<String>();
          Ck.addAll(tab[i]);
          Ck.addAll(tab[j]);
          if (Utilitaire.contains(tabCk, Ck) == false) {
            tabCk.add(Ck);
            //print('enter');
          }
          cmpt++;
        }
      }
    }
    if (cmpt == 0) {
      ableToGenerateCk = false;
    }
    return tabCk;
  }

  List<HashSet<String>> generateLk(
      HashMap<int, HashSet<String>> tabTransaction, List<HashSet<String>> tab) {
    var sup = 0;
    List tabLk = <HashSet<String>>[];
    var cmpt = 0;
    for (var i = 0; i < tab.length; i++) {
      var iterator = tabTransaction.values.iterator;
      while (iterator.moveNext()) {
        if (tab[i] != null) {
          if (iterator.current.containsAll(tab[i]) == true) {
            sup++;
          }
        }
      }

      if (sup >= supMin) {
        tabLk.add(tab[i]);
        cmpt++;
      }
      sup = 0;
    }
    if (cmpt == 0) {
      ableToGenerateLk = false;
    }
    return tabLk;
  }
}
