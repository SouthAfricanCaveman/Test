#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

RANDOM_NUMBER=$((1 + $RANDOM % 1000))

#get username
echo "Enter your username:"
read USERNAME

#check for user in database
USER=$($PSQL "SELECT username FROM game WHERE username='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM game WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM game WHERE username='$USERNAME'")

#check if user exists
if [[ -z $USER ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
  USER_INSERT_RESULT=$($PSQL "INSERT INTO game(username) VALUES('$USERNAME')")
else
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

#guess the number
GUESS=1
echo "Guess the secret number between 1 and 1000:"

#get input
while read NUMBER_GUESS
do
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $NUMBER_GUESS -eq $RANDOM_NUMBER ]]
    then
      break
    else
      if [[ $NUMBER_GUESS -gt $RANDOM_NUMBER ]]
      then
        echo -n "It's lower than that, guess again:"
      elif [[ $NUMBER_GUESS -lt $RANDOM_NUMBER ]]
      then
        echo -n "It's higher than that, guess again:"
      fi
    fi
  fi
  GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]; then
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
else
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi

GAME_ID=$($PSQL "SELECT game_id FROM game WHERE username = '$USERNAME'")
UUPDATE_GAME_PLAYED=$($PSQL "UPDATE game SET games_played = $GAMES_PLAYED + 1, best_game = $GUESS ")
