#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty the tables between runs
TRUNCATE=$($PSQL "TRUNCATE TABLE games, teams;")


# Read the values into variables
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

# Check if WINNER exists, if not, add them
GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #if dont exist
  if [[ -z $GET_WINNER_ID ]]
  # Then add to database
  then
    if [[ $WINNER != "winner" ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
  fi


# Check if OPPONENT exists, if not, add them
GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# If dont exist
  if [[ -z $GET_OPPONENT_ID ]]
  #Then add to database
  then
    if [[ $OPPONENT != "opponent" ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

# Adding the games to the games table
if [[ $YEAR != "year" ]]
then
  INSERT_GAMES=$($PSQL "INSERT INTO games(winner_goals, opponent_goals, year, round, winner_id, opponent_id) VALUES($WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID);")
fi

done