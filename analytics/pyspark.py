# pyspark
# load json to parquet

from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

spark = SparkSession.builder.appName("json2parquet").getOrCreate()

schema = StructType([
    StructField("name", StringType(), True),
    StructField("age", IntegerType(), True),
    StructField("city", StringType(), True),
    StructField("state", StringType(), True),

])

df = spark.read.json("people.json", schema=schema)
df.show()

df.write.parquet("people.parquet")