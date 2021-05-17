''[Documentation]   robot --outputdir ../../outputs ./RnisQuery_BV.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_016_OK
    [Documentation]   Request RabInfo info
    ...  Check that the RNIS service returns the RAB information when requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/RabInfo
    Get RabInfo info
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   RabInfo
    Check RabInfo    ${response['body']}


TC_MEC_MEC012_SRV_RNIS_017_OK
    [Documentation]   Request Plmn info
    ...  Check that the RNIS service returns the PLMN information when requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.4.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/PlmnInfo
    Get PLMN info
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PlmnInfos
    Check PlmnInfo    ${response['body'][0]}


TC_MEC_MEC012_SRV_RNIS_018_OK
    [Documentation]   Request S1Bearer info
    ...  Check that the RNIS service returns the S1 bearer information
    ...  ETSI GS MEC 012 2.1.1, clause 7.5.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/S1BearerInfo
    Get S1Bearer info
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   S1BearerInfos
    #log    ${response['body']}
    Check S1BearerInfo    ${response['body']}


TC_MEC_MEC012_SRV_RNIS_019_OK
        [Documentation]   Request L2Meas info
    ...  Check that the RNIS service returns the L2 measurements information
    ...  ETSI GS MEC 012 2.1.1, clause 7.5a.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/L2Meas
    Get Layer2Meas Info
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   L2Meas
    Check L2MeasInfo    ${response['body']}


*** Keywords ***
Get RabInfo info
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/rab_info?cell_id=${CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get Plmn info
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/plmn_info?app_ins_id=${APP_INS_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get S1Bearer info
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/s1_bearer_info?cell_id=${CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get Layer2Meas Info
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/layer2_meas?cell_id=${CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}