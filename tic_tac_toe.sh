#!/bin/bash
# Author: LMI
# Date: 13/0CT/2021
# Version 1.6
#   history: 1.5 removed computer thinking display.
#            1.6 LEVEL 1 done.
# Todo: Level2...

# variables globales.
turn=0

declare -A tableau
#initialise tableau
for i in {1..9}
do
  tableau[$i]="-"
done

#affiche tableau
affiche_tableau( ){
  #echo ${!tableau[@]}
  echo "   ___ ___ ___"
  echo "  |   |   |   |"
  echo "  | ${tableau[1]} | ${tableau[2]} | ${tableau[3]} |"
  echo "  |___|___|___|"
  echo "  |   |   |   |"
  echo "  | ${tableau[4]} | ${tableau[5]} | ${tableau[6]} |"
  echo "  |___|___|___|"
  echo "  |   |   |   |"
  echo "  | ${tableau[7]} | ${tableau[8]} | ${tableau[9]} |"
  echo "  |___|___|___|"
  echo
  echo " 1 2 3"
  echo " 4 5 6"
  echo " 7 8 9"
  echo
  return
}

# ordi joue au (hasard ou calculé)
ordijoue(){
  # 123
  # 456
  # 789
  # todo: intelligence à définir. (4 niveaux)
  # premier à jouer ?
  # si oui
  if [ $turn -eq 1 ];then
    echo "tour 1"
    #   choisir une case du jeu
    #   1) 5
    #   2) 1379
    #   3) 2468
    #   4) 1234456789
  fi
  case $LEVEL in 
    0)
      # LEVEL 0
      # ordi choisi au hazard parmi 9 choix
      valid=0
      while [ $valid == 0 ]
      do
        dest=$((1 + $RANDOM % 9))
        # test si vide ?
        test_coup_valide $dest ordi
      done
    ;;
    1)
      # LEVEL 1
      # choix dans l'ordre: le centre, les coins, les bords
      # soit 5,1,3,7,9,2,4,6,8
      valid=0
      while [ $valid == 0 ]
      do
        bestplay=5,1,3,7,9,2,4,6,8
        for i in ${bestplay//,/ }
        do
          dest=$i
          test_coup_valide $dest ordi
          if [ $valid -eq 1 ];then
	    break
          fi
	done
      done
    ;;
  esac
  tableau[$dest]="O"
  echo ordi joue : $dest

  # TODO: LEVEL 2
  # si non contrer le jeu en fonction des 8 solutions
  # odds: + + - - - - _ _
  #       1 7 1 1 7 3 4 2
  #       5 5 4 2 8 6 5 5
  #       9 3 7 3 9 9 6 8
  # le joueur joue dans le coin
  #  alors ordi joue a coté.
  #
  #

  return $dest
}

test_coup_valide(){
  if [ ${tableau[$1]} = "-" ];then
    valid=1
  else
    if [ $2 = "joueur" ];then
      echo "Choix impossible"
    fi
  fi
  return $valid
}

choisir_case(){
  valid=0
  while [ $valid == 0 ]
  do
    read -r -p "Quelle case ? " case
    # test si vide ?
    test_coup_valide $case joueur
  done
  return $case
}

# joueur joue
joueurjoue(){
  affiche_tableau
  # q? entrez votre case ?
  case=&choisir_case
  #echo choix : $case
  tableau[$case]="X"
  return
}

# test si gagne
testgagne(){
  # vérification si une des 8 solutions a 3 x ou 3 o
  #       1 7 1 1 7 3 4 2
  #       5 5 4 2 8 6 5 5
  #       9 3 7 3 9 9 6 8

  winning=1-5-9,7-5-3,1-4-7,1-2-3,7-8-9,3-6-9,4-5-6,2-5-8
  for i in ${winning//,/ }
  do
    IFS=- read A B C <<< "$i"
    if [ ${tableau[$A]} != '-' ] && [ ${tableau[$A]} == ${tableau[$B]} ] && [ ${tableau[$B]} == ${tableau[$C]} ]; then
      echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
      echo "${tableau[$A]} WINS ! ${tableau[$A]} ${tableau[$B]} ${tableau[$C]}"
      echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
      affiche_tableau
      exit
    fi
  done
  return
}

#########################
# MAIN
#########################

# choix du niveau de l'ordinateur
LEVEL=0
valid=0
while [ $valid == 0 ]
  do
  read -r -p "Niveau de difficulté (0,1,2) ? " LEVEL
    case $LEVEL in
	    0) echo "LEVEL $LEVEL (Facile)"
            valid=1
            ;;
            1) echo "LEVEL $LEVEL (moins facile)"
            valid=1
            ;;
	    *) echo "NOT READY YET"
            sleep 1
            ;;
    esac
  done

# random qui commence
JOUEUR=$((1 + $RANDOM % 2))
case $JOUEUR in
1) echo ordinateur commence;
   J=0
;;
2) echo joueur commence;
   J=1
;;
esac

### c'est parti pour 9 tours de jeu
for i in {1..9}
do
  turn=$i
  #echo tour de jeu: $turn
  if [ $J -eq 0 ];then
    J=1
    ordijoue
  else
    J=0
    joueurjoue
  fi
  testgagne
done
affiche_tableau
