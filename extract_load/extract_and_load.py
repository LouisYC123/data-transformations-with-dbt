
import pandas as pd
import os
import zipfile
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

POSTGRES_USER=os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD=os.getenv('POSTGRES_PASSWORD')
POSTGRES_DB='globalmarket' # Do not change
POSTGRES_SCHEMA='raw_data' # Do not change
DATA_DIR='/home/data/'
TARGET_ZIP = DATA_DIR + 'RawData.zip'

# Create postgres connection engine
engine = create_engine(f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@pg_container:5432/{POSTGRES_DB}")

# Extract
zf = zipfile.ZipFile(TARGET_ZIP)
datasets = {f:pd.read_csv(zf.open(f)) for f in zf.namelist() if 'MACOSX' not in f and f.endswith('.csv')}
print('Extract Complete')
for filename, df in datasets.items():
    filename = os.path.basename(filename).split('.')[0]
    # Load
    print(f'Loading {filename} data')
    df.to_sql(
        f'raw_{filename}_data', engine, index=False, if_exists="replace", schema=POSTGRES_SCHEMA
    )
print('load complete')
