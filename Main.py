import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt

# Configuração da conexão com o banco de dados MySQL
user = 'root'
password = '1234' 
host = 'localhost' 
database = 'energia'

# String de conexão
conn_str = f'mysql+mysqlconnector://{user}:{password}@{host}/{database}'
engine = create_engine(conn_str) #cria o engine de conexão

try:
    # CONSULTAR DADOS
    print("Conectando ao banco e buscando dados...")
    # JOIN para o gráfico ficar com os nomes, não só IDs
    sql = """
    SELECT 
        rg.data_registro,
        g.nome_gerador,
        rg.geracao_energia_kWh
    FROM tb_registro_geracao rg
    JOIN tb_gerador g ON rg.id_gerador = g.id_gerador
    ORDER BY rg.data_registro;
    """
    
    df = pd.read_sql(sql, engine) # Lê os dados da consulta para um DataFrame
    
    # Preparar dados para o gráfico
    # Transforma nomes dos geradores em colunas
    # Transformando a tabela:
    # Linhas (Index) = Datas
    # Colunas = Nome do Gerador
    # Valores = Energia
    df_grafico = df.pivot(index='data_registro', columns='nome_gerador', values='geracao_energia_kWh') # Cria a tabela para o gráfico
    
    # Plotar gráfico
    print("Gerando gráfico...")
    ax = df_grafico.plot(kind='line', figsize=(12, 6), marker='.') # Gráfico de linhas com marcadores
    plt.title('Comparativo de Geração de Energia (Janeiro 2024)')
    plt.ylabel('Energia (kWh)')
    plt.xlabel('Data')
    plt.grid(True, linestyle='--', alpha=0.5) # Adiciona grade ao gráfico
    plt.legend(title='Geradores', bbox_to_anchor=(1.05, 1), loc='upper left') # Legenda fora do gráfico
    
    # Salvar em arquivo ou mostrar na tela
    plt.tight_layout() # Ajusta o layout para não cortar nada
    plt.show() # Exibe o gráfico na tela
    
except Exception as e:
    print(f"Ocorreu um erro: {e}")