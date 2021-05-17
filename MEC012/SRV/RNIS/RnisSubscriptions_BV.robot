''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BV.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Library    OperatingSystem
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library     String


*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_011_OK
    [Documentation]   Request RNIS subscription list
    ...  Check that the RNIS service sends the list of links to the relevant RNIS subscriptions when requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml#/definitions/SubscriptionLinkList
    Get RNIS subscription list
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    # The following step is faulty in the design, thus it is commented. It is kept since
    # it is required by the Test Purpose TP_MEC_SRV_RNIS_011_OK
    # Check Subscription    ${response['body']}    ${SUBSCRIPTION_VALUE}


TC_MEC_MEC012_SRV_RNIS_012_OK
    [Documentation]   Create RNIS subscription
    ...  Check that the RNIS service creates a new RNIS subscription
    ...  ETSI GS MEC 012 2.1.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Post RNIS subscription request    CellChangeSubscriptionRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   CellChangeSubscription
    Check CellChangeSubscription    ${response['body']}


TC_MEC_MEC012_SRV_RNIS_013_OK
    [Documentation]    Get an Individual RNIS subscription
    ...    Check that the RNIS service sends a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.1.1, clause 7.8.3.1
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Get Individual RNIS Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   CellChangeSubscription


TC_MEC_MEC012_SRV_RNIS_014_OK
    [Documentation]    Update an Individual RNIS subscription
    ...    Check that the RNIS service modifies a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.1.1, clause 7.8.3.2
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Update Individual RNIS Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   CellChangeSubscription
    

TC_MEC_MEC012_SRV_RNIS_015_OK
    [Documentation]    Remove an Individual RNIS subscription
    ...    Check that the RNIS service deletes a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.1.1, clause 7.8.3.5
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Delete Individual RNIS Subscription
    Check HTTP Response Status Code Is    204

*** Keywords ***
Get RNIS subscription list
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions?subscription_type=${SUBSCRIPTION_HREF_VALUE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Post RNIS subscription request
    [Arguments]    ${content}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${json_file} =    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${json_file}
    ${body}=    Replace String    ${body}    \${HREF}    ${HREF}
    ${body}=    Replace String    ${body}    \${LINKS_SELF}    ${LINKS_SELF}
    Log    ${body}
    Post    ${apiRoot}/rni/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get Individual RNIS Subscription
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update Individual RNIS Subscription
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${body}    Get File    jsons/UpdateCellChangeSubscriptionRequest.json
    ${body}=    Replace String    ${body}    \${HREF}    ${HREF}
    ${body}=    Replace String    ${body}    \${LINKS_SELF}    ${LINKS_SELF}
    Log    ${body}
    Put    ${apiRoot}/rni/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Delete Individual RNIS Subscription
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/rni/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}