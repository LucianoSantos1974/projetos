# 📊 B3 Daily Data Ingestion Pipeline

## 📌 Overview

Este projeto implementa um pipeline de dados para ingestão diária de arquivos disponibilizados pela B3, com foco em confiabilidade, padronização e organização para consumo analítico.

O pipeline realiza a captura de três arquivos publicados diariamente no site da B3, armazenando-os na camada raw (Amazon S3) e aplicando transformações para padronização dos dados na camada core.

A execução é automatizada para ocorrer diariamente às 21h, sempre processando os dados mais recentes disponíveis.

---

## 🧠 Arquitetura

Fluxo de alto nível:

1. Orquestração via Step Functions
2. Execução de função Lambda para identificação e download dos arquivos mais recentes
3. Armazenamento dos arquivos na camada raw (S3), particionados por data
4. Processamento e padronização utilizando AWS Glue
5. Catalogação dos dados no Glue Data Catalog
6. Escrita dos dados tratados na camada core (S3)

Infraestrutura provisionada via Terraform.

---

## ⚙️ Stack Tecnológica

* AWS S3 (armazenamento - camadas raw e core)
* AWS Lambda (ingestão e controle de fluxo inicial)
* AWS Glue (processamento e transformação de dados)
* AWS Step Functions (orquestração do pipeline)
* AWS Glue Data Catalog (catalogação e metadados)
* Terraform (Infraestrutura como Código - IaC)
* Python (lógica de ingestão e transformação)

---

## 🔄 Pipeline / Fluxo de Dados

### 1. Orquestração

* Pipeline iniciado diariamente às 21h
* Step Functions coordena as etapas de ingestão e processamento

### 2. Ingestão (Lambda)

* Identificação do arquivo mais recente disponível no site da B3
* Download automatizado dos três arquivos diários
* Tratamento básico de falhas na obtenção dos arquivos

### 3. Camada Raw (S3)

* Armazenamento dos arquivos originais sem transformação
* Estrutura particionada por data (`dt=YYYY-MM-DD`)
* Garantia de rastreabilidade e reprocessamento

### 4. Processamento (Glue)

* Leitura dos arquivos da camada raw
* Padronização de nomes de colunas
* Ajuste de tipos de dados
* Normalização da estrutura entre os datasets

### 5. Camada Core (S3)

* Escrita dos dados tratados e padronizados
* Estrutura otimizada para consumo analítico
* Organização consistente entre execuções

### 6. Catalogação (Glue Data Catalog)
* Registro das tabelas geradas na camada core
* Estruturação de metadados para consulta e descoberta
* Integração com motores de consulta (ex: Athena)

---

## 🎯 Decisões Técnicas

* **Uso de Step Functions para orquestração**
  Permite controle explícito do fluxo, tratamento de erros e maior visibilidade do pipeline.

* **Separação de responsabilidades (Lambda + Glue)**
  Lambda para ingestão leve e Glue para processamento distribuído, evitando sobrecarga e melhorando escalabilidade.

* **Particionamento por data no S3**
  Melhora performance de leitura e reduz custo em consultas downstream.

* **Infraestrutura como Código com Terraform**
  Garante reprodutibilidade, versionamento e facilidade de evolução do ambiente.

* **Arquitetura em camadas (raw → core)**
  Facilita auditoria, reprocessamento e desacoplamento entre ingestão e consumo.

* **Uso do Glue Data Catalog**
  Centraliza metadados dos datasets, permitindo descoberta, governança e integração com ferramentas de consulta como Athena.
---

## ⚖️ Trade-offs

* **Glue vs soluções mais leves (ex: Lambda)**
  Glue adiciona overhead de inicialização, porém oferece melhor suporte para processamento de volumes maiores e transformações mais complexas.

* **Orquestração com Step Functions**
  Maior controle e observabilidade, com custo adicional e complexidade em relação a soluções mais simples.

* **Processamento batch diário**
  Adequado ao caso de uso da B3, porém não atende cenários de baixa latência.

---

## 🚀 Possíveis melhorias

* Implementação de **idempotência** para evitar reprocessamento duplicado
* Estratégia de **retry e tratamento de falhas mais robusto**
* Inclusão de **validações de qualidade de dados (data quality)**
* Monitoramento com métricas e alertas (CloudWatch)
* Evolução para ingestão baseada em eventos (quando aplicável)

---

## 📎 Observações

Este projeto simula um cenário real de engenharia de dados envolvendo ingestão de fontes externas não controladas, com necessidade de padronização, confiabilidade e organização para consumo analítico.

A abordagem adotada prioriza simplicidade inicial, mantendo espaço para evolução em termos de governança, observabilidade e resiliência.
