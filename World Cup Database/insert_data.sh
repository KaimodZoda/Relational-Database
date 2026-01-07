#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#clear current contents and reset indexes 
echo $($PSQL "TRUNCATE TABLE games, teams, games RESTART IDENTITY")

#read csv and define variables
cat games.csv | tail -n +2 | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Insert teams to teams
  #insert teams from winner
  #get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

  #if team not exist
  if [[ -z $TEAM_ID ]]
  then
    #insert team
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted team: $WINNER"
    fi  
  fi

  #insert team from opponent
  #get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  #if team not exist
  if [[ -z $TEAM_ID ]]
  then
    #insert team
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted team: $OPPONENT"
    fi  
  fi
  
  # insert into games
  #get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  #get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
        echo "Inserted game: $YEAR $ROUND - $WINNER vs $OPPONENT $WINNER_GOALS : $OPPONENT_GOALS"
  fi  
done