import pandas as pd
from faker import Faker
from sqlalchemy import create_engine
from sqlalchemy import text
import random

# Conexão com o banco
USER = "postgres.gneshfqbwzjpnfrzdvrf"
PASSWORD = "bancodedados"
HOST = "aws-0-sa-east-1.pooler.supabase.com"
PORT = "5432"
DBNAME = "postgres"
DATABASE_URL = f"postgresql+psycopg2://{USER}:{PASSWORD}@{HOST}:{PORT}/{DBNAME}?sslmode=require"

engine = create_engine(DATABASE_URL)
fake = Faker('pt_BR')

# 1. Confederacoes
confederacoes = [
    {"nome": "CONMEBOL", "localidade": "América do Sul"},
    {"nome": "UEFA", "localidade": "Europa"},
    {"nome": "CONCACAF", "localidade": "América do Norte"},
    {"nome": "CBF", "localidade": "Ásia"},
]
df_conf = pd.DataFrame(confederacoes)
df_conf.to_sql("confederacoes", engine, if_exists="append", index=False)

# 2. Campeonatos
df_conf_ids = pd.read_sql("SELECT id_conf FROM confederacoes", engine)
campeonatos = []
for _ in range(10):
    campeonatos.append({
        "nome": fake.word().capitalize() + " Championship",
        "premiacao": round(random.uniform(500000, 5000000), 2),
        "id_conf": random.choice(df_conf_ids["id_conf"])
    })
pd.DataFrame(campeonatos).to_sql("campeonatos", engine, if_exists="append", index=False)

# 3. Clubes
clubes = []
paises = ["Brasil", "Espanha", "Inglaterra", "Alemanha", "Itália", "França", "Argentina", "México"]
for _ in range(20):
    clubes.append({
        "nome": fake.city() + " FC",
        "ano_de_fundacao": random.randint(1900, 2020),
        "pais_de_origem": random.choice(paises),
        "patrocinio": fake.company()
    })
pd.DataFrame(clubes).to_sql("clubes", engine, if_exists="append", index=False)

# IDs para referências
df_clubes_ids = pd.read_sql("SELECT id_clube FROM clubes", engine)

# 4. Clube_Confederacao
clube_conf = []
for _ in range(30):
    clube_conf.append({
        "id_clube": random.choice(df_clubes_ids["id_clube"]),
        "id_conf": random.choice(df_conf_ids["id_conf"])
    })
pd.DataFrame(clube_conf).drop_duplicates().to_sql("clube_confederacao", engine, if_exists="append", index=False)

# 5. Campeonato_Clube
df_camp_ids = pd.read_sql("SELECT id_campeonato FROM campeonatos", engine)
camp_clube = set()
camp_clube_data = []

while len(camp_clube) < 40:
    id_campeonato = random.choice(df_camp_ids["id_campeonato"])
    id_clube = random.choice(df_clubes_ids["id_clube"])
    par = (id_campeonato, id_clube)

    if par not in camp_clube:
        camp_clube.add(par)
        camp_clube_data.append({
            "id_campeonato": id_campeonato,
            "id_clube": id_clube,
            "titulos": random.randint(0, 10)
        })

pd.DataFrame(camp_clube_data).to_sql("campeonato_clube", engine, if_exists="append", index=False)

# 6. Comissões Técnicas
comissoes = []
for _ in range(15):
    comissoes.append({
        "nome_tecnico": fake.name_male(),
        "nome_auxiliar": fake.name_male(),
        "qtd_membros": random.randint(3, 10),
        "id_clube": random.choice(df_clubes_ids["id_clube"])
    })
pd.DataFrame(comissoes).to_sql("comissoes_tecnicas", engine, if_exists="append", index=False)

# 7. Jogadores com atributos coerentes
posicoes = ["Goleiro", "Zagueiro", "Lateral", "Volante", "Meia", "Atacante"]

def gerar_atributos_por_posicao(posicao):
    if posicao == "Goleiro":
        return {"finalizacao": random.randint(0, 20),
                 "defesa": random.randint(70, 100),
                   "fisico": random.randint(50, 100)}
    elif posicao == "Zagueiro":
        return {"finalizacao": random.randint(10, 40),
                 "defesa": random.randint(70, 100),
                   "fisico": random.randint(60, 100)}
    elif posicao == "Lateral":
        return {"finalizacao": random.randint(30, 60),
                 "defesa": random.randint(50, 80),
                   "fisico": random.randint(60, 100)}
    elif posicao == "Volante":
        return {"finalizacao": random.randint(30, 60),
                 "defesa": random.randint(60, 90),
                   "fisico": random.randint(60, 100)}
    elif posicao == "Meia":
        return {"finalizacao": random.randint(50, 80),
                 "defesa": random.randint(30, 60),
                   "fisico": random.randint(50, 90)}
    elif posicao == "Atacante":
        return {"finalizacao": random.randint(60, 100),
                 "defesa": random.randint(10, 40),
                   "fisico": random.randint(50, 90)}

jogadores = []
for _ in range(200):
    pos = random.choice(posicoes)
    atributos = gerar_atributos_por_posicao(pos)
    jogadores.append({
        "nome": fake.name_male(),
        "idade": random.randint(17, 40),
        "numero": random.randint(1, 99),
        "finalizacao": atributos["finalizacao"],
        "defesa": atributos["defesa"],
        "fisico": atributos["fisico"],
        "posicao": pos,
        "valor_de_mercado": round(random.uniform(100000, 50000000), 2),
        "id_clube": random.choice(df_clubes_ids["id_clube"])
    })
pd.DataFrame(jogadores).to_sql("jogadores", engine, if_exists="append", index=False)
