*** Settings ***
Library    Browser
Resource   ../../resources/variables.robot

*** Variables ***
${FRONT_URL}    http://localhost:3002/

*** Test Cases ***
Visualizar Lista de Filmes na Home
    [Documentation]    Garante que os filmes são exibidos corretamente na página inicial.
    New Browser    chromium    headless=False
    New Context
    New Page       ${FRONT_URL}
    
    Log    🕐 Aguardando carregamento da página inicial...
    Wait For Elements State    css=a.btn-primary[href^="/movies/"] >> nth=0    visible    timeout=10s
    
    ${filmes}=    Get Element Count    css=a.btn-primary[href^="/movies/"]
    Log    ✅ Foram encontrados ${filmes} filmes exibidos na home.
    Should Be True    ${filmes} > 0    msg=❌ Nenhum filme foi encontrado na página inicial.
    
    Close Browser

Clicar Em Filme E Ver Detalhes
    [Documentation]    Verifica se ao clicar em um filme, a página de detalhes é carregada corretamente.
    New Browser    chromium    headless=False
    New Context
    New Page       ${FRONT_URL}
    
    Log    🎬 Clicando no primeiro filme disponível...
    Click    css=a.btn-primary[href^="/movies/"] >> nth=0
    
    Log    🕐 Aguardando elementos da página de detalhes do filme...
    Wait For Elements State    css=a.btn-primary.session-button >> nth=0    visible    timeout=10s
    Log    ✅ Página de detalhes carregada com sucesso.
    
    # Valida que o botão “Selecionar Assentos” está visível
    Log    ✅ Botão de sessão validado com sucesso.
    
    Close Browser
