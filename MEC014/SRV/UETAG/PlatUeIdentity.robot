''[Documentation]   robot --outputdir ../../outputs ./PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Resource    resources/UEidentityAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
TC_MEC_MEC014_SRV_UETAG_001_OK
    [Documentation]   Request UE Identity Tag information
    ...  Check that the IUT responds with the information on a UE Identity tag when queried by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Get UE Identity Tag information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ueIdentityTagInfo
    Check Result Contains    ${response['body']['ueIdentityTagInfo']['ueIdentityTags']}    ueIdentityTag    ${UE_IDENTITY_TAG}


TC_MEC_MEC014_SRV_UETAG_001_BR
    [Documentation]   Request UE Identity Tag information using bad parameters
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Get UE Identity Tag information using bad parameters
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400



TC_MEC_MEC014_SRV_UETAG_001_NF
    [Documentation]   Request UE Identity Tag information using non-existent application instance
    ...  Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Get UE Identity Tag information using non-existent application instance
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


TC_MEC_MEC014_SRV_UETAG_002_OK
    [Documentation]   Register an UE Identity Tag
    ...  Check that the IUT registers a tag (representing a UE) or a list of tags when commanded by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Update an UE Identity Tag      {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG}","state":"REGISTERED"}]}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UeIdentityTagInfo
    Log    Checking Postcondition
    Check User Identity Tag state    ${UE_IDENTITY_TAG}    REGISTERED


TC_MEC_MEC014_SRV_UETAG_002_BR
    [Documentation]   Register an UE Identity Tag using invalid state
    ...  Check that the IUT responds with an error when an unauthorised request is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Update an UE Identity Tag using invalid state    {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG}","state":"INVALID_STATE"}]}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


TC_MEC_MEC014_SRV_UETAG_002_PF
    [Documentation]   Unregister an UE Identity Tag already in unregistered state
    ...  Check that the IUT responds with ProblemDetails on information an invalid URI
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo
    Update an UE Identity Tag using a not applicable valid state    {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG_INVALID_STATE}","state":"UNREGISTERED"}]}
    Check HTTP Response Status Code Is    412
    Check ProblemDetails    412


*** Keywords ***
Get UE Identity Tag information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get UE Identity Tag information using bad parameters
# FIXME Which IE protocol should be invalid?
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTagERROR=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get UE Identity Tag information using non-existent application instance
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${NON_EXISTENT_APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update an UE Identity Tag
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ## As far as I understood, we are not checking preconditions.
    # Preamble: Check that the user tag is not registered
    ## Check User Identity Tag state    ${UE_IDENTITY_TAG}    UNREGISTERED
    log    ${content}
    Put    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update an UE Identity Tag using invalid state
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    # Test Body: Register the tag user and check that the IUT has registered the tag user
    Put    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update an UE Identity Tag using a not applicable valid state
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    # Test Body: Register the tag user and check that the IUT has registered the tag user
    Put    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

    # TODO Check ProblemDetails
