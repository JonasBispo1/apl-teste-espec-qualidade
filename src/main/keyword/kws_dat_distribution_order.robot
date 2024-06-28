*** Settings ***

Documentation    This file will provide actions for creating and consulting service orders

Resource         ../custom/cst_package.robot

*** Keywords ***
that order '${order}' exist in data base DB2
    Conect in DB2
    Set To Dictionary  ${constants.treadmill.data_order_dic}  distribution_order=${order}
    ${result}=          Get data from DB2 table    query_select_ord_dtb_ast.sql  ${constants.treadmill.data_order_dic}
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{result}
        Set To Dictionary    ${constants.treadmill.data_order_dic}  LPN=${element}[LPN]
        ...                                                         SKU=${element}[MERCADORIA]
        ...                                                         facility_dest=${constants.treadmill.facility_dest}
        ...                                                         inventory_type=${constants.treadmill.inventory_type}
        ...                                                         facility=${constants.treadmill.facility}
        ...                                                         distribution_order=${element}[PREBILL]
        Append To List    ${constants.treadmill.data_lpn_list}      ${constants.treadmill.data_order_dic}
    END

new order
    ${query}=  Format String  ${EXECDIR}/src/resource/queries/query_ord_dtb_ast.sql  

    ${data_ord_ult}=    Db2 Execute Query    ${connection}  ${query}

    #${data_ord_ult}=    Get data from DB2 table    query_ord_dtb_ast.sql    ${None}
    
    ${count}=           Get Length                 ${data_ord_ult}

    IF    ${count} == ${0}
        ${cd_odast}    Set Variable    AUTO00000001

    ELSE
        ${data_ord_ult}=    Get Value From Json    ${data_ord_ult}    $..CD_ODAST

        ${cd_odast}    Return new order id    ${data_ord_ult}[0]
    END
    Return From Keyword  ${cd_odast}
select lpns in data base

    Conect in DB2

    ${cd_odast}  new order

    IF  '${constants.treadmill.order_type}' == '03'
        ${way}  Set Variable  query_select_lpn_orc.sql
    ELSE
        ${way}  Set Variable  query_select_lpn.sql
    END
    ${data_ocs_ast}=    Get data from DB2 table  ${way}  ${constants.treadmill}
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{data_ocs_ast}
        
        &{data_lpn_dic}    Create Dictionary
        ...                SKU=${element}[CD_MCR]
        ...                distribution_order=${cd_odast}
        ...                LPN=${element}[CD_OCSAST_BOS]
        ...                out_service=${element}[CD_EPSRV]
        ...                facility_dest=${constants.treadmill.facility_dest}
        ...                inventory_type=${constants.treadmill.inventory_type}
        
        Append To List    ${constants.treadmill.data_lpn_list}    ${data_lpn_dic}
        
    END

    Set To Dictionary    ${constants.treadmill.data_order_dic}    partner=${constants.treadmill.partner}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    out_service=${data_lpn_dic}[out_service]
    Set To Dictionary    ${constants.treadmill.data_order_dic}    facility=${constants.treadmill.facility}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    order_type=${constants.treadmill.order_type}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    distribution_order=${cd_odast}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    facility_dest=${constants.treadmill.facility_dest}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    inventory_type=${constants.treadmill.inventory_type}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    warranty=${EMPTY}

