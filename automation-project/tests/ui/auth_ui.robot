*** Settings ***
Library    Browser
Library    String
Library    DateTime
Suite Setup       Configurar Suite
Suite Teardown    Fechar Navegador

*** Variables ***
${FRONT_URL}      http://localhost:3002/
${NOME_USUARIO}   Usuário Teste
${SENHA}          teste123
${EMAIL_UNICO}    ${EMPTY}    # Gerado dinamicamente no teste

*** Test Cases ***
Cadastro De Novo Usuário
    [Documentation]    Testa o fluxo completo de registro com dados válidos
    ${EMAIL_UNICO}=    Gerar Email Unico
    Set Suite Variable    ${EMAIL_UNICO}
    Go To              ${FRONT_URL}register
    Fill Text          id=name             ${NOME_USUARIO}
    Fill Text          id=email            ${EMAIL_UNICO}
    Fill Text          id=password         ${SENHA}
    Fill Text          id=confirmPassword  ${SENHA}
    Click              css=button[type="submit"]
    Wait For Elements State    text="Conta criada com sucesso!"    visible    timeout=15s
    Take Screenshot

Login Com Usuário Existente
    [Documentation]    Testa login com um usuário já existente
    Go To              ${FRONT_URL}login
    Fill Text          id=email            ${EMAIL_UNICO}
    Fill Text          id=password         ${SENHA}
    Click              css=button[type="submit"]
    Wait For Elements State    text="Login realizado com sucesso!"    visible    timeout=15s
    # Aguarda redirecionamento após login
    Sleep    2s
    Take Screenshot

Logout Do Sistema
    [Documentation]    Testa se o botão de sair redireciona corretamente
    # Aguarda a página estar pronta após login
    Wait For Elements State    css=button:has-text("Sair"), button:has-text("Logout")    visible    timeout=10s
    Click              css=button:has-text("Sair"), button:has-text("Logout")
    Wait For Elements State    css=button[type="submit"]:has-text("Entrar")    visible    timeout=15s
    Take Screenshot



*** Keywords ***
Gerar Email Unico
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${email}=        Set Variable    user_${timestamp}@teste.com
    RETURN           ${email}

Configurar Suite
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${FRONT_URL}

Abrir Navegador
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}

Fechar Navegador
    Close Browser
