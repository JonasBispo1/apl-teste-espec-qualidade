*** Settings ***

Documentation    This file will provide validation products
Resource         ../custom/cst_package.robot

*** Keywords ***
find the desired item
    @{products}  Get Elements  css=div[data-testid='product-card-desktop']
    @{products}  Set Global Variable    ${products}
    
validate iten in page
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{products}
        ${descricao}   Get Text    ${element} >> div.product-card__details-wrapper >> h3.product-card__title >> span
        IF    '${descricao}' == '${constants.treadmill.description_item}'
            Highlight Elements    ${element} >> div.product-card__details-wrapper >> h3.product-card__title >> span
            Take Screenshot
        END
    END
    
select product and insert in package
    FOR    ${index}    ${element}    IN ENUMERATE    @{products}
        ${descricao}   Get Text    ${element} >> div.product-card__details-wrapper >> h3.product-card__title >> span

        IF    '${descricao}' == '${constants.treadmill.description_item}'
            Sleep    3
            Click    ${element}
        END
    END
    Wait For Elements State  css=button[data-testid='favorite-button'] >> svg >> path
    Click    id=buy-button

