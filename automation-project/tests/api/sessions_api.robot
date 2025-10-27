*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1

*** Test Cases ***
Listar Sessões Disponíveis
    [Documentation]    Testa se a API retorna todas as sessões disponíveis
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /sessions
    Should Be Equal As Integers    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    ${sessions}=      Set Variable    ${response_json['data']}
    ${count}=         Get Length      ${sessions}
    Should Be True    ${count} > 0    msg=Não há sessões cadastradas no banco de dados

Buscar Sessão por ID
    [Documentation]    Testa se a API retorna detalhes corretos de uma sessão específica
    Create Session    api    ${BASE_URL}
    
    # Busca todas as sessões e pega o array 'data'
    ${list_response}=    GET On Session    api    /sessions
    ${response_json}=    Set Variable    ${list_response.json()}
    ${sessions}=         Set Variable    ${response_json['data']}
    
    # Verifica se tem sessões disponíveis
    ${count}=            Get Length    ${sessions}
    Should Be True       ${count} > 0    msg=Não há sessões cadastradas para buscar por ID
    
    # Pega o ID da primeira sessão
    ${first_session}=    Set Variable    ${sessions}[0]
    ${session_id}=       Set Variable    ${first_session['_id']}
    
    # Busca a sessão por ID
    ${session_response}=    GET On Session    api    /sessions/${session_id}
    Should Be Equal As Integers    ${session_response.status_code}    200
    ${session_detail}=    Set Variable    ${session_response.json()}
    Should Not Be Empty    ${session_detail}
    Log    ${session_detail}

Listar Sessões de um Filme Específico
    [Documentation]    Testa se a API retorna sessões de um filme específico usando filtro por movieId
    Create Session    api    ${BASE_URL}
    
    # Busca todas as sessões e pega o array 'data'
    ${sessions_response}=    GET On Session    api    /sessions
    ${response_json}=        Set Variable    ${sessions_response.json()}
    ${sessions}=             Set Variable    ${response_json['data']}
    
    # Verifica se tem sessões disponíveis
    ${count}=                Get Length    ${sessions}
    Should Be True           ${count} > 0    msg=Não há sessões cadastradas para buscar por filme
    
    # Pega o movieId da primeira sessão
    ${first_session}=        Set Variable    ${sessions}[0]
    ${movie_obj}=            Set Variable    ${first_session['movie']}
    ${movie_id}=             Set Variable    ${movie_obj['_id']}
    
    # Cria o dicionário de parâmetros
    &{params}=    Create Dictionary    movieId=${movie_id}
    
    # Busca sessões filtrando por movieId
    ${movie_sessions_response}=    GET On Session    api    /sessions    params=${params}
    Should Be Equal As Integers    ${movie_sessions_response.status_code}    200
    ${movie_sessions_json}=    Set Variable    ${movie_sessions_response.json()}
    ${movie_sessions}=         Set Variable    ${movie_sessions_json['data']}
    Should Not Be Empty    ${movie_sessions}
    Log    ${movie_sessions}