that lpn exist in data base DB2
    
    Conect in DB2

    ${cd_odast}  new order

    @{LPNs}=    Split String    ${constants.treadmill.code_lpn}  ,
    
    FOR    ${element}    IN    @{LPNs}

        &{LPNs_dict}  Create Dictionary  LPN=${element}

        ${data_ocs_ast}=    Get data from DB2 table  query_OCS_AST.sql    ${LPNs_dict}

        ${SKU}=    Get Value From Json    ${data_ocs_ast}    $..CD_MCR

        ${service}=    Get Value From Json    ${data_ocs_ast}    $..CD_EPSRV
        
        ${inventory_type}=    Get Value From Json    ${data_ocs_ast}    $..CD_FIL_CDP_ORI

        &{data_lpn_dic}    Create Dictionary                 LPN=${element}
        ...                SKU=${SKU}[0]
        ...                distribution_order=${cd_odast}
        ...                out_service=${service}[0]
        ...                facility_dest=${constants.treadmill.facility_dest}
        ...                inventory_type=${inventory_type}[0]

        Append To List    ${constants.treadmill.data_lpn_list}    ${data_lpn_dic}
    END

    FOR    ${element}    IN    ${constants.treadmill.data_lpn_list}

        IF  '${constants.treadmill.order_type}' == '04'

            &{posto}  Create Dictionary  POSTO=${element}[0][out_service]
            ${result}=    Get data from DB2 table  query_partner_satex.sql    ${posto}

            ${count}=    Get Length    ${result}
    
            IF    ${constants.treadmill.warranty} == ${False}
                IF    ${count} > ${0}
                    Set To Dictionary    ${constants.treadmill.data_order_dic}    warranty=F1
    
                    ${warranty}    Set Variable    ${True}
    
                ELSE
                    Set To Dictionary    ${constants.treadmill.data_order_dic}    warranty=${EMPTY}
    
                END
            END
        ELSE
            Set To Dictionary    ${constants.treadmill.data_order_dic}    warranty=${EMPTY}
        END
    END

    Set To Dictionary    ${constants.treadmill.data_order_dic}    partner=${constants.treadmill.partner}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    facility=${constants.treadmill.facility}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    order_type=${constants.treadmill.order_type}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    distribution_order=${cd_odast}
    Set To Dictionary    ${constants.treadmill.data_order_dic}    facility_dest=${constants.treadmill.facility_dest}
    #Set To Dictionary    ${constants.treadmill.data_order_dic}    inventory_type=${constants.treadmill.inventory_type}
    
structure the file xml in '${type_send}' standart
    Set Suite Variable  ${xml_detail_lpn}  ${EMPTY}
    Set Suite Variable  ${xml_detail_item}  ${EMPTY}
    FOR    ${index}    ${element}    IN ENUMERATE    @{constants.treadmill.data_lpn_list}
        ${aux_xml_detail_lpn}   Create xml for send soupUI    /src/resource/xmls/${type_send}/${type_send}_lpn.xml   ${element}
        ${aux_xml_detail_item}  Create xml for send soupUI    /src/resource/xmls/${type_send}/${type_send}_item.xml  ${element}

        ${xml_detail_lpn}   Set Variable    ${xml_detail_lpn}${aux_xml_detail_lpn}
        ${xml_detail_item}  Set Variable    ${xml_detail_item}${aux_xml_detail_item}
    END
    
    Set To Dictionary    ${constants.treadmill.data_order_dic}    xml_item=${xml_detail_item}

    Set To Dictionary    ${constants.treadmill.data_order_dic}    xml_lpn=${xml_detail_lpn}

    ${xml_order_dat}     Create xml for send soupUI  /src/resource/xmls/${type_send}/${type_send}_dat.xml  ${constants.treadmill.data_order_dic}

    Set Suite Variable    ${xml_order}    ${xml_order_dat}

send the xml file of ${type_send} for barramento system
    IF  ${type_send} == 'prebill'
        ${resp}=  Send project soup for system barramento  ${xml_order}  wms/notafiscal/soap/v1  descricaoRetorno
    ELSE
        ${resp}=  Send project soup for system barramento  ${xml_order}  wms/enviarconfirmacaocarregamento/soap/v1  descricao
    END
can validate the data received in data base DB2
    ${count}=    Set Variable    ${0}

    FOR    ${counter}    IN RANGE    0    10
    
        IF    ${count} == ${0}
            ${result}=          Get data from DB2 table    query_select_ord_dtb_ast.sql    ${constants.treadmill.data_order_dic}
            ${count}=           Get Length                 ${result}
            Exit For Loop If    ${count} > ${0}
            Sleep               5s
        END
    
    END
     
    ${order_result_in_line}=  Agroup results of query of order dat  ${result}
    Log To Console    ${order_result_in_line}