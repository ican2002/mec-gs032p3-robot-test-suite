''[Documentation]   robot --outputdir ../../outputs ./WaiSubscription.robot
...    Test Suite to validate WLAN Information API (SUB) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

*** Test Cases ***
TP_MEC_MEC028_SRV_WAI_005_OK
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the subscription information    ${SUB_FILTER}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    FOR    ${assocStaSub}    IN    @{response['body']['assocStaSubscription']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${assocStaSub['_links']['self']['href']}    ${HREF}    
        Exit For Loop If    ${passed}
    END

TP_MEC_MEC028_SRV_WAI_006_OK
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the subscription information    ${SUB_FILTER}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    Should Be Equal As Strings  ${response['body']['_links']['self']['href']}    ${HREF}
        
TP_MEC_MEC028_SRV_WAI_006_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the subscription information    ${INVALID_SUB_FILTER}
    Check HTTP Response Status Code Is    400
  
TP_MEC_MEC028_SRV_WAI_006_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when	a request with not existing parameters is sent
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Retrieve the subscription information using wrong endpoint
    Check HTTP Response Status Code Is    404   
    
TP_MEC_MEC028_SRV_WAI_007_OK
    [Documentation] 
    ...  Check that the IUT responds with a Notification Subscription
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.4
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Send a request for creating a subscription  AssocStaSubscription.json
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AssocStaSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE}
    Should Be Equal As Strings  ${response['body']['_links']['self']['href']}    ${HREF}
    Should Be Equal As Strings  ${response['headers']['Location']}    ${HREF}
    
TP_MEC_MEC028_SRV_WAI_007_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid Subscription request is sent
    ...  ETSI GS MEC 028 2.1.1, clause 7.5.3.4
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/AssocStaSubscription
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Send a request for creating a subscription  AssocStaSubscription_BR.json
    Check HTTP Response Status Code Is    400

TP_MEC_MEC028_SRV_WAI_007_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with not existing parameters is sent
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.5.3.1
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Send a request for creating a subscription using wrong endpoint  AssocStaSubscription.json
    Check HTTP Response Status Code Is    404

      
*** Keywords ***
Send a request for creating a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    Log    ${body}   
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Send a request for creating a subscription using wrong endpoint  
    [Arguments]    ${content}
    Log    Creating a new subscription
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions_INVALID_URI    ${body} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Retrieve the subscription information
    [Arguments]    ${subscription_type}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscription_type=${subscription_type}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Retrieve the subscription information using wrong endpoint
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions_INVALID_URI
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}