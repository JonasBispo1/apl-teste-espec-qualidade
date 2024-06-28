*** Settings ***

Documentation    This file will provide actions and validation in principal page
Resource         ../custom/cst_package.robot

*** Variables ***
${fill-descriptionOfProduct}     css=input[data-testid='search-form-input']

*** Keywords ***
wrote the product description in the search field
    Wait For Elements State    ${fill-descriptionOfProduct}  stable
    ${value_search}   Set Variable  ' '
    WHILE    '${value_search}' != '${constants.treadmill.description_item}'
        Fill Text   ${fill-descriptionOfProduct}    ${constants.treadmill.description_item}
        Sleep    1
        ${value_search}   Get Attribute    ${fill-descriptionOfProduct}    value
        Press Keys   ${fill-descriptionOfProduct}  Enter
    END

Validate open page
    Get Text    ${button-cadastre-se} 