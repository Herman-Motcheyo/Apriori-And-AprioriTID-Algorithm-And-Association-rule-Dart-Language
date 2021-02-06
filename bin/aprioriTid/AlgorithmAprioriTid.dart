 import 'dart:collection';

import '../utilitaire/Utilitaire.dart';

class Algorithm{
  int supMin;
 
  Algorithm(int supMin){
    this.supMin = supMin;
  }

List<HashMap<int, HashSet<String>>> GenerateCkBarOne(
			HashMap<int, HashSet<String>> tabTransaction) {
		var tabCkOneBar = <HashMap<int, HashSet<String>>>[];
		var iterator = tabTransaction.values.iterator;
	var cpt = 0;
		while (iterator.moveNext()) {
			var key = 0;
			var CkOneBar =  HashMap<int, HashSet<String>>();
			for (var item in iterator.current) {
			var Ckbar = HashSet<String>();
				Ckbar.add(item);
				CkOneBar[key]= Ckbar;
				key = key + 1;
			}
			tabCkOneBar.add(CkOneBar);
			cpt = cpt + 1;
		}
		return tabCkOneBar;

	}

List<HashMap<int, HashSet<String>>> GenerateCkBar(List<HashSet<String>> lk,
			List<HashMap<int, HashSet<String>>> ckBar) {
		var tabCkBar = <HashMap<int, HashSet<String>>>[];
		 var saveItems = <HashSet<String>>[];
		 for (var i = 0; i < ckBar.length; i++) {
			 var newmap=ckBar[i];
			 var iterator = newmap.values.iterator;
			 while(iterator.moveNext()) {
				 var temp = iterator.current;
				 for (var j = 0; j < lk.length; j++) {
           
					if(Utilitaire.Hcontains(lk[j], temp)) {
						saveItems.add(temp);
					}
				}
			 }
		 }
		 
		var key = 0;
		for (var i = 0; i < ckBar.length; i++) {
			var map = ckBar[i];
			var Ck = HashMap<int, HashSet<String>>();
			var iterator = map.values.iterator;


			while (iterator.moveNext()) {
				var temp =iterator.current;
					
					if (Utilitaire.contains(saveItems, temp)) { 
						var iterator2= map.values.iterator;
						
						while(iterator2.moveNext()) {
							
							var temp2 = iterator2.current;
							if(!Utilitaire.Hcontains(temp, temp2)) {
								
								if (Utilitaire.contains(saveItems, temp2)) {
									var sett =  HashSet<String>();
									sett.addAll(temp);
									sett.addAll(temp2);
									if(!Ck.containsValue(sett)) {
										
										Ck[key]= sett;
										key = key + 1;
									}
									
								}
							}
						}
						
						
					}
				


			}
			key = 0;

			tabCkBar.add(Ck);



		}

		return tabCkBar;
  }





	 List<HashSet<String>> generateNewL1(HashMap<int, HashSet<String>> tabTransaction,
			List<String> tabItem) {
		var sup = 0;
		var tabL1 = <HashSet<String>>[];

		for (var i = 0; i < tabItem.length; i++) {
			var set = HashSet<String>();
			var iterator = tabTransaction.values.iterator;
			while (iterator.moveNext()) {
				var  temp = iterator.current;
				if (temp.contains(tabItem[i])) {
					// System.out.println(temp + "value constains "+ tabItem[i]);
					sup++;
				}

			}

			if (sup >= supMin) {
				set.add(tabItem[i]);
				tabL1.add(set);
			}
			sup = 0;
		}
		// System.out.println("rich to end");
		return tabL1;
	}

	List<HashSet<String>> generatenewCk(List<HashSet<String>> lk) {
		
	var  tabCk = <HashSet<String>>[];
		var t = lk.length;
//	int taille=t*(t-1)/2;
//	String [] ck=new String[taille];
		for (var i = 0; i < t; i++) {
			var lk1 = lk[i];
			for (var j = i + 1; j < t; j++) {
				var lk2 = lk[j];
				if (Utilitaire.isJoinnable(lk1, lk2) == true) {
					var Ck = HashSet<String>();
					Ck.addAll(lk1);
					Ck.addAll(lk2);
					if (Utilitaire.contains(tabCk, Ck) == false) {
					  tabCk.add(Ck);
					}
				}
			}
		}

		return tabCk;
	}



	List<HashSet<String>> newGenerateLk(List<HashMap<int, HashSet<String>>> ckBar,
			List<HashSet<String>> ck) {
		var sup = 0 ;
		var tabLk = <HashSet<String>>[];
		HashSet<String> temp, ckTemp;
		if (ck.isNotEmpty) {

			for (var i = 0; i < ck.length; i++) {
				ckTemp = ck[i];
				for (var j = 0; j < ckBar.length; j++) {
					var iterator = ckBar[j].values.iterator;
					while (iterator.moveNext()) {
						temp = iterator.current;

						// System.out.println(temp);
				
						if (Utilitaire.Hcontains(ckTemp, temp)) {

							sup++;
						}

					}
				}

				if (sup >= supMin) {
					tabLk.add(ckTemp);
					
				}
				sup = 0;
			}
		}

		return tabLk;
	}


	
  
  }
  
  