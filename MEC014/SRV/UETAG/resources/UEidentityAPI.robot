*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../../pics.txt
Resource    ../../../../GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Check User Identity Tag state
    [Arguments]    ${ue_identity_tag}    ${state}
    Should Be True    ${PIC_MEC_PLAT}    1
    Should Be True    ${PIC_SERVICES}    1
    Log    Check ueIdentityTag state ${state}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${ue_identity_tag}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ueIdentityTagInfo
    #Log    Check ueIdentityTagsList for ${UE_IDENTITY_TAG} element
    ${result}=    Should Be Present In Json List    ${response['body']['ueIdentityTagInfo']['ueIdentityTags']}    ueIdentityTag    ${UE_IDENTITY_TAG}
    #Log    ${UE_IDENTITY_TAG} found with state ${result}
    Should Be Equal    ${result}[state]    ${state}
    [return]    ${state}
