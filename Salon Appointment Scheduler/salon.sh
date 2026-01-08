#! /bin/bash

#Salon Appointment Scheduler

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo "~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICE=$($PSQL "SELECT service_id, name FROM services")
  echo -e "\n$SERVICE" | sed 's/|/) /'
  read SERVICE_ID_SELECTED

  #get service_id
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  #if service not exist
  if [[ -z $SERVICE_ID ]]
  then
    #back to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    #get phone
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    PHONE_RESULT=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    #if phone not exist
    if [[ -z $PHONE_RESULT ]]
    then
      #get new name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      #insert cutomer
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      if [[ $CUSTOMER_INSERT_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserted: $CUSTOMER_PHONE $NAME"
      fi
    else
      #get name
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
    
    #get service name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")

    #get time
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")

    #insert new appointment
    APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    if [[ $APPOINTMENT_INSERT_RESULT == 'INSERT 0 1' ]]
      then
        echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
  fi
}

MAIN_MENU

