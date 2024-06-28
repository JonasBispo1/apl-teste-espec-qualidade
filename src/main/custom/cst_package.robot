*** Settings ***
Documentation    This file contains all the libraries, keywords, elements
...              settings files that are used in test execution

### KEYWORDS ###
### PAGES ###
Resource   ../pages/login.robot
Resource   ../pages/principal_page.robot
Resource   ../pages/find_product.robot
Resource   ../pages/package.robot

### DATA ###
Variables  ../../resource/constant.yaml
Variables  ../../resource/application.yaml

### LIBRARY ###
Library    Browser