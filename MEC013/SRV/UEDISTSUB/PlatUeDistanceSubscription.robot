*** Settings ***

Documentation
...    A test suite for validating UE Distance Subscribe (UEDISTSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem   

Default Tags    TC_MEC_SRV_UEDISTSUB


*** Test Cases ***

TC_MEC_MEC013_SRV_UEDISTSUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE distance subscription request when commanded by a
    ...    MEC Application and notifies it when (all) the requested UE(s) is (are) within the specified distance
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.10
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    DistanceNotificationSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    DistanceNotificationSubscription
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    clientCorrelator    ${UEDISTSUB_CLIENT_ID}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    callbackReference    ${APP_SRVSUB_NOTIF_CALLBACK_URI}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    monitoredAddress    ${UEDISTSUB_MONITORED_IP_ADDRESS}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    referenceAddress    ${UEDISTSUB_IP_ADDRESS}


TC_MEC_MEC013_SRV_UEDISTSUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.10

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    DistanceNotificationSubscriptionError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC013_SRV_UEDISTSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE distance notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove subscription    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC013_SRV_UEDISTSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404

*** Keywords ***
Create new subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Remove subscription  
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}