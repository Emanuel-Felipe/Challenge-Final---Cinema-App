# 🎬 Projeto de Automação de Testes — Cinema App

## 🧩 Visão Geral
Este repositório contém uma suíte completa de automação de testes para o sistema Cinema App, cobrindo tanto o Back-End (API) quanto o Front-End (UI).  
Os testes garantem a integridade das funcionalidades críticas — autenticação, listagem de filmes e sessões, reservas e fluxos de usuário — assegurando qualidade e confiabilidade na experiência final.

A automação foi desenvolvida com Robot Framework, utilizando:
- RequestsLibrary para testes de API
- Browser (Playwright) para testes de UI

---

## 📁 Estrutura do Projeto
Estrutura principal do repositório:

```
cinema-tests/
│
├── resources/                 # Variáveis globais e configurações
│   └── variables.robot
│
├── tests/                     # Suítes de testes
│   ├── api/
│   │   ├── auth_api.robot
│   │   ├── movies_api.robot
│   │   ├── sessions_api.robot
│   │   ├── reservations_api.robot
│   │   └── auth_advanced.robot
│   │
│   └── ui/
│       ├── login_ui.robot
│       ├── booking_flow.robot
│       ├── register_login_flow.robot
│       └── profile_update_ui.robot
│
├── results_priority1/         # Relatórios de execução
│   ├── output.xml
│   ├── log.html
│   └── report.html
│
└──.gitignore

```

---

## ⚙️ Requisitos
Antes de executar os testes, verifique se os seguintes componentes estão instalados:

| Ferramenta        | Versão Recomendada | Descrição                                |
|-------------------|--------------------|------------------------------------------|
| Python            | 3.9+               | Linguagem base do Robot Framework        |
| Node.js           | 16+                | Requisito do Playwright                  |
| Robot Framework   | 7.0+               | Framework de automação                   |
| Playwright        | Última             | Automação de UI                          |
| RequestsLibrary   | Última             | Automação de APIs                        |
| Browser Library   | Última             | Automação de UI (Playwright)             |

---

## 📦 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/Emanuel-Felipe/Challenge-Final---Cinema-App.git
cd cinema-tests
```

2. Instale as dependências:
```bash
pip install robotframework robotframework-browser robotframework-requests
```

3. Inicialize o Playwright para o Robot Framework:
```bash
rfbrowser init
```

---

## 🚀 Execução dos Testes

### 🔹 Testes de API
Executa todos os testes de backend:
```bash
robot tests/api
```

Executa um módulo específico:
```bash
robot tests/api/auth_api.robot
```

### 🔹 Testes de UI
Executa todos os testes da interface web:
```bash
robot tests/ui
```

### 🔹 Execução Completa (API + UI)
Executa ambas as suítes e gera relatórios na pasta de resultados:
```bash
robot --outputdir results_priority1 --report report_priority1.html --log log_priority1.html tests
```

### 📊 Relatórios gerados automaticamente em:
- results_priority1/report_priority1.html
- results_priority1/log_priority1.html

---

## 🧪 Cobertura de Testes

### 🔸 API (Back-End)
Módulos e casos cobertos:
| Módulo         | Casos de Teste Implementados |
|----------------|-------------------------------|
| Autenticação   | Login válido, login inválido, token inválido, acesso não autorizado |
| Filmes         | Listagem geral, busca por ID válido e inválido |
| Sessões        | Listagem, busca por ID, filtro por filme |
| Reservas       | Criação de reserva válida, assento ocupado, sem autenticação, listagem do usuário |
| Testes Negativos | Recurso inexistente (404), payload inválido (400), token expirado/inválido (401) |

### 🔸 UI (Front-End)
Fluxos e casos cobertos:
| Módulo         | Fluxos Testados |
|----------------|------------------|
| Autenticação   | Cadastro, login e logout completos |
| Perfil         | Atualização de nome do usuário |
| Reservas       | Login → Seleção de filme → Sessão → Assento → Pagamento (E2E completo) |

---

## 📚 Documentação Complementar
Na pasta `Documentação/` estão disponíveis os artefatos produzidos:

| Arquivo | Conteúdo |
|---------|----------|
| Mapa Mental - Cinema App | Estrutura funcional e lógica do sistema |
| Plano de Testes - Cinema App | Estratégia de testes, escopo e priorização |
| Relatório Técnico de Automação de Testes – Sistema Cinema | Descrição detalhada dos testes desenvolvidos |
| Relatório de Issues e Melhorias - Cinema App | Lista de bugs e sugestões de melhoria |

---

## 🧠 Boas Práticas e Arquitetura
- Estrutura modular e escalável
- Keywords reutilizáveis e bem documentadas
- Testes independentes
- Identificadores dinâmicos para evitar conflitos entre execuções
- Captura automática de screenshots em falhas
- Padronização de asserts e mensagens de log
- Integração facilitada com pipelines CI/CD

---

## 📈 Resultados e Métricas
- ✅ 100% de sucesso nas execuções da suíte principal
- 🧩 Cobertura completa dos fluxos críticos de negócio
- ⚙️ Automação integrada e estável entre API e UI
- 📊 Relatórios detalhados com logs e evidências
- 💡 Base sólida para futuras expansões e integração contínua

---

## 👨‍💻 Autor
Desenvolvido por: Emanuel Felipe Avelino Solva  
Desafio: Cinema App – Projeto de Automação de Testes  
Tecnologias: Robot Framework | Playwright | RequestsLibrary | Python
