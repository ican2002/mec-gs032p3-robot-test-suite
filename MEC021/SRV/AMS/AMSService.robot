''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${AMS_SCHEMA}://${AMS_HOST}:${AMS_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary




*** Test Cases ***
TC_MEC_MEC021_SRV_AMS_001_OK
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Registered AMS information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppMobilityServiceInfos


TC_MEC_MEC021_SRV_AMS_002_OK
    [Documentation]   Request Registered AMS information using attribute-selector
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Registered AMS information using attribute-selector    appMobilityServiceId    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppMobilityServiceInfos
    Check Result Contains    ${response['body']['AppMobilityServiceInfo']}    appMobilityServiceId    ${APP_MOBILITY_SERVICE_ID}
    

TC_MEC_MEC021_SRV_AMS_001_BR
    [Documentation]    Request Registered AMS information using bad parameters
    ...  Check that the AMS service returns an error when receives a query about a registered application mobility service with wrong parameters
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Registered AMS information using bad parameters
    Check HTTP Response Status Code Is    400


TC_MEC_MEC021_SRV_AMS_003_OK
    [Documentation]   Register a new application mobility services
    ...  Check that the AMS service creates a new application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Create a new application mobility service      RegistrationInfo
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo
    Log    Checking Postcondition
    Check Result Contains    ${response['body']['AppMobilityServiceInfo']['registeredAppMobilityService']['serviceConsumerId']['']}    appInstanceId    ${APP_INS_ID}
    

TC_MEC_MEC021_SRV_AMS_003_BR
    [Documentation]   Register an UE Identity Tag using invalid parameter
    ...  Check that the AMS service sends an error when it receives a malformed request to create a new application mobility service
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Create a new application mobility service    RegistrationInfoMalformed
    Check HTTP Response Status Code Is    400


TC_MEC_MEC021_SRV_AMS_004_OK
    [Documentation]   Request Subscriptions List for the registered AMS services
    ...  Check that the AMS service returns information about the available subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Subscriptions for registered AMS
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList



TC_MEC_MEC021_SRV_AMS_004_BR
    [Documentation]   Request Subscription List for registered AMS Services using wrong attribute parameters
    ...  Check that the AMS service sends an error when it receives a malformed query about the available subscriptions
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Subscriptions for registered AMS with wrong attbirube parameter
    Check HTTP Response Status Code Is    400



TC_MEC_MEC021_SRV_AMS_005_OK
    [Documentation]   Create a notification subscription
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Post a new notification subscription    NotificationSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NotificationSubscription
    

TC_MEC_MEC021_SRV_AMS_005_BR
    [Documentation]   Create a notification subscription with wrong attribute parameter
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Post a new notification subscription    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400



TC_MEC_MEC021_SRV_AMS_006_OK
    [Documentation]   Request a specific subscription
    ...  Check that the AMS service returns information about a given subscription when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription



TC_MEC_MEC021_SRV_AMS_006_NF
    [Documentation]   Request a specific subscription using wrong identifier
    ...  Check that the AMS service returns an error when receives a query about a not existing subscription
    ...     ETSI GS MEC 021 2.0.8, clause 8.7.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC021_SRV_AMS_007_OK
    [Documentation]   Modify a specific subscription
    ...  Check that the AMS service modifies a given subscription when requested.
    ...  Permitted SUBSCRIPTION_TYPE are:
    ...    - MobilityProcedureSubscription
    ...    - AdjacentAppInfoSubscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription



TC_MEC_MEC021_SRV_AMS_007_BR
    [Documentation]   Modify a specific subscription using malformed request
    ...  Check that the AMS service sends an error when it receives a malformed modify request for a given subscription.
    ...  Permitted SUBSCRIPTION_TYPE are:
    ...    - MobilityProcedureSubscription
    ...    - AdjacentAppInfoSubscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400


TP_MEC_MEC021_SRV_AMS_007_NF
    [Documentation]   Modify a specific subscription using wrong identifier
    ...  Check that the AMS service sends an error when it receives a modify request for a not existing subscription.
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    404


