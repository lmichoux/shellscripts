#!/bin/bash
# Author: LMI
# Date: 13/0CT/2021
# Version 1.4
#    
# variables globales.
turn=0

declare -A tableau
#initialise tableau
for i in {1..9}
do
  tableau[$i]="-"
done

#affiche tableau
affiche_tableau(){
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
  # niv. intelligence à définir. (4 niveaux)
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
  # LEVEL 0 (niveau cérébral nul)
  valid=0
  while [ $valid == 0 ]
  do
    dest=$((1 + $RANDOM % 9))
    echo choix ordi:$dest
    # test si vide ?
    #test_coup_valide ${tableau[$dest]}
    test_coup_valide $dest
  done
  tableau[$dest]="O"

  # LEVEL 1
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
    echo "Choix impossible"
  fi
  return $valid
}

choisir_case(){
  valid=0
  while [ $valid == 0 ]
  do
    read -r -p "Quelle case ? " case
    # test si vide ?
    test_coup_valide $case
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

### main
for i in {1..9}
do
  turn=$i
  #echo tour de jeu: $turn
  if [ $J -eq 0 ];then
    echo ordi joue...
    J=1
    ordijoue
  else
    echo joueur joue...
    J=0
    joueurjoue
  fi
  testgagne
done
affiche_tableau


