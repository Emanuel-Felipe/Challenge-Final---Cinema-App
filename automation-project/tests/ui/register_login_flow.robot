*** Settings ***
Library    Browser
Library    String
Library    DateTime
Suite Teardown    Close Browser

*** Variables ***
${FRONT_URL}       http://localhost:3002/
${NAME}            Usuario Teste
${PASSWORD}        teste123
${EMAIL_UNICO}     # Será definida dinamicamente no teste

*** Test Cases ***
Fluxo Completo de Cadastro, Login e Logout
    [Documentation]    Testa o cadastro de um novo usuário, logout e novo login
    [Setup]    Configurar Teste
    [Teardown]    Finalizar Teste
    
    # --- Cadastro ---
    Fill Text    id=name    ${NAME}
    Fill Text    id=email    ${EMAIL_UNICO}
    Fill Text    id=password    ${PASSWORD}
    Fill Text    id=confirmPassword    ${PASSWORD}
    Click        css=button.btn.btn-primary
    Wait For Elements State    text="Conta criada com sucesso!"    visible    timeout=10s

    # --- Logout ---
    Click        css=button.btn-logout
    Wait For Elements State    css=button.login-btn    visible    timeout=5s

    # --- Login ---
    Fill Text    id=email    ${EMAIL_UNICO}
    Fill Text    id=password    ${PASSWORD}
    Click        css=button.login-btn
    Wait For Elements State    text="Login realizado com sucesso!"    visible    timeout=10s

*** Keywords ***
Configurar Teste
    ${TIMESTAMP}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${EMAIL_UNICO}=    Set Variable    testefluxo${TIMESTAMP}@teste.com
    Set Test Variable    ${EMAIL_UNICO}
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page    ${FRONT_URL}register

Finalizar Teste
    Run Keyword If Test Failed    Take Screenshot
    Close Page
    Close Context
