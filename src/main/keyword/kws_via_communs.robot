*** Settings ***
Documentation    Neste arquivo estão presentes todas as palavras-chave
...              relacionado aos testes do requisito funcional de troca STD
Resource         ../custom/cst_package.robot

*** Keywords ***
Request Get
    [Arguments]    ${api}    ${endpoint}    ${params}=${NONE}    ${header}=${NONE}

    Create Session    web_api    ${api}    disable_warnings=1

    ${resp}=    GET On Session      web_api              ${endpoint}
    ...         params=${params}    headers=${header}    expected_status=any

    &{get}=    Create Dictionary
    ...        params=${params}
    ...        header=${header}

    ${request}=        Set Variable    ${get}
    ${response}=       Set Variable    ${resp.json()}
    ${status_code}=    Set Variable    ${resp.status_code}

    Set Test Variable    ${request}
    Set Test Variable    ${response}
    set Test Variable    ${status_code}

Create xml for send soupUI
    [Arguments]  ${path_detail}  ${element}
    
    ${xml}  Format String    ${EXECDIR}${path_detail}  &{element}

    Return From Keyword  ${xml}
    
Assemble to file
    [Arguments]  ${file}  ${values} 
    ${file}=    Convert File with the dictionary  ./src/resource/${file}   ${values} 
    Return From Keyword  ${file}

Conect in DB2
    ${conn}=  Run Keyword  Db2 Connect To Database   10.0.10.39    DBPLP2    ${constants.treadmill.user_db2}    ${constants.treadmill.password_db2}
    Set Suite Variable    ${connection}  ${conn}

Get data from DB2 table
    [Arguments]   ${query}  ${keyword_of_query}
    
    #${query}=     Assemble to query    ./src/resource/queries/${query}  ${keyword_of_query}
    
    ${query}      Format String        ${EXECDIR}/src/resource/queries/${query}   &{keyword_of_query}
    
    ${result}=    Db2 Execute Query    ${connection}    ${query}
    ${result}=    clean_values_result_bd2   ${result}
    Return From Keyword  ${result}

Return new order id
    [Arguments]  ${last_order_id}
    ${aux_id}    Get Substring    ${last_order_id}    04
    ${aux_id}    Convert To Integer   ${aux_id}
    ${aux_id}    Convert Caracters    ${aux_id+${1}}    8
    ${aux_id}=   Set Variable  AUTO${aux_id}
    Return From Keyword  ${aux_id}

Send project soup for system barramento
    [Arguments]  ${xml_prebill}  ${endpoint}  ${message_return}

    Create Soap Client   ${application.bus.url_barramento}${endpoint}?wsdl  ssl_verify=False
    
    ${response}    Call SOAP Method With String XML    ${xml_prebill}

    ${descricaoRetorno}    Get Data From XML By Tag    ${response}    ${message_return}

    Should Be String    ${descricaoRetorno}  MIF successfully processed the message and sent to destination

    Log    ${descricaoRetorno}

Agroup results of query of order dat
    [Arguments]  ${result}

    FOR    ${element}    IN    @{result}

        &{result_lpn_dic}  Create Dictionary       lpn=${element}[LPN]
        ...                                        sku=${element}[MERCADORIA]
        ...                                        service_order=${element}[ORDEM_CONSERTO]
        ...                                        reopen_lpn=${element}[LPN_REABERTA]
        ...                                        status_line_order=${element}[STATUS_DETALHE_LINHA]

        Append To List    ${constants.treadmill.data_itm_ord_dtb}    ${result_lpn_dic}

    END
    
    &{result_order_dic}  Create Dictionary        order_id=${result}[0][PREBILL]
    ...                                           order_type=${result}[0][TIPO_DO]
    ...                                           list_lpn=${constants.treadmill.data_itm_ord_dtb}


    Return From Keyword  ${result_order_dic}