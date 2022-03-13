#!/bin/bash

# déclaration d'une fonction
function maFonction() 
{ local varlocal="je suis la fonction"
  echo "$varlocal"
  echo "Nombres de paramètres : $#"
  echo $1
  echo $2
}

# appel de ma fonction
maFonction "HELL0" "World!"