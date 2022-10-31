#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if agument empty
if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else
  #get atomic number from arguments 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  
  #if atomic number not character
  if [[ -z $ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  fi

  #if no atomic number can be found
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo I could not find that element in the database.
  else
    #get other information
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE properties.atomic_number = $ATOMIC_NUMBER")
    ATOMIC_WEIGHT=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

    #remove whitespaces
    ATOMIC_NUMBER_FORMAT=$(echo $ATOMIC_NUMBER | sed 's/ *//g')
    NAME_FORMAT=$(echo $NAME | sed 's/ *//g')
    SYMBOL_FORMAT=$(echo $SYMBOL | sed 's/ *//g')
    TYPE_FORMAT=$(echo $TYPE | sed 's/ *//g')
    ATOMIC_WEIGHT_FORMAT=$(echo $ATOMIC_WEIGHT | sed 's/ *//g')
    MELTING_POINT_FORMAT=$(echo $MELTING_POINT | sed 's/ *//g')
    BOILING_POINT_FORMAT=$(echo $BOILING_POINT | sed 's/ *//g')

    #Print it all out
    echo -e "The element with atomic number $ATOMIC_NUMBER_FORMAT is $NAME_FORMAT ($SYMBOL_FORMAT). It's a $TYPE_FORMAT, with a mass of $ATOMIC_WEIGHT_FORMAT amu. $NAME_FORMAT has a melting point of $MELTING_POINT_FORMAT celsius and a boiling point of $BOILING_POINT_FORMAT celsius."
  fi
fi
