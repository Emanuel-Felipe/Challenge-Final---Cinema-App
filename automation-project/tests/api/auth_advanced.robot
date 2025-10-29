*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           DateTime
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1
${VALID_EMAIL}    teste@gmail.com
${VALID_PASS}     teste123
${INVALID_TOKEN}  invalidtoken123

*** Keywords ***
Gerar Email Unico
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${email}=        Set Variable    usuario_${timestamp}@teste.com
    RETURN           ${email}

Login Usuario Valido
    [Documentation]    Faz login e retorna token real do usuário existente
    Create Session    api    ${BASE_URL}
    &{body}=          Create Dictionary    email=${VALID_EMAIL}    password=${VALID_PASS}
    ${response}=      POST On Session    api    /auth/login    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=         Set Variable    ${response.json()['data']['token']}
    RETURN            ${token}

*** Test Cases ***
Cadastro Com Dados Válidos
    [Documentation]    Testa o endpoint de cadastro com dados válidos
    ${email}=          Gerar Email Unico
    Create Session     api    ${BASE_URL}
    &{body}=           Create Dictionary
    ...                name=Usuario Teste
    ...                email=${email}
    ...                password=teste123
    ...                confirmPassword=teste123
    ${response}=       POST On Session    api    /auth/register    json=${body}
    Log To Console     Cadastrando: ${email}
    Should Be Equal As Integers    ${response.status_code}    201
    Log    Response: ${response.json()}

Cadastro Com Usuário Já Existente
    [Documentation]    Testa o endpoint com email já cadastrado
    Create Session     api    ${BASE_URL}
    &{body}=           Create Dictionary
    ...                name=Usuario Teste
    ...                email=${VALID_EMAIL}
    ...                password=teste123
    ...                confirmPassword=teste123
    ${response}=       POST On Session    api    /auth/register    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain      ${response.json()['message']}    exists

Buscar Dados Com Token Válido
    [Documentation]    Testa o GET /auth/me com token válido
    ${token}=          Login Usuario Valido
    &{headers}=        Create Dictionary    Authorization=Bearer ${token}
    Create Session     api    ${BASE_URL}
    ${response}=       GET On Session    api    /auth/me    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain      ${response.json()['data']['email']}    ${VALID_EMAIL}

Buscar Dados Sem Token
    [Documentation]    Testa o GET /auth/me sem autenticação
    Create Session     api    ${BASE_URL}
    ${response}=       GET On Session    api    /auth/me    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Buscar Dados Com Token Inválido
    [Documentation]    Testa o GET /auth/me com token inválido
    &{headers}=        Create Dictionary    Authorization=Bearer ${INVALID_TOKEN}
    Create Session     api    ${BASE_URL}
    ${response}=       GET On Session    api    /auth/me    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
