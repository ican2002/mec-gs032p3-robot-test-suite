''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary


*** Test Cases ***
TC_MEC_MEC010p2_MEPM_PKGM_001_OK
    [Documentation]    TP_MEC_MEPM_PKGM_001_OK
    ...    Check that MEPM returns the list of App Packages when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.1.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.3.2-1 (OnboardedAppPkgInfo)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all APP Packages
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   OnboardedAppPkgInfos
    Check Result Contains    ${response}    appPkgId    ${ON_BOARDED_APP_PKG_ID}
    Check Result Contains    ${response}    appDId    ${APPD_ID}


TC_MEC_MEC010p2_MEPM_PKGM_001_BR
    [Documentation]    TP_MEC_MEPM_PKGM_001_BR
    ...    Check that MEPM responds with an error when it receives 
    ...    a malformed request for requesting the list of existing App Packages
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.1.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all APP Packages with filters    ${MALFORMED_FILTER_NAME}    ${FILTER_VALUE}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC010p2_MEPM_PKGM_002_OK
    [Documentation]    TP_MEC_MEPM_PKGM_002_OK
    ...    Check that MEPM returns the an App Package when requested
    ...    EETSI GS MEC 010-2 2.0.10, clause 7.4.2.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.3.2-1 (OnboardedAppPkgInfo)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an APP Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   OnboardedAppPkgInfo
    Check Result Contains    ${response}    appPkgId    ${ON_BOARDED_APP_PKG_ID}
    Check Result Contains    ${response}    appDId    ${APPD_ID}       

 
TC_MEC_MEC010p2_MEPM_PKGM_002_NF
    [Documentation]    TP_MEC_MEPM_PKGM_002_NF
    ...    Check that MEPM responds with an error when it receives
    ...    a request for returning a App Package referred with a wrong ID
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.2.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an APP Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404   
    
    
 
TC_MEC_MEC010p2_MEPM_PKGM_003_OK
    [Documentation]    TP_MEC_MEPM_PKGM_003_OK
    ...    Check that MEPM returns the Application Descriptor contained on a on-boarded Application Package when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.4.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an AppD from App Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Contain Header with value    Content-Type    ${ACCEPTED_CONTENT_TYPE}
    ##TODO: How to check content returned?    
    

TC_MEC_MEC010p2_MEPM_PKGM_003_NF
    [Documentation]    TP_MEC_MEPM_PKGM_003_NF
    ...    Check that MEPM responds with an error when it receives
    ...    a request for returning a App Descriptor referred with a wrong App Package ID
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.4.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an AppD from App Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404
    
    
TC_MEC_MEC010p2_MEPM_PKGM_004_OK
    [Documentation]    TP_MEC_MEPM_PKGM_004_OK
    ...    Check that MEPM returns the content on a on-boarded Application Package when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.3.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get the Content from an App Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    ##TODO: How to check content returned?    

TC_MEC_MEC010p2_MEPM_PKGM_004_NF
    [Documentation]    TP_MEC_MEPM_PKGM_004_NF
    ...    Check that MEPM responds with an error when it receives 
    ...    a request for returning a application package content referred with a wrong App Package ID
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.4.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get the Content from an App Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC010p2_MEPM_PKGM_005_OK
    [Documentation]    TP_MEC_MEPM_PKGM_005_OK
    ...    Check that MEPM service returns an application package subscription when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.5.3.1
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.7.2-1 (AppPkgSubscription)
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.4.2-1 (AppPkgSubscriptionInfo)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppPkgSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Check Result Contains    ${response}    subscriptionType    ON_BOARDING
    Check Result Contains    ${response}    callbackUri    ${CALLBACK_URI}


TC_MEC_MEC010p2_MEPM_PKGM_005_BR
    [Documentation]    TP_MEC_MEPM_PKGM_005_BR
    ...    Check that MEPM service sends an error when it receives a 
    ...    malformed request for creating a new subscription on AppPackages
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.5.3.1
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.7.2-1 (AppPkgSubscription)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    MalformedAppPkgSubscription
    Check HTTP Response Status Code Is    400


TC_MEC_MEC010p2_MEPM_PKGM_006_OK
   [Documentation]    TP_MEC_MEPM_PKGM_006_OK
    ...    Check that MEPM service returns the list of Application Package Subscriptions when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.5.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.4.2-1 (AppPkgSubscriptionLinkList)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get all APP Package subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionLinkList
    Check Result Contains    ${response}    subscriptionId    ${SUBSCRIPTION_ID}


TC_MEC_MEC010p2_MEPM_PKGM_007_OK
    [Documentation]    TP_MEC_MEPM_PKGM_007_OK
    ...    Check that MEPM service returns an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.6.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.3.4.2-1 (AppPkgSubscriptionInfo)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual APP Package subscriptions    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Check Result Contains    ${response}    subscriptionId    ${SUBSCRIPTION_ID}


TC_MEC_MEC010p2_MEPM_PKGM_007_NF
    [Documentation]    TP_MEC_MEPM_PKGM_007_NF
    ...    Check that MEPM service sends an error when it receives a query for a subscription
    ...    on AppPackages with a wrong identifier
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.6.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual APP Package subscriptions    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEPM_PKGM_008_OK
    [Documentation]    TP_MEC_MEPM_PKGM_008_OK
    ...    Check that MEPM service deletes an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.6.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an App Package Subscription identified by    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty


TC_MEC_MEC010p2_MEPM_PKGM_008_NF
    [Documentation]    TP_MEC_MEPM_PKGM_008_NF
    ...    Check that MEPM service sends an error when it receives a deletion 
    ...    request for a subscription on AppPackages with a wrong identifier
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.4.6.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an App Package Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEPM_PKGM_009_OK
    [Documentation]   TP_MEC_MEPM_PKGM_009_OK
    ...  Check that the MEPM service sends a application package notification 
    ...  if the MEPM service has an associated subscription and the event is generated
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.4.7.3.1
    ${json}=	Get File	schemas/AppPkgNotification.schema.json
    Log  Creating mock request and response to handle  Application Package Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}     

*** Keywords ***
GET all APP Packages
    Log    Getting all App Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
    
GET all APP Packages with filters
    [Arguments]    ${key}    ${value}
    Log    Getting all App Packages using filtering parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
GET an APP Package identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
   
Get an AppD from App Package identified by
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/app_descriptor
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Send a request for a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}       



Get all APP Package subscriptions
    Log    Getting list of subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Get an individual APP Package subscriptions
    [Arguments]    ${subId}
    Log    Getting an individual subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Delete an App Package Subscription identified by
    [Arguments]    ${subId}
    Log    Deleting a subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Get the Content from an App Package identified by
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/appPkgContent
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 