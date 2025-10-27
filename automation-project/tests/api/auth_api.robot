*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1
${VALID_EMAIL}    teste@gmail.com
${VALID_PASS}     teste123
${INVALID_PASS}   senhaerrada

*** Test Cases ***
Login com credenciais válidas
    [Documentation]    Testa login com usuário válido via API
    Create Session    api    ${BASE_URL}
    &{body}=          Create Dictionary    email=${VALID_EMAIL}    password=${VALID_PASS}
    ${response}=      POST On Session    api    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Log    ${response.json()}
    Should Not Be Empty    ${response.json()}

Login com credenciais inválidas
    [Documentation]    Testa login com usuário válido e senha incorreta
    Create Session    api    ${BASE_URL}
    &{body}=          Create Dictionary    email=${VALID_EMAIL}    password=${INVALID_PASS}
    ${response}=      POST On Session    api    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Log    ${response.json()}
    Should Contain    ${response.json()['message']}    Invalid

Acessar rota protegida sem token
    [Documentation]    Testa acesso a rota protegida sem autenticação
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /reservations/me    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Log    ${response.json()}
    Should Contain    ${response.json()['message']}    Not authorized
