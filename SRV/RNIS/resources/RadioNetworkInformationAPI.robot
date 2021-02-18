*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Check Subscription
    [Arguments]    ${received_value}    ${expected_value}
    Should Be Equal    ${received_value['_links']['self']}    ${LINKS_SELF}
    ${length}    Get Length    ${received_value['subscription']}
    :FOR  ${item}  IN RANGE    0    ${length} 
    \  Exit For Loop If    ${received_value['subscription'][${item}]} == ${expected_value}
    Log    Item found ${received_value['subscription'][${item}]}
    [return]    ${received_value['subscription'][${item}]}


Check CellChangeSubscription
    [Arguments]    ${received_value}
    Should Be Equal    ${received_value['_links']['self']['href']}    ${LINKS_SELF}


Check RabInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Not Be Empty    ${received_value['requestId']}
    Run Keyword If    'cellUserInfo' in ${received_value}    Should Be Equal As Strings    ${received_value['cellUserInfo'][0]['ecgi']['cellId']}    ${CELL_ID}

Check PlmnInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Be Equal As Strings   ${received_value['appInstanceId']}    ${APP_INS_ID}
    Should Not Be Empty    ${received_value['plmn'][0]['mcc']}    
    Should Not Be Empty    ${received_value['plmn'][0]['mnc']}    


Check S1BearerInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Be Equal As Strings    ${received_value['s1UeIffo']['ecgi']['cellId']}    ${CELL_ID}
    
Check L2MeasInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Be Equal As Strings    ${received_value['cellInfo'][0]['ecgi']['cellId']}    ${CELL_ID}
