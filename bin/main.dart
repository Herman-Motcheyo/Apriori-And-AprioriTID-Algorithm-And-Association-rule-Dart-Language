import 'dart:io';

import 'apriorie/AlgorithmApriori.dart';
import 'utilitaire/Utilitaire.dart';
import 'utilitaire/Association.dart';

void main(List<String> arguments) {
  int choice;
  var supMin = 5;
  var confMin = 50;
  var tabFinal;

  int rep;
  print(
      '               \n          ****************Bienvenue sur le Tp301 Association Rule Groupe 24 **************');
  print(
      "\n                                    CHOIX DE L'AGORITHME                         ");
  print('  \n                               ******** 1 Apriori    *********  ');
  print('                               ******** 2 AprioriTid  ********* \n ');

  do {
    print(
        '                  // Faites un choix  svp 1 = Apriori et 2 = AprioriTid// \t  ');
    choice = int.parse(stdin.readLineSync());
  } while (choice != 1 && choice != 2);

  print('\n    ***Entrer le Support pour extraire les Itemsets Frequents');
  supMin = int.parse(stdin.readLineSync());
  print("\n  ***Entrer la confiance pour generer les regles d \' association ");
  confMin = int.parse(stdin.readLineSync());

  var tabTransaction = Utilitaire.extractData('../user1.xlsx');
  var tabItem = Utilitaire.extractItem(tabTransaction);
  switch (choice) {
    case 1:
      print(
          '  \n                               ******** 1 Apriori    *********  ');
      print(
          '\n                 Algorithme Apriori  pour la recherche des Itemsets Frequent');
      var algo = AlgorithmApriori(supMin);
      tabFinal = algo.findLk(
          tabTransaction, null, algo.generateL1(tabTransaction, tabItem), 1);
      print(
          '************************************************l\'ensemble des itemSet frequent est**************************************\n');
      if (tabFinal != null) {
        for (var itemSet in tabFinal) {
          print('$itemSet \n');
        }
      } else {
        print('il n\'existe pas d\'itemSet frequent de cette frequence ');
      }
      break;
    default:
      print(
          '  \n                               ******** 2 AprioriTid    *********  ');
      print(
          '\n                 Algorithme AprioriTid  pour la recherche des Itemsets Frequent');
      var algo = AlgorithmApriori(supMin);
      tabFinal = algo.findLk(
          tabTransaction, null, algo.generateL1(tabTransaction, tabItem), 1);
      print(
          '************************************************l\'ensemble des itemSet frequent est**************************************\n');
      if (tabFinal != null) {
        for (var itemSet in tabFinal) {
          print('$itemSet \n');
        }
      } else {
        print('il n\'existe pas d\'itemSet frequent de cette frequence ');
      }
      print(
          'Voulez vous continuer à evaluer l \' algorithme Apriori et la generation des règles d \'addociation ??? 1 = oui et 0= non');
      rep = int.parse(stdin.readLineSync());

      break;
  }

  rep = 1;
  do {
    print(
        '                 ****         voulez vous afficher les d\'association? (oui = 1  non = 0)          ****                    ');
    rep = int.parse(stdin.readLineSync());
  } while (rep != 1 && rep != 0);

  if (rep == 1) {
    var association = Association(confMin);
    association.generateAssociationRule(tabTransaction, tabFinal);
    print(
        '************************************************les règles qui decoulent sont: *******************************************\n');
    if (association.tabRule != null) {
      for (var i = 0; i < association.tabRule.length; i++) {
        print('${association.tabRule[i]} \n');
      }
    }
  }
}
