*** Settings ***
Library    Browser
Resource   ../../resources/browser_setup.robot
Resource   ../../resources/variables.robot

*** Variables ***
${EMAIL}           teste@gmail.com
${PASSWORD}        teste123

*** Test Cases ***
Fluxo Completo de Reserva
    [Documentation]    Realiza login, seleciona filme, assento e finaliza compra
    New Browser    chromium    headless=False
    New Context
    New Page    ${FRONT_URL}login

    # Login
    Fill Text    id=email    ${EMAIL}
    Fill Text    id=password    ${PASSWORD}
    Click    css=button.login-btn
    Wait For Elements State    text="Login realizado com sucesso!"    visible    timeout=5s

    # Ver filmes em cartaz
    Click    css=a.btn-primary.btn-lg
    Wait For Elements State    css=a.btn-primary[href^="/movies/"] >> nth=0    visible    timeout=5s
    Click    css=a.btn-primary[href^="/movies/"] >> nth=0

    # Seleção de sessão e assento
    Wait For Elements State    css=a.btn-primary.session-button >> nth=0    visible    timeout=5s
    Click    css=a.btn-primary.session-button >> nth=0
    Wait For Elements State    css=button.seat.available >> nth=0    visible    timeout=5s
    Click    css=button.seat.available >> nth=0
    Wait For Elements State    css=button.checkout-button    visible    timeout=5s
    Click    css=button.checkout-button

    # Pagamento
    Wait For Elements State    css=div.payment-method >> nth=0    visible    timeout=5s
    Click    css=div.payment-method >> nth=0
    Wait For Elements State    css=button.btn-checkout    visible    timeout=5s
    Click    css=button.btn-checkout

    # Validação final
    Wait For Elements State    text="Reserva Confirmada!"    visible    timeout=10s

    Close Browser
