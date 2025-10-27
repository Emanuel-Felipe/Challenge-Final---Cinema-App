*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1
${VALID_EMAIL}    teste@gmail.com
${VALID_PASS}     teste123

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

Get Primeiro Assento Disponivel
    [Documentation]    Retorna a primeira sessão e o primeiro assento disponível
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /sessions    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    ${sessions}=      Set Variable    ${response.json()['data']}
    Should Not Be Empty    ${sessions}    msg=Não há sessões cadastradas
    
    # Busca primeira sessão com assento disponível
    FOR    ${session}    IN    @{sessions}
        ${seats}=         Set Variable    ${session['seats']}
        FOR    ${seat}    IN    @{seats}
            ${status}=    Set Variable    ${seat['status']}
            IF    '${status}' == 'available'
                &{result}=    Create Dictionary    
                ...    session_id=${session['id']}
                ...    seat_row=${seat['row']}
                ...    seat_number=${seat['number']}
                RETURN    ${result}
            END
        END
    END
    
    Fail    Nenhum assento disponível encontrado

*** Test Cases ***
Criar Reserva Com Dados Válidos
    [Documentation]    Cria reserva com usuário autenticado e assento disponível
    ${token}=         Login Usuario Valido
    ${sess_info}=     Get Primeiro Assento Disponivel
    ${session_id}=    Get From Dictionary    ${sess_info}    session_id
    ${seat_row}=      Get From Dictionary    ${sess_info}    seat_row
    ${seat_number}=   Get From Dictionary    ${sess_info}    seat_number
    
    # Cria lista de assentos (array) com campo 'type'
    &{seat}=          Create Dictionary    row=${seat_row}    number=${seat_number}    type=full
    @{seats_list}=    Create List    ${seat}
    
    &{body}=          Create Dictionary    
    ...    session=${session_id}    
    ...    seats=${seats_list}
    
    &{headers}=       Create Dictionary    Authorization=Bearer ${token}
    Create Session    api    ${BASE_URL}
    ${response}=      POST On Session    api    /reservations    json=${body}    headers=${headers}    expected_status=any
    
    Log    Body: ${body}
    Log    Response: ${response.json()}
    
    Should Be Equal As Integers    ${response.status_code}    201

Criar Reserva Com Assento Já Ocupado
    [Documentation]    Tenta criar reserva em assento já reservado
    ${token}=         Login Usuario Valido
    
    # Primeiro cria uma reserva
    ${sess_info}=     Get Primeiro Assento Disponivel
    ${session_id}=    Get From Dictionary    ${sess_info}    session_id
    ${seat_row}=      Get From Dictionary    ${sess_info}    seat_row
    ${seat_number}=   Get From Dictionary    ${sess_info}    seat_number
    
    &{seat}=          Create Dictionary    row=${seat_row}    number=${seat_number}    type=full
    @{seats_list}=    Create List    ${seat}
    &{body}=          Create Dictionary    session=${session_id}    seats=${seats_list}
    &{headers}=       Create Dictionary    Authorization=Bearer ${token}
    Create Session    api    ${BASE_URL}
    
    # Primeira reserva (deve funcionar)
    ${response1}=     POST On Session    api    /reservations    json=${body}    headers=${headers}    expected_status=any
    Log    Primeira reserva: ${response1.status_code}
    
    # Segunda reserva no MESMO assento (deve falhar com 400)
    ${response2}=     POST On Session    api    /reservations    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response2.status_code}    400
    Log               ${response2.json()}

Criar Reserva Sem Autenticação
    [Documentation]    Tenta criar reserva sem fornecer token
    ${sess_info}=     Get Primeiro Assento Disponivel
    ${session_id}=    Get From Dictionary    ${sess_info}    session_id
    ${seat_row}=      Get From Dictionary    ${sess_info}    seat_row
    ${seat_number}=   Get From Dictionary    ${sess_info}    seat_number
    
    # Cria lista de assentos (array) com campo 'type'
    &{seat}=          Create Dictionary    row=${seat_row}    number=${seat_number}    type=full
    @{seats_list}=    Create List    ${seat}
    
    &{body}=          Create Dictionary    
    ...    session=${session_id}    
    ...    seats=${seats_list}
    
    Create Session    api    ${BASE_URL}
    ${response}=      POST On Session    api    /reservations    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Log               ${response.json()}

Listar Minhas Reservas
    [Documentation]    Lista reservas do usuário autenticado
    ${token}=         Login Usuario Valido
    &{headers}=       Create Dictionary    Authorization=Bearer ${token}
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /reservations/me    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Log               ${response.json()}