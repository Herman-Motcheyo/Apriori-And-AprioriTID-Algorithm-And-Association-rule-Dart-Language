import 'dart:collection';

class Association {
  double confMin;
  List tabRule;

  Association(int confMin) {
    this.confMin = confMin / 100;
    tabRule = <Rule>[];
  }

  void generatePrimaryRule(
      HashMap<int, HashSet<String>> tabTransaction, HashSet<String> LkSet) {
    List tab = <String>[];
    var conf1 = 0.0, conf2 = 0.0;
    for (var item in LkSet) {
      tab.add(item);
    }

    for (var i = 0; i < tab.length; i++) {
      HashSet itemSet1 = HashSet<String>();
      itemSet1.add(tab[i]);
      for (var j = i + 1; j < tab.length; j++) {
        HashSet itemSet2 = HashSet<String>();
        itemSet2.add(tab[j]);
        // calcul de la confiance de la regle itemSet1 -> itemSet2
        conf1 = calculateConf(tabTransaction, itemSet1, itemSet2);
        // calcul de la confiance de la regle itemSet2 -> itemSet1
        conf2 = calculateConf(tabTransaction, itemSet2, itemSet1);
        if (conf1 >= confMin) {
          var rule = Rule();
          rule.antecedant = itemSet1;
          rule.consequent = itemSet2;
          rule.conf = conf1;
          tabRule.add(rule);
        }

        if (conf2 >= confMin) {
          var rule = Rule();
          rule.antecedant = itemSet2;
          rule.consequent = itemSet1;
          rule.conf = conf2;
          tabRule.add(rule);
        }
      }
    }
  }

  double calculateConf(HashMap<int, HashSet<String>> tabTransaction,
      HashSet<String> antecedant, HashSet<String> consequent) {
    var supAntecedant = calculateSupport(tabTransaction, antecedant);
    var supItemSet = 0;
    HashSet itemSet = HashSet<String>();
    itemSet.addAll(antecedant);
    itemSet.addAll(consequent);
    supItemSet = calculateSupport(tabTransaction, itemSet);
    return supItemSet / supAntecedant;
  }

  int calculateSupport(
      HashMap<int, HashSet<String>> tabTransaction, HashSet<String> itemSet) {
    var sup = 0;
    var iterator = tabTransaction.values.iterator;
    while (iterator.moveNext()) {
      if (iterator.current.containsAll(itemSet) == true) {
        sup++;
      }
    }
    return sup;
  }

  List<Rule> generateBaseRule(
      HashMap<int, HashSet<String>> tabTransaction, HashSet<String> LkSet) {
    var conf = 0.0;

    List tabRule = <Rule>[];
    List tab = <String>[];
    for (var item in LkSet) {
      tab.add(item);
    }

    for (var i = tab.length - 1; i >= 0; i--) {
      HashSet consequent = HashSet<String>();
      HashSet antecedent = HashSet<String>();
      consequent.add(tab[i]);
      for (var j = 0; j < tab.length; j++) {
        if (j == i) {
          continue;
        }
        antecedent.add(tab[j]);
      }

      conf = calculateConf(tabTransaction, antecedent, consequent);
      if (conf >= confMin) {
        var rule = Rule();
        rule.antecedant = antecedent;
        rule.consequent = consequent;
        rule.conf = conf;
        tabRule.add(rule);
      }
    }
    return tabRule;
  }

  void generateRules(
      HashMap<int, HashSet<String>> tabTransaction, List<Rule> tabRule) {
    Queue queueRule = Queue<Rule>();
    for (var i = 0; i < tabRule.length; i++) {
      queueRule.add(tabRule[i]);
    }

    while (queueRule.isEmpty == false) {
      Rule temp = queueRule.removeFirst();
      if (temp != null) {
        if (temp.antecedant.length >= 2) {
          var tab =
              generateNewRule(tabTransaction, temp.antecedant, temp.consequent);
          if (tab != null) {
            for (var i = 0; i < tab.length; i++) {
              queueRule.add(tab[i]);
            }
          }
        }
        this.tabRule.add(temp);
      }
    }
  }

  List<Rule> generateNewRule(HashMap<int, HashSet<String>> tabTransaction,
      HashSet<String> antecedant, HashSet<String> consequent) {
    var rep = false;
    List tabRule = <Rule>[];
    var conf = 0.0;

    List tab = <String>[];
    for (var item in antecedant) {
      tab.add(item);
    }

    for (var i = tab.length - 1; i >= 0; i--) {
      HashSet ant = HashSet<String>();
      HashSet con = HashSet<String>();
      con.add(tab[i]);
      con.addAll(consequent);
      for (var j = 0; j < tab.length; j++) {
        if (j == i) {
          continue;
        }
        ant.add(tab[j]);
      }
      conf = calculateConf(tabTransaction, ant, con);
      if (conf >= confMin) {
        rep = true;
        var rule = Rule();
        rule.antecedant = ant;
        rule.consequent = con;
        rule.conf = conf;
        tabRule.add(rule);
      }
    }

    if (rep == false) {
      return null;
    } else {
      return tabRule;
    }
  }

  void generateAssociationRule(HashMap<int, HashSet<String>> tabTransaction,
      List<HashSet<String>> tabLk) {
    if (tabLk != null) {
      for (var Lk in tabLk) {
        print(Lk);
        generatePrimaryRule(tabTransaction, Lk);
        var tabRuleBase = generateBaseRule(tabTransaction, Lk);
        generateRules(tabTransaction, tabRuleBase);
      }
    } else {
      print('eureka');
    }
  }
}

class Rule {
  HashSet<String> antecedant;
  HashSet<String> consequent;
  double conf;

  @override
  String toString() {
    return '${antecedant} -----> ${consequent}  conf $conf';
  }
}
