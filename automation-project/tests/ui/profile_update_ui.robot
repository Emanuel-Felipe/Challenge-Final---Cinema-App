*** Settings ***
Library    Browser
Library    String
Library    DateTime
Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador

*** Variables ***
${FRONT_URL}        http://localhost:3002/
${EMAIL}            teste@gmail.com
${SENHA}            teste123

*** Test Cases ***
Atualizar Nome Do Usuário
    [Documentation]    Testa o fluxo de atualização do nome do usuário no perfil
    
    # Gerar nome aleatório
    ${NOVO_NOME}=      Gerar Nome Aleatorio
    
    # --- Login ---
    New Page           ${FRONT_URL}login
    Fill Text          id=email     ${EMAIL}
    Fill Text          id=password  ${SENHA}
    Click              css=button[type="submit"]
    Wait For Elements State    text="Login realizado com sucesso!"    visible    timeout=10s
    Take Screenshot

    # --- Acessar perfil ---
    Click              css=a[href="/profile"]
    Wait For Elements State    id=name    visible    timeout=5s

    # --- Atualizar nome ---
    Click              id=name
    Keyboard Key       press    Control+a
    Type Text          id=name      ${NOVO_NOME}
    
    # Aguarda o botão ficar habilitado
    Wait For Elements State    css=button[type="submit"]:not([disabled])    visible    timeout=10s
    Click              css=button[type="submit"]
    Wait For Elements State    text="Sucesso!"    visible    timeout=10s
    
    # Clicar no botão OK do modal de confirmação
    Click              css=button.btn.btn-primary:has-text("OK")
    Take Screenshot

    # --- Verificar nome atualizado ---
    ${valor_nome}=     Get Attribute    id=name    value
    Should Contain     ${valor_nome}    ${NOVO_NOME}
    Take Screenshot

    # --- Logout ---
    Click              css=button:has-text("Sair"), button:has-text("Logout")
    Wait For Elements State    css=button[type="submit"]:has-text("Entrar")    visible    timeout=5s
    Take Screenshot

*** Keywords ***
Gerar Nome Aleatorio
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${nome}=         Set Variable    Usuario_${timestamp}
    RETURN           ${nome}

Abrir Navegador
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}

Fechar Navegador
    Close Browser
