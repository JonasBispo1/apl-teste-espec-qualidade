*** Settings ***
Documentation    In this file are present all the keyworkds
...              related assertions

*** Keywords ***
Assert Be String Equal
    [Arguments]    ${actual}    ${expect}    ${msg}=${exceptions.automation.bussiness}

    ${status}=    Run Keyword And Return Status
    ...           Should Be Equal As Strings       ${expect}    ${actual}    msg=${msg}

    IF    ${status} == ${FALSE}
        Fail    ${msg}${SPACE}${actual}${SPACE}!=${SPACE}${expect}
    END

Assert Be Number Equal
    [Arguments]    ${actual}    ${expect}    ${msg}=${exceptions.automation.bussiness}

    ${status}=    Run Keyword And Return Status
    ...           Should Be Equal As Numbers       ${expect}    ${actual}    msg=${msg}

    IF    ${status} == ${FALSE}
        Fail    ${msg}${SPACE}${actual}${SPACE}!=${SPACE}${expect}
    END

Assert Is Not Be Equal
    [Arguments]    ${actual}    ${expect}    ${msg}=${exceptions.automation.bussiness}

    ${status}=    Run Keyword And Return Status
    ...           Should Not Be Equal              ${expect}    ${actual}    msg=${msg}

    IF    ${status} == ${FALSE}
        Fail    ${msg}${SPACE}${actual}${SPACE}!=${SPACE}${expect}
    ELSE
        Log    ${actual}${SPACE}!=${SPACE}${expect}
    END

