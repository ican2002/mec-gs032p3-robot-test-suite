''[Documentation]   robot --outputdir ../../outputs ./RnisQuery_BI_BO.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Request RabInfo info using wrong parameters
    [Documentation]   TC_MEC_SRV_RNIS_016_BR
    ...  Check that the RNIS service returns an error when the RAB information is requested with a malformatted message
    ...  ETSI GS MEC 012 2.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/RabInfo
    Get RabInfo info using wrong parameters
    Check HTTP Response Status Code Is    400
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    400


Request RabInfo info using non existing cell id
    [Documentation]   TC_MEC_SRV_RNIS_016_BR
    ...  Check that the RNIS service returns an error when the RAB information for a not existing element is requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/RabInfo
    Get RabInfo info using non existing cell id
    Check HTTP Response Status Code Is    404
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    404

Request Plmn info using wrong parameters
    [Documentation]   TC_MEC_SRV_RNIS_017_BR
    ...  Check that the RNIS service returns an error when the PLMN information is requested with a malformatted message
    ...  ETSI GS MEC 012 2.1.1, clause 7.4.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/PlmnInfo
    Get PLMN info using wrong parameters
    Check HTTP Response Status Code Is    400
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    400


Request Plmn info using non existing application id
    [Documentation]   TC_MEC_SRV_RNIS_017_NF
    ...  Check that the RNIS service returns an error when the PLMN information for a not existing element is requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.4.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/PlmnInfo
    Get PLMN info using non existing application id
    Check HTTP Response Status Code Is    404
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    404


Request S1Bearer info using wrong parameters
    [Documentation]   TC_MEC_SRV_RNIS_018_BR
    ...  Check that the RNIS service returns an error when the S1 bearer information is requested with a malformatted message
    ...  ETSI GS MEC 012 2.1.1, clause 7.5.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/S1BearerInfo
    Get S1Bearer info using wrong parameters
    Check HTTP Response Status Code Is    400
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    400


Request S1Bearer info using non existing cell id
    [Documentation]   TC_MEC_SRV_RNIS_018_BR
    ...  Check that the RNIS service returns an error when the S1 bearer information is requested with a malformatted message
    ...  ETSI GS MEC 012 2.1.1, clause 7.5.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/S1BearerInfo
    Get S1Bearer info using non existing cell id
    Check HTTP Response Status Code Is    404
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    404


Request L2Meas info using wrong parameters
    [Documentation]   TC_MEC_SRV_RNIS_019_BR
    ...  Check that the RNIS service returns an error when the L2 measurements information is requested with a malformatted message
    ...  ETSI GS MEC 012 2.1.1, clause 7.5a.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/S1BearerInfo
    Get L2Meas info using wrong parameters
    Check HTTP Response Status Code Is    400
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    400


Request L2Meas info using non existing cell id
    [Documentation]   TC_MEC_SRV_RNIS_019_BR
    ...  Check that the RNIS service returns an error when the L2 measurements information for a not existing element is requested
    ...  ETSI GS MEC 012 2.1.1, clause 7.5a.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/S1BearerInfo
    Get L2Meas info using non existing cell id
    Check HTTP Response Status Code Is    404
    Run Keyword If    ${PIC_PROBLEM_DETAILS_ON_4xx} == 1    Check ProblemDetails    404

*** Keywords ***
Get RabInfo info using wrong parameters
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/queries/rab_info?c_id=${C_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get RabInfo info using non existing cell id
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/queries/rab_info?cell_id=${NOT_EXISTENT_CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get Plmn info using wrong parameters
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/queries/plmn_info?app_id=${APP_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get Plmn info using non existing application id
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/queries/plmn_info?app_ins_id=${NOT_EXISTENT_APP_INS_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get S1Bearer info using wrong parameters
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/queries/s1_bearer_info?c_id=${C_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get S1Bearer info using non existing cell id
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/s1_bearer_info?cell_id=${NOT_EXISTENT_CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get L2Meas info using wrong parameters
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/layer2_meas?c_id=${C_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get L2Meas info using non existing cell id
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/queries/layer2_meas?cell_id=${NOT_EXISTENT_CELL_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