TC_MEC_MEC021_SRV_AMS_008_OK
    [Documentation]   Remove a specific subscription
    ...  Check that the AMS service deletes a given subscription when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC021_SRV_AMS_008_NF
    [Documentation]   Remove a specific subscription using wrong identifier
    ...  Check that the AMS service sends an error when it receives a delete request for a not existing subscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC021_SRV_AMS_009_OK
    [Documentation]   Post Mobility Procedure Notification
    ...  Check that the AMS service sends an AMS notification  about a mobility procedure 
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    ${json}=	Get File	schemas/MobilityProcedureNotification.schema.json
    Log  Creating mock request and response to handle  Mobility Procedure Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 
    


TC_MEC_MEC021_SRV_AMS_010_OK
    [Documentation]   Post Adjacent Application Info Notification
    ...  Check that the AMS service sends an AMS notification about adjacent application instances 
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.3
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    ${json}=	Get File	schemas/AdjacentAppInfoNotification.schema.json
    Log  Creating mock request and response to handle Adjacent Application Info Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 



TC_MEC_MEC021_SRV_AMS_011_OK
    [Documentation]   Post Expire Notification
    ...  Check that the AMS service sends an AMS notification on subscription expiration
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    ${json}=	Get File	schemas/ExpiryNotification.schema.json
    Log  Creating mock request and response to handle Expire Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 



TC_MEC_MEC021_SRV_AMS_012_OK
    [Documentation]   Request a specific AMS service
    ...  Check that the AMS service returns information about this individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo



TC_MEC_MEC021_SRV_AMS_012_NF
    [Documentation]   Request a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when receives a query about a not existing individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404



TC_MEC_MEC021_SRV_AMS_013_OK
    [Documentation]   Modify a specific AMS service
    ...  Check that the AMS service modifies the individual application mobility service when requested
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${APP_MOBILITY_SERVICE_ID}     RegistrationInfo 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo
    Check Result Contains  ${response['registeredAppMobilityService']['serviceConsumerId']}  appInstanceId  ${APP_INS_ID}



TC_MEC_MEC021_SRV_AMS_013_NF
    [Documentation]   Modify a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when receives a request to modify a not existing individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}    RegistrationInfo 
    Check HTTP Response Status Code Is    404


TC_MEC_MEC021_SRV_AMS_013_BR
    [Documentation]   Modify a specific AMS Service using bad parameters
    ...  Check that the AMS service sends an error when receives a request to modify a individual application mobility service using bad parameters
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${APP_MOBILITY_SERVICE_ID}     RegistrationInfoWithError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC021_SRV_AMS_014_OK
    [Documentation]   Remove a specific AMS service
    ...  Check that the AMS service de-register the individual application mobility service and delete the resource
    ...  that represents the individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC021_SRV_AMS_014_NF
    [Documentation]   Remove a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when is requested to delete the resource
	...		that represents the individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.4.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404



TC_MEC_MEC021_SRV_AMS_015_OK
    [Documentation]   Request to deregister a specific AMS service
    ...  Check that the AMS service deregister an individual application mobility service on expiry of the timer associated with the service
    ...  ETSI GS MEC 021 2.0.10, clause 8.5.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Deregister specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    204



TC_MEC_MEC021_SRV_AMS_015_NF
    [Documentation]   Request to deregister a specific AMS service using non existent identifier
    ...  Check that the AMS service send an error when is requested to deregister a not existent individual application mobility service
    ...  ETSI GS MEC 021 2.0.10, clause 8.5.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Deregister specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404

*** Keywords ***
Get Registered AMS information
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get Registered AMS information using attribute-selector
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices/${amsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Get Registered AMS information using bad parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices?appMobilityService=${APP_MOBILITY_SERVICE_ID}     //param should be appMobilityServiceId
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Modify a specific AMS service
    [Arguments]     ${amsId}     ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices/${amsId}   ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Delete specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices/${amsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Deregister specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices/${amsId}/deregisterTask
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Create a new application mobility service
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Get Subscriptions for registered AMS    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get Subscriptions for registered AMS with wrong attbirube parameter
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscriptionTyp=${SUBSCRIPTION_TYPE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Post a new notification subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get individual subscription for AMS services
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    

Delete individual subscription for AMS services 
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}      


Update individual subscription for AMS services
    [Arguments]    ${identifier}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${identifier}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    