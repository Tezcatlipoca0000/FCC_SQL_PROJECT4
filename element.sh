PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1';")
    NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1';")
  fi

  if [[ ! -z $ATOMIC_NUMBER ]]
  then
    #echo oiiiiiii $ATOMIC_NUMBER, $SYMBOL and $NAME
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
  elif [[ ! -z $SYMBOL ]]
  then 
    #echo oiiiiiii $SYMBOL, $ATOMIC_NUMBER and $NAME
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL';")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL';")
  elif [[ ! -z $NAME ]]
  then
    #echo oiiiiiiii $NAME, $SYMBOL and $ATOMIC_NUMBER
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$NAME';")
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME';")
  fi

  if [[ -z $ATOMIC_NUMBER && -z $SYMBOL && -z $NAME ]]
  then
    echo I could not find that element in the database.
  else
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi