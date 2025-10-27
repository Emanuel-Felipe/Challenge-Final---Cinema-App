*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1
${VALID_EMAIL}    teste@gmail.com
${VALID_PASS}     teste123
${INVALID_TOKEN}  invalidtoken123

*** Keywords ***
Login Usuario Valido
    [Documentation]    Realiza login e retorna token de autenticação real
    Create Session    api    ${BASE_URL}
    &{body}=          Create Dictionary    email=${VALID_EMAIL}    password=${VALID_PASS}
    ${response}=      POST On Session    api    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    ${token}=         Set Variable    ${response_json['data']['token']}
    RETURN            ${token}

*** Test Cases ***
Buscar Recurso Inexistente
    [Documentation]    Testa se a API retorna 404 ao buscar recurso que não existe
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /movies/000000000000000000000000    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404
    Log               ${response.json()}

Enviar Payload Inválido
    [Documentation]    Testa se a API retorna 401 ao enviar payload inválido
    Create Session    api    ${BASE_URL}
    &{body}=          Create Dictionary    invalid_field=xyz
    ${response}=      POST On Session    api    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Log               ${response.json()}

Token Expirado Ou Inválido
    [Documentation]    Testa se a API retorna 401 ao acessar recurso protegido com token inválido
    Create Session    api    ${BASE_URL}
    &{headers}=       Create Dictionary    Authorization=Bearer ${INVALID_TOKEN}
    ${response}=      GET On Session    api    /reservations/me    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Log               ${response.json()}
