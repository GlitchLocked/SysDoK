#!/bin/bash

# ___________________________________________________

echo -n "Entre le nom d'un pays : "
read COUNTRY

echo -n "La langue officiel en $COUNTRY is "

case $COUNTRY in

  Lithuania)
    echo -n "Lithuanian"
    ;;

  Romania | Moldova)
    echo -n "Romanian"
    ;;

  Italy | "San Marino" | Switzerland | "Vatican City")
    echo -n "Italian"
    ;;

  *)
    echo -n "unknown"
    ;;
esac

# ___________________________________________________

nom="Jack"

if [ $nom = "Jack" ]
then
        echo "Salut Jack !"
elif [ encore_autre_test ]
then
        echo "Le deuxieme test a été vérifié"
else
        echo "Aucun des tests précédents n'a été vérifié"
fi