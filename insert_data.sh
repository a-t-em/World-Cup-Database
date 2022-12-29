#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPO WINNER_GOALS OPPO_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPO'")
    if [[ -z $OPPO_ID ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES ('$OPPO')")
      OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPO'")
    fi
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', '$WINNER_ID', '$OPPO_ID', $WINNER_GOALS, $OPPO_GOALS)")
  fi
done
