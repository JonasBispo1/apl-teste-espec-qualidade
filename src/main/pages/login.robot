*** Settings ***

Documentation    This file will provide actions login web page
Resource         ../custom/cst_package.robot

*** Variables ***
${button-continue-user}        css=button[data-testid='continue-btn']
${button-continue-psw}         css=button[data-testid='loginCompletion-btn']
${button-cadastre-se}          xpath=//span[contains(text(),'Entre ou cadastre-se')]
${input-cpf}                   id=cpfcnpj-verification-input
${input-psw}                   id=password-input 

*** Keywords ***
open the web page
    #New Browser    browser=${application.Browser.browser}
    New Browser    browser=firefox
    #New Browser    browser=webkit
    ...            headless=${application.Browser.headless}
    Set Browser Timeout    ${application.Browser.time}

    New Context      viewport={'width': 1280, 'height': 720}
    New Page         ${application.Browser.url}
    
    Validate open page
    
    #successfully logged in

successfully logged in
    Click        ${button-cadastre-se}
    Wait For Elements State    ${input-cpf}

    ${value_search}   Set Variable  ' '
    WHILE    '${value_search}' != '${constants.treadmill.cpf_user}'
        Fill Text    ${input-cpf}    ${constants.treadmill.cpf_user}
        Sleep    1
        ${value_search}   Get Attribute    ${input-cpf}   value
    END

    Fill Text    ${input-cpf}    ${constants.treadmill.cpf_user}
    Wait For Elements State    ${button-continue-user}  stable
    Click        ${button-continue-user}
    Wait For Elements State    ${input-psw}
    Fill Text    ${input-psw}            ${constants.treadmill.password}
    Wait For Elements State    ${button-continue-psw}  stable
    Click        ${button-continue-psw}
    