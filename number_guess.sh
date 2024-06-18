#!/bin/bash



PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c";



echo "Enter your username:";



read USER_NAME_WRITTEN;



DB_USER_NAME=$($PSQL "SELECT name FROM users WHERE name='$USER_NAME_WRITTEN'");
DB_USER_ID=$($PSQL "SELECT id FROM users WHERE name='$USER_NAME_WRITTEN'");



RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ));



NUMBER_OF_GUESSES_IT_TOOK=0;



#************************************* For New Users ********************************************************* 
if [[ -z $DB_USER_NAME ]]
then
    INSERTED_USER_NAME=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME_WRITTEN')");
    INSERTED_USER_ID=$($PSQL "SELECT id FROM users WHERE name='$USER_NAME_WRITTEN'");



    echo "Welcome, $USER_NAME_WRITTEN! It looks like this is your first time here.";



    echo "Guess the secret number between 1 and 1000:"



    # While loop start
    while [[ true ]]
    do



    read GUESSED_NUMBER;



    if [[ ! $GUESSED_NUMBER =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:";
        continue
    fi



    NUMBER_OF_GUESSES_IT_TOOK=$((NUMBER_OF_GUESSES_IT_TOOK + 1));



    if [[ $GUESSED_NUMBER -gt $RANDOM_NUMBER ]]
    then

        echo "It's lower than that, guess again:";

    fi



    if [[ $GUESSED_NUMBER -lt $RANDOM_NUMBER ]]
    then

        echo "It's higher than that, guess again:";

    fi



    if [[ $GUESSED_NUMBER -eq $RANDOM_NUMBER ]]
    then



        echo "You guessed it in $NUMBER_OF_GUESSES_IT_TOOK tries. The secret number was $RANDOM_NUMBER. Nice job!";



        $PSQL "INSERT INTO games(user_id , count) VALUES($INSERTED_USER_ID, $NUMBER_OF_GUESSES_IT_TOOK)";



        break;



    fi



    done



#************************************* For Existing Users ********************************************************* 
    else 



    NUMBER_OF_GAMES_PLAYED=$($PSQL "SELECT COUNT(id) FROM games WHERE user_id='$DB_USER_ID'");
    BEST_GAME_PLAYED=$($PSQL "SELECT MIN(count) FROM games WHERE user_id='$DB_USER_ID'");



    echo "Welcome back, $DB_USER_NAME! You have played $NUMBER_OF_GAMES_PLAYED games, and your best game took $BEST_GAME_PLAYED guesses.";



    echo "Guess the secret number between 1 and 1000:"



    # While loop start
    while [[ true ]]
    do



    read GUESSED_NUMBER;



    
    if [[ ! $GUESSED_NUMBER =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:";
        continue
    fi



    NUMBER_OF_GUESSES_IT_TOOK=$((NUMBER_OF_GUESSES_IT_TOOK + 1));



    if [[ $GUESSED_NUMBER -gt $RANDOM_NUMBER ]]
    then

        echo "It's lower than that, guess again:";

    fi



    if [[ $GUESSED_NUMBER -lt $RANDOM_NUMBER ]]
    then

        echo "It's higher than that, guess again:";

    fi



    if [[ $GUESSED_NUMBER -eq $RANDOM_NUMBER ]]
    then



        echo "You guessed it in $NUMBER_OF_GUESSES_IT_TOOK tries. The secret number was $RANDOM_NUMBER. Nice job!";



        $PSQL "INSERT INTO games(user_id , count) VALUES($DB_USER_ID, $NUMBER_OF_GUESSES_IT_TOOK)";



        break;



    fi



    done;     



fi
