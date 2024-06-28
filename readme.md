# Automação de testes para funcão basica no site ponto frio

# Índice 
* [Pré requisitos] (#Pré-requisitos)
* [Instalação do Robot Framework] (#Instalação-do-Robot-Framework)
* [Instalação do Playwright] (#Instalação-do-Playwright)
* [Executando Automações] (#Executando-Automações)

# Pré requisitos
Antes de começar, certifique-se de que você tenha os seguintes requisitos instalados em seu sistema:
•	Python (versão 3.11 recomendada)
•	pip (gerenciador de pacotes do Python)
•	Node.js (versão 12.x ou superior)
# Instalação do Robot Framework
O Robot Framework pode ser instalado via pip, que é o gerenciador de pacotes do Python.
1.	Instale o Robot Framework: 
2.	Instale o Robot Framework Playwright Library:
O Robot Framework Playwright Library é necessário para integrar com o Playwright.
pip install --upgrade robotframework-playwrightlibrary

# Instalação do Playwright
Playwright é uma ferramenta para automação de testes em navegadores web.
1.	Instale o Playwright via npm:
    npm install -g playwright

2.	Instale o Playwright para o navegador Chromium:
    playwright install

# Executando Automações
Para executar seus testes ou automações, utilize o comando robot seguido do nome do arquivo de teste:
    robot -d .\results .\src\test\test_espec_quality.robot
