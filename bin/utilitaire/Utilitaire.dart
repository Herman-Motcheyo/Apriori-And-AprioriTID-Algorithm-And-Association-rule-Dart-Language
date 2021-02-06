import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'package:excel/excel.dart';

class Utilitaire {
    static HashMap<int, HashSet<String>> extractData(String filePath) {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    HashMap tabTransaction = HashMap<int, HashSet<String>>();

    var key = 0;
    var previousNum = 1;
    var itemList = <String>[];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (previousNum == row[0]) {
          itemList.add(row[1]);
        } else {
          HashSet transaction = HashSet<String>();
          transaction.addAll(itemList);
          tabTransaction[key] = transaction;
          itemList.clear();
          itemList.add(row[1]);
          key++;
          previousNum = row[0];
        }
      }
    }
    HashSet transaction = HashSet<String>();
    transaction.addAll(itemList);
    tabTransaction[key] = transaction;
    return tabTransaction;
  }
  
  static List<String> extractItem(HashMap<int, HashSet<String>>  tabTransaction){
    String temp;
    var tabItem = <String>[];
    var iterator = tabTransaction.values.iterator;
    while(iterator.moveNext()){
      var iteratorSet = iterator.current.iterator;
      while(iteratorSet.moveNext()){
        temp = iteratorSet.current;
        //we verify if the item isn't contains in the tabItem
        if(tabItem.contains(temp) == false){
          tabItem.add(temp);
        }
      }
    }
    return tabItem;
  }


  static bool isJoinnable(HashSet<String> ensemble1 , HashSet<String> ensemble2){
    var cmpt = 0;
    if(ensemble1.length == ensemble2.length){
      var iterator = ensemble1.iterator;
      while(iterator.moveNext()){
        if(ensemble2.contains(iterator.current) == true) {
          cmpt++;
        }
      }
      if(cmpt == ensemble1.length - 1){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
  
  static bool contains(List<HashSet<String>> tab , HashSet<String> ensemble){
    for (var i = 0; i < tab.length; i++) {
      if(tab[i].containsAll(ensemble) == true){
        return true;
      }
    }
    return false;
  }

  static bool Hcontains(HashSet <String>h1,HashSet<String>h2){
    var rep=false;
    for(var item in h2){
      if(h1.contains(item)){
        rep=true;
      }else{
        return false;
      }
    }
      return rep;
  }

}
