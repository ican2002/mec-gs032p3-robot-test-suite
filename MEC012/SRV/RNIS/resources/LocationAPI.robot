*** Settings ***
Resource    ../environment/variables.txt
Resource    LocationAPI.robot
#Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/

*** Keywords ***
Check Location
    [Arguments]    ${value}
    Log    Check Location for userInfo element
    Should be Equal    ${response['body']['userInfo']['zoneId']}    ${value}
    Log    Location OK
