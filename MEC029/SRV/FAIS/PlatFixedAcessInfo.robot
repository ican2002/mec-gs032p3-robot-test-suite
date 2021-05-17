*** Settings ***

Documentation
...    A test suite for validating Fixed Access Information Service (FAIS) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem
Library     MockServerLibrary    


Default Tags    TC_MEC_SRV_FAIS



*** Test Cases ***
TC_MEC_MEC029_SRV_FAIS_001_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the fixed access information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get fixed access information details
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FaInfo


TC_MEC_MEC029_SRV_FAIS_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get fixed access information details using query prameters    interface    ${INTERFACE_ID}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get fixed access information details using query prameters    interfaceType    ${NON_EXISTENT_INTERFACE_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_002_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the device information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of device information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    DeviceInfo


TC_MEC_MEC029_SRV_FAIS_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of device information using query prameters    device    ${DEVICE_ID}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of device information using query prameters    deviceId    ${NON_EXISTENT_DEVICE_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_003_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the cable line information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the cable line information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    CableLineInfo


TC_MEC_MEC029_SRV_FAIS_003_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the cable line information using query parameters    cm    ${CABLE_MODEM_ID}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the cable line information using query parameters    cmId    ${NON_EXISTING_FAI_CM_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_004_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the optical network information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the opentical network information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PonInfo


TC_MEC_MEC029_SRV_FAIS_004_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the opentical network information using query parameters    onu    ${ONU_ID}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get status of the opentical network information using query parameters    onuId    ${NON_EXISTING_FAI_ONU_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_005_OK
    [Documentation]
    ...    Check that the IUT responds with the subscriptions for fixed access information notifications
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList


TC_MEC_MEC029_SRV_FAIS_005_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of subscriptions using query parameters    subscription    ${SUBSCRIPTION_TYPE}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_005_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of subscriptions using query parameters    subscriptionType    ${NON_EXISTENT_SUBSCRIPTION_TYPE}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_006_OK
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application
    ...    to notifications on Optical Network Unit alarm events
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new subscription    OnuAlarmSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    OnuAlarmSubscription



TC_MEC_MEC029_SRV_FAIS_006_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new subscription    OnuAlarmSubscriptionError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_007_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a given subscription
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get an individual subscription     ${ONU_ALARM_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    OnuAlarmSubscription


TC_MEC_MEC029_SRV_FAIS_007_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get an individual subscription     ${NON_ESISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_008_OK
    [Documentation]
    ...    Check that the IUT updates an existing subscription
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update subscription    ${ONU_ALARM_SUBSCRIPTION_ID}    OnuAlarmSubscriptionUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    OnuAlarmSubscription


TC_MEC_MEC029_SRV_FAIS_008_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update subscription    ${ONU_ALARM_SUBSCRIPTION_ID}    OnuAlarmSubscriptionUpdateError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC029_SRV_FAIS_008_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update subscription    ${NON_ESISTENT_SUBSCRIPTION_ID}    OnuAlarmSubscriptionUpdate
    Check HTTP Response Status Code Is    404


TC_MEC_MEC029_SRV_FAIS_008_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update subscription using invalid etag    ${ONU_ALARM_SUBSCRIPTION_ID}    OnuAlarmSubscriptionUpdate
    Check HTTP Response Status Code Is    412


TC_MEC_MEC029_SRV_FAIS_009_OK
    [Documentation]
    ...    Check that the IUT cancels an existing subscription
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove subscription    ${ONU_ALARM_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC029_SRV_FAIS_010_OK
    [Documentation]
    ...    Check that the IUT sends notification on expiry of Fixed Access Information event subscription
    ...    to a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    ${json}=	Get File	schemas/DevInfoSubscription.schema.json
    Log  Creating mock request and response to handle  Device Information Notifications
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 


TC_MEC_MEC029_SRV_FAIS_011_OK
    [Documentation]
    ...    Check that the IUT sends notifications on Fixed Access Information events
    ...    to a subscribed MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 5.2.7

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    ${json}=	Get File	schemas/OnuAlarmSubscription.schema.json
    Log  Creating mock request and response to handle  Onu Alarm Notifications
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 



*** Keywords ***
Get fixed access information details
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/fa_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get fixed access information details using query prameters
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/fa_info?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of device information
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/device_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of device information using query prameters
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/device_info?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of the cable line information
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/cable_line_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of the cable line information using query parameters
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/cable_line_info?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of the opentical network information
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/optical_network_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get status of the opentical network information using query parameters
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/optical_network_info?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get list of subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get list of subscriptions using query parameters
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Create a new subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get an individual subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Update subscription    
    [Arguments]    ${subscriptionId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update subscription using invalid etag
    [Arguments]    ${subscriptionId}    ${content}
    Set Headers    {"If-Match": "${INVALID_ETAG}"}
    
Remove subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}