*** Settings ***

Documentation
...    A test suite for validating UE Tracking Subscribe (UETRACKSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem  

Default Tags    TC_MEC_SRV_UETRACKSUB


*** Test Cases ***

TC_MEC_MEC013_SRV_UETRACKSUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE location change subscription request
    ...    when commanded by a MEC Application and notifies it when the UE changes location
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.8
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    PeriodicNotificationSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    periodicNotificationSubscription
    Check Result Contains    ${response['body']['periodicNotificationSubscription']}    clientCorrelator    ${UE_PERIODIC_SUB_CLIENT_ID}
    Check Result Contains    ${response['body']['periodicNotificationSubscription']}    callbackReference    ${UE_PERIODIC_NOTIF_CALLBACK_URI}
    Check Result Contains    ${response['body']['periodicNotificationSubscription']}    address    ${UE_PERIODIC_IP_ADDRESS}
    
    # TODO how to send this? The TP has the IUT doing this immediately. Do we want this or will it be discarded as part of the test?
    # // MEC 013, clause 7.3.8.3
    # the IUT entity sends a vPOST containing
    # uri indicating value CALLBACK_URL 
    # body containing
    # subscriptionNotification containing
    # terminalLocation containing
    # address set to IP_ADDRESS
    # ;
    # ;
    # ;
    # ;


TC_MEC_MEC013_SRV_UETRACKSUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.4
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    PeriodicNotificationSubscriptionError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC013_SRV_UETRACKSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE tracking notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove subscription    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC013_SRV_UETRACKSUB_002_NF
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
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/periodic     ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Remove subscription  
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/periodic/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}