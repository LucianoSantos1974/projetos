import sys
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import regexp_replace, regexp_extract, col, input_file_name
from pyspark.sql.types import DecimalType

# Funções auxiliares
def ler_csv(spark, path):
    df = spark.read \
                .option("header", True) \
                .option("delimiter", ";") \
                .option("encoding", "latin1") \
                .csv(path)
    df = df.withColumn("file_path", input_file_name())

    return df

def mudar_coluna(df):
    df = (
            df.withColumnRenamed("Descrição da Taxa","ds_taxa")
                .withColumnRenamed("Dias Úteis","nr_dias_uteis")
                .withColumnRenamed("Dias Corridos","nr_dias_corridos")
                .withColumnRenamed("Preço/Taxa","vl_preco_taxa")
        )
    df = df.withColumn("taxa", regexp_extract(col("file_path"), "taxa=([^/]+)", 1))
    df = df.withColumn("data_execucao", regexp_extract(col("file_path"), "data_execucao=([^/]+)", 1))
    df = df.drop("file_path")

    return df

def mudar_tipo(df):
    return (df.withColumn("nr_dias_uteis", col("nr_dias_uteis").cast("integer"))
              .withColumn("nr_dias_corridos", col("nr_dias_corridos").cast("integer"))
              .withColumn("vl_preco_taxa",
                          regexp_replace(col("vl_preco_taxa"), ",", ".")
                          .cast(DecimalType(38,2))))

def main():
    # Recupera parâmetros do job
    args = getResolvedOptions(sys.argv, ["ENV_RAW", "ENV_STAGE"])

    input_file_spark  = f"s3a://{args['ENV_RAW']}"
    output_file_spark = f"s3a://{args['ENV_STAGE']}"

    # Inicializa GlueContext e SparkSession
    sc = SparkContext()
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session

    # Tratamento e normalização
    df = ler_csv(spark, input_file_spark)
    df = mudar_coluna(df)
    df = mudar_tipo(df)

    # Salva em Parquet particionado
    df.write \
      .mode("append") \
      .partitionBy("taxa","data_execucao")\
      .parquet(output_file_spark)

if __name__ == "__main__":
    main()