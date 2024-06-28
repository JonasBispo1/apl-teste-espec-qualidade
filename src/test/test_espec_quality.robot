*** Settings ***
Documentation    This resource contains tests to buy iten in Web Page

Task Setup  open the web page

Resource    ../main/custom/cst_package.robot
Library    OperatingSystem

*** Test Cases ***
Test Case: search item
    Given wrote the product description in the search field
    When find the desired item
    Then validate iten in page


Test Case: add the iten in cst_package
    Given wrote the product description in the search field
    When find the desired item
    And select product and insert in package
    Then validate the item on package