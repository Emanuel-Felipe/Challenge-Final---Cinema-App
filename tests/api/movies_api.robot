*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/variables.robot

*** Variables ***
${BASE_URL}       http://localhost:3000/api/v1

*** Test Cases ***
Listar Todos os Filmes
    [Documentation]    Testa se a API retorna todos os filmes cadastrados
    Create Session    api    ${BASE_URL}
    ${response}=      GET On Session    api    /movies
    Should Be Equal As Integers    ${response.status_code}    200

    ${movies}=        Set Variable    ${response.json()['data']}
    Should Not Be Empty    ${movies}    msg=Não há filmes cadastrados
    Log    Lista de filmes: ${movies}

Buscar Filme Por ID
    [Documentation]    Testa se a API retorna corretamente um filme pelo ID usando o primeiro filme da lista
    Create Session    api    ${BASE_URL}
    
    # Obtém o primeiro filme da lista para pegar o ID dinamicamente
    ${all_response}=    GET On Session    api    /movies
    Should Be Equal As Integers    ${all_response.status_code}    200
    ${movies}=          Set Variable    ${all_response.json()['data']}
    Should Not Be Empty  ${movies}    msg=Não há filmes cadastrados
    ${first_movie}=     Set Variable    ${movies}[0]
    ${movie_id}=        Set Variable    ${first_movie['_id']}
    
    # Busca o filme pelo ID
    ${response}=        GET On Session    api    /movies/${movie_id}
    Should Be Equal As Integers    ${response.status_code}    200
    ${movie_data}=      Set Variable    ${response.json()['data']}
    Should Not Be Empty  ${movie_data}    msg=Erro: o filme retornou vazio
    Log    Detalhes do filme: ${movie_data}
