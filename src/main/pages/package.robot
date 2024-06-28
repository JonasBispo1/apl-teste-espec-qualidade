*** Settings ***

Documentation    This file will provide validation products in package
Resource         ../custom/cst_package.robot
Library    FakerLibrary

*** Variables ***
${quant}          css=select[data-qa='item-quantity']

*** Keywords ***
validate the item on package
    Wait For Elements State  css=img[data-qa='cart-item-image']  stable
    validade quantity of product  '1'
    ${list_item}   Get Elements    css=li[data-testid='cart-item']
    FOR    ${index}    ${element}    IN ENUMERATE    @{list_item}
        ${desc_item}  Get Text    ${element} >> div >> nth=1 >> a
        IF    '${desc_item}' == '${constants.treadmill.description_item}'
            Highlight Elements    ${element} >> div >> nth=0
            Highlight Elements    ${element} >> div >> nth=1
            Take Screenshot
        END
    END

validade quantity of product
    [Arguments]   ${quantity}
    ${qtd}  Get Text    ${quant} >> option >> nth=0
    IF    '${qtd}' == ${quantity}
        Highlight Elements    ${quant}
    END