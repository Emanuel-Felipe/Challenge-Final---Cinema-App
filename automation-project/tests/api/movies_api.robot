*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1

*** Test Cases ***
Listar Todos os Filmes
    [Documentation]    Testa se a API retorna todos os filmes cadastrados corretamente.
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /movies
    Should Be Equal As Integers    ${response.status_code}    200

    Run Keyword If    'data' in ${response.json()}
    ...    Set Variable    ${response.json()['data']}
    ...    ELSE
    ...    Set Variable    ${response.json()}
    ${movies}=        Set Variable    ${response.json()['data']}
    Should Not Be Empty    ${movies}    msg=Não há filmes cadastrados
    Log    Lista de filmes retornada: ${movies}

Buscar Filme Por ID
    [Documentation]    Testa se a API retorna corretamente um filme ao buscar por ID válido.
    Create Session    api    ${BASE_URL}
    
    # Obtém um ID real dinamicamente
    ${all_response}=    GET On Session    api    /movies
    Should Be Equal As Integers    ${all_response.status_code}    200
    ${movies}=          Set Variable    ${all_response.json()['data']}
    Should Not Be Empty    ${movies}    msg=Não há filmes cadastrados para teste
    
    ${first_movie}=     Set Variable    ${movies}[0]
    ${movie_id}=        Set Variable    ${first_movie['id']}
    
    # Busca o filme por ID
    ${response}=        GET On Session    api    /movies/${movie_id}
    Should Be Equal As Integers    ${response.status_code}    200
    
    ${movie_data}=      Set Variable    ${response.json()['data']}
    Should Not Be Empty    ${movie_data}    msg=Filme retornou vazio
    Should Be Equal     ${movie_data['id']}    ${movie_id}
    Log    Detalhes do filme retornado: ${movie_data}

Buscar Filme Com ID Inválido
    [Documentation]    Testa se a API retorna 404 ao buscar um filme com ID inválido.
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /movies/123abc    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404
    Log    Resposta para ID inválido: ${response.json()}
