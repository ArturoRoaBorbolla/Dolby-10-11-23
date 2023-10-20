import csv
import pandas as pd
import sqlite3
import sys
import os
from time import sleep
import logging


PRO_DIR = os.path.dirname(os.path.abspath(__file__))
print(PRO_DIR)
ROOT_DIR = f"{PRO_DIR}\\Input"

database = 'Dolby.db'
db_file = database
connection=sqlite3.connect(database)
cursor=connection.cursor()

formatter = logging.Formatter('%(levelname)-8s %(asctime)s %(message)s',datefmt='%Y/%m/%d %I:%M:%S')
LogsPath = f"{PRO_DIR}\\Logs" 
os.makedirs(LogsPath, exist_ok=True)
logpath= f"{LogsPath}\\Xlsx2DB.log"  
handler = logging.FileHandler(filename=logpath)
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.addHandler(handler)



CR1_folder=f"{ROOT_DIR}\\CR_1"
CR2_folder=f"{ROOT_DIR}\\CR_2"
Departments_folder=f"{ROOT_DIR}\\Departments"


CR1_files = os.listdir(CR1_folder)
CR2_files = os.listdir(CR2_folder)
Dpt_files = os.listdir(Departments_folder)


def import_data_into_table(data_file):
    table_name, extension = os.path.splitext(data_file)
    cursor.execute(f'DROP TABLE IF EXISTS {table_name}')
    if extension == '.csv':
        # Import CSV data using csv module
        with open(os.path.join(data_path, data_file), 'r', newline='' , encoding='utf-8-sig') as csvfile:
            csv_reader = csv.reader(csvfile)
            header = next(csv_reader)  # Assume the first row contains column names
            print(header)
            create_table_sql = f'CREATE TABLE {table_name} ({", ".join(header)})'
            print(create_table_sql)
            cursor.execute(create_table_sql)
            # Insert data from the CSV file into the table
            for row in csv_reader:
                cursor.execute(f'INSERT INTO {table_name} VALUES ({", ".join("?" * len(row))})', row)
    elif extension == '.xlsx':
        # Import XLSX data using pandas
        df = pd.read_excel(os.path.join(data_path, data_file))

        # Save the DataFrame to the SQLite database
        df.to_sql(table_name, conn, if_exists='replace', index=False)

    connection.commit()



try:
        drop_query = f'DROP TABLE IF EXISTS CR_1'
        cursor.execute(drop_query)
        drop_query = f'DROP TABLE IF EXISTS CR_2'
        cursor.execute(drop_query)
        for file in CR1_files:
                tabs = pd.ExcelFile(f'{CR1_folder}\\{file}').sheet_names
                for tab in tabs:
                        print(f"Trying to insert {tab}")
                        skip_rows=0
                        while True:
                                excel_df = pd.read_excel(f'{CR1_folder}\\{file}',skiprows=[skip_rows],sheet_name=tab)
                                columns = excel_df.head()
                                print(columns)
                                if 'Approval Status' in columns:
                                        break
                                else:
                                        skip_rows+=1
                        #print("Out of the while")
                        Table_query = f'CREATE TABLE IF NOT EXISTS CR_1 ('
                        Table_query +=''.join(f'{x.replace(" ","_").replace("/","_").replace("(","_").replace(")","_").replace("-","_").replace("#","_").replace(".","_")} Text,' for x in excel_df.head())
                        Table_query = Table_query[:-1] 
                        Table_query +=')'
                        print(Table_query)
                        cursor.execute(Table_query)
                        error_count=0
                        count=0
                        for index, row in excel_df.iterrows():
                            try:
                                converted = [x.replace("\"","") if type(x) is str else x.date().strftime("%Y%m%d") if type(x) is pd._libs.tslibs.timestamps.Timestamp else x  for x in row]       
                                Insert= f'INSERT INTO CR_1 VALUES ('
                                Insert += ''.join(f'"{x}",' for x in converted)
                                Insert = Insert[:-1]
                                Insert += ')' 
                                cursor.execute(Insert)
                                count+=1
                            except:
                                error_count+=1
                        connection.commit()
                        print(f" There was {error_count} Errors on insert. {count} Inserted , {error_count/count} Percentage of Error on inserted..... {tab} inserted on DB")
                        
        print("\n\n\nCR_1 Finished\n\n\n")
        sleep(5)




        for file in CR2_files:
                tabs = pd.ExcelFile(f'{CR2_folder}\\{file}').sheet_names
                for tab in tabs:
                        print(f"Trying to insert {tab}")
                        skip_rows=0
                        while True:
                                excel_df = pd.read_excel(f'{CR2_folder}\\{file}',skiprows=[skip_rows])
                                columns = excel_df.head()
                                print(columns)
                                if 'Employee' in columns:
                                        break
                                else:
                                        skip_rows+=1
                        Table_query = f'CREATE TABLE IF NOT EXISTS CR_2 ('
                        Table_query +=''.join(f'{x.replace(" ","_").replace("/","_").replace("(","_").replace(")","_").replace("-","_").replace("#","_").replace(".","_")} Text,' for x in excel_df.head())
                        Table_query = Table_query[:-1] 
                        Table_query +=')'
                        print(Table_query)
                        cursor.execute(Table_query)
                        error_count=0
                        count=0
                        for index, row in excel_df.iterrows():
                            try:
                                converted = [x.replace("\"","") if type(x) is str else x.date().strftime("%Y%m%d") if type(x) is pd._libs.tslibs.timestamps.Timestamp else x  for x in row]       
                                Insert= f'INSERT INTO CR_2 VALUES ('
                                Insert += ''.join(f'"{x}",' for x in converted)
                                Insert = Insert[:-1]
                                Insert += ')' 
                                cursor.execute(Insert)
                                count+=1
                            except:
                                error_count+=1
                        connection.commit()
                        #connection.close()
                        print(f"  There was {error_count} Errors on insert. {count} Inserted , {error_count/count} Percentage of Error on inserted... {tab} inserted on DB")
                        
        print("\n\n\nCR_2 Finished\n\n\n")
        sleep(5)





        data_path = f'{ROOT_DIR}\\Ext'
        data_files = [f for f in os.listdir(data_path) if f.endswith('.csv') or f.endswith('.xlsx')]

        for data_file in data_files:
            import_data_into_table(data_file)

        connection.close()

        print("Data files imported into AIVER SQLite database.")
        sys.exit(0)

except Exception as err:
    print(f"Error::::: {err}")
    logger.error(str(err) + "   -   " + "Error on line {}".format(sys.exc_info()[-1].tb_lineno))
    sys.exit(-1)