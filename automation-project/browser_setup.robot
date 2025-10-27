*** Settings ***
Library    Browser
Resource   variables.robot

*** Keywords ***
Abrir Cinema Web
    [Documentation]    Abre o navegador e acessa a URL do frontend.
    New Browser    ${BROWSER}    headless=False
    New Context
    New Page    ${FRONT_URL}

Fechar Cinema Web
    [Documentation]    Fecha o navegador aberto pelo teste.
    Close Browser
