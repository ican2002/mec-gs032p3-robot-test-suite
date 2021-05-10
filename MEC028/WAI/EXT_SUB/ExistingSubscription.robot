''[Documentation]   robot --outputdir ../../outputs ./ExistingSubscription.robot
...    Test Suite to validate WLAN Information API (EXT_SUB) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

#GET
*** Test Cases ***
TP_MEC_MEC028_SRV_WAI_008_OK
    [Documentation] 
    ...  Check that the IUT responds with the list of Subscription"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve existing subscription information  ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AssocStaSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE}
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URI}
    Should Be Equal As Strings  ${response['body']['apId']['macId']}    ${MAC_ID}
   
TP_MEC_MEC028_SRV_WAI_008_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request for existing subscription with incorrect parameters is sent"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve existing subscription information  ${NOT_EXISTING_SUB_ID}
    Check HTTP Response Status Code Is    404
 

#PUT
*** Test Cases ***
TP_MEC_MEC028_SRV_WAI_009_OK
    [Documentation] 
    ...  Check that the IUT responds with a Notification Subscription when it is modified"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.2
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Modify existing subscription information  ${SUB_ID}   UpdateAssocStaSubscription.json
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AssocStaSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE}
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${NEW_CALLBACK_URI}
    Should Be Equal As Strings  ${response['body']['apId']['macId']}    ${MAC_ID}
   
TP_MEC_MEC028_SRV_WAI_009_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid field is set in the subscription modification request"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.2
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Modify existing subscription information  ${SUB_ID}   UpdateAssocStaSubscription_BR.json
    Check HTTP Response Status Code Is    400

#DELETE
TP_MEC_MEC028_SRV_WAI_010_OK
    [Documentation] 
    ...  Check that the IUT responds with 204 when an existing subscription is correctly deleted"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.5
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Remove existing subscription information  ${SUB_ID}
    Check HTTP Response Status Code Is    204  

TP_MEC_MEC028_SRV_WAI_010_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when an not existing subscription cannot be deleted"
    ...	 Reference "ETSI GS MEC 028 2.1.1, clause 7.6.3.5
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Remove existing subscription information  ${NOT_EXISTING_SUB_ID}
    Check HTTP Response Status Code Is    404  
       
*** Keywords ***
Retrieve existing subscription information
    [Arguments]    ${SUB_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Modify existing subscription information
    [Arguments]    ${SUB_ID}   ${content}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    PUT     ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}  ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Remove existing subscription information
    [Arguments]    ${SUB_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE     ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}