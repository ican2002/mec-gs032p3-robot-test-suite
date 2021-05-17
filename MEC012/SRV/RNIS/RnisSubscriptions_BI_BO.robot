''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BI_BO.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_011_BR
    [Documentation]   Request RNIS subscription list using bad parameters
    ...  Check that the RNIS service responds with an error when it receives a request to get all RNIS subscriptions with a wrong subscription type
    ...  ETSI GS MEC 012 2.1.1, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml#/definitions/SubscriptionLinkList
    Get RNIS subscription list with wrong parameter
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC012_SRV_RNIS_012_BR
    [Documentation]   Create RNIS subscription using bad parameters
    ...  Check that the RNIS service responds with an error when it receives a request to create a new RNIS subscription with a wrong format
    ...  ETSI GS MEC 012 2.1.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Post RNIS subscription request    {"CellChangeSubscription": {"subscriptionType": "CelCangeSubscription", "callbackReference": "${HREF}", "_links": {"self": { "href": "${LINKS_SELF}" } }, "filterCriteria": {"appInsId": "01", "associateId": [{"type": "UE_IPV4_ADDRESS", "value": 1}], "plmn": {"mcc": "01", "mnc": "001"}, "cellId": ["800000"], "hoStatus": "COMPLETED"}, "expiryDeadline": {"seconds": 1577836800, "nanoSeconds": 0}}}
    Check HTTP Response Status Code Is    400

*** Keywords ***
Get RNIS subscription list with wrong parameter
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions?subscription_type=wrongSubscriptionType
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Post RNIS subscription request
    [Arguments]    ${content}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/rni/${apiVersion}/subscriptions    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
