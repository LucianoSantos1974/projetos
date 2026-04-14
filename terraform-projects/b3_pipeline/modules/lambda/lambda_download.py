# 1- Caminho pra baixar os tres tipos de Arquivo
# 2- Verificar se o dia é comercial (seg a sex)
# 3- Cada tipo tem a sua propria pasta na raw
# 4- Verificar se o arquivo não esta vazio.
# 5- Salvar em partição

import urllib.request
import boto3
from datetime import datetime
from zoneinfo import ZoneInfo
import base64
import os, json

s3 = boto3.client('s3')
bucket_name  = os.environ['BUCKET_NAME']
origin_files = os.environ['PATH_FILE']

def lambda_handler(event, context):
    v_today_origin = datetime.now(ZoneInfo("America/Sao_Paulo")).date()

    if v_today_origin.weekday() < 5:
        v_today = v_today_origin.strftime("%Y-%m-%d")
        v_today_compact = v_today_origin.strftime("%Y%m%d")

        ## DI X PRE, AJUSTE PRE, DI X TR
        ## Matriz com taxas
        ## v_matriz_tax = ["PRE","APR","TR"]
        matriz_tax_json = os.environ.get("MATRIZ_TAX", "[]")
        v_matriz_tax = json.loads(matriz_tax_json)
        files = []
        files_empty = []

        for tax in v_matriz_tax:
            try:
                payload = f'{{"language":"pt-br","date":"{v_today}","id":"{tax}"}}'
                encoded = base64.b64encode(payload.encode()).decode()
                url = f"{origin_files}{encoded}"
                file_name = f"TaxaReferencia_{tax}_{v_today_compact}.csv"
                partition_tax = f"taxa={tax}"
                partition_date = f"data_execucao={v_today}"
                req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})

                # Faz o download
                with urllib.request.urlopen(req) as response:
                    content = response.read()

                # Verifica se o arquivo esta vazio
                if not content:
                    files_empty.append(file_name)
                else:
                    # Decodifica de Base64 para bytes do CSV
                    decoded_bytes = base64.b64decode(content)

                    # Envia para o S3
                    s3.put_object(
                        Bucket=bucket_name,
                        Key=f"raw/input/{partition_tax}/{partition_date}/{file_name}",
                        Body=decoded_bytes,
                        ContentType="text/csv; charset=latin-1"
                    )

                    files.append(file_name)

            except Exception as e:
                # Loga erro mas continua o loop
                print(f"Erro ao processar {tax}: {e}")

        return {
            "statusCode": 200,
            "body": json.dumps({
                                "arquivos_enviados": f"Arquivos enviados {', '.join(files)} com sucesso!",
                                "arquivos_vazio": f"Arquivos vazio {', '.join(files_empty)} ",
                                })
        }

    else:
        return {
            "statusCode": 200,
            "body": f"Arquivos não foram baixado por ser final de semana!"
        }
