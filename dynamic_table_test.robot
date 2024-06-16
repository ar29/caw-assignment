*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***
${URL}    https://testpages.herokuapp.com/styled/tag/dynamic-table.html
${TABLE_DATA}    [{"name": "Bob", "age": 20, "gender": "male"}, {"name": "George", "age": 42, "gender": "male"}, {"name": "Sara", "age": 42, "gender": "female"}, {"name": "Conor", "age": 40, "gender": "male"}, {"name": "Jennifer", "age": 42, "gender": "female"}]

*** Test Cases ***
Verify Dynamic HTML Table Data
    [Documentation]    Test to verify that the dynamic HTML table data matches the provided JSON data.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//summary[contains(text(), 'Table Data')]
    Click Element    xpath=//summary[contains(text(), 'Table Data')]
    Wait Until Element Is Visible    id=jsondata
    ${table_data_json}=    Convert To String    ${TABLE_DATA}
    Input Text    id=jsondata    ${table_data_json}
    Click Button    id=refreshtable
    Wait Until Element Is Visible    xpath=//table[@id='dynamictable']/tr[2]/td[1]
    ${ui_data}=    Get Table Data From Dynamic Table
    Should Be Equal As Strings    ${table_data_json}    ${ui_data}
    [Teardown]    Close Browser

*** Keywords ***
Get Table Data From Dynamic Table
    [Documentation]    Retrieve data from the HTML table and convert it to JSON format.
    ${row_elements}=    Get WebElements    xpath=//table[@id='dynamictable']/tr[position() > 1]
    ${table_data}=    Create List
    FOR    ${row}    IN    @{row_elements}
        ${name}=    Get Text    xpath=.//td[1]
        ${age}=    Get Text    xpath=.//td[2]
        ${gender}=    Get Text    xpath=.//td[3]
        ${row_data}=    Create Dictionary    name=${name}    age=${age}    gender=${gender}
        Append To List    ${table_data}    ${row_data}
    END
    ${table_data_json}=    Convert To String    ${table_data}
    [Return]    ${table_data_json}
