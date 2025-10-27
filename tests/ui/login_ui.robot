*** Settings ***
Library    Browser
Resource   ../../resources/variables.robot

*** Variables ***
${EMAIL}       teste@gmail.com
${PASSWORD}    teste123

*** Test Cases ***
Login UI com credenciais válidas
    [Documentation]    Testa o login via interface web e valida mensagem de sucesso
    New Browser    chromium    headless=False
    New Context
    New Page       ${FRONT_URL}login

    # Preencher campos de login
    Fill Text      id=email       ${EMAIL}
    Fill Text      id=password    ${PASSWORD}
    Click          css=button.login-btn

    # Espera e validação
    Wait For Elements State    text="Login realizado com sucesso!"    visible    timeout=5s

    Close Browser
