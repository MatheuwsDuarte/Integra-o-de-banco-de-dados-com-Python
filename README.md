# 📊 Integração Python e MySQL: Análise de Geração de Energia

Este projeto demonstra a integração entre um banco de dados **MySQL** e **Python** para análise de dados de energia elétrica. O script consulta registros de geração, processa os dados utilizando `pandas` e gera um gráfico comparativo visual com `matplotlib`.

## 📂 Estrutura do Projeto

* `main.py`: Script principal que conecta ao banco, processa os dados e gera o gráfico.
* `database_setup.sql`: Script SQL contendo a criação do banco de dados, tabelas e dados de teste.

## 🚀 Funcionalidades

* **Conexão Segura:** Utiliza SQLAlchemy e MySQL Connector.
* **Consultas Relacionais:** Executa queries SQL com `JOIN` para relacionar geradores e registros.
* **Manipulação de Dados:** Uso de `Pandas` (Pivot Table) para estruturar os dados para plotagem.
* **Visualização:** Gráfico de linhas comparativo (Data x Energia kWh) gerado pelo `Matplotlib`.

## 🛠️ Tecnologias Utilizadas

* [Python 3](https://www.python.org/)
* [Pandas](https://pandas.pydata.org/)
* [Matplotlib](https://matplotlib.org/)
* [SQLAlchemy](https://www.sqlalchemy.org/)
* [MySQL Connector](https://dev.mysql.com/doc/connector-python/en/)

## 📋 Pré-requisitos e Instalação

### 1. Instalar dependências
Certifique-se de ter o Python instalado. No terminal, execute:

```bash
pip install pandas sqlalchemy matplotlib mysql-connector-python

## ⚙️ Configuração
No arquivo Python principal, localize a seção de conexão e altere as credenciais conforme o seu ambiente local:

user = 'root'       # Seu usuário do MySQL
password = '1234'   # Sua senha do MySQL
host = 'localhost'
database = 'energia'

##▶️ Como Executar
Clone este repositório.

Certifique-se de que o MySQL esteja rodando e o banco foi criado.

Execute o script:

Bash
python main.py
