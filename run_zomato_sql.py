
import pandas as pd
import sqlite3

# Load the CSV file
csv_path = "zomato.csv"  # Make sure this CSV is in the same directory
df = pd.read_csv(csv_path)

# Connect to SQLite and create DB
conn = sqlite3.connect("zomato.db")

# Import the CSV into a table named 'zomato'
df.to_sql("zomato", conn, if_exists="replace", index=False)
print("[✓] Data imported into 'zomato' table.")

# Run the SQL script
with open("zomato_project.sql", "r") as file:
    sql_script = file.read()

cursor = conn.cursor()
cursor.executescript(sql_script)
print("[✓] SQL queries executed successfully.")

# Optional: fetch and display a result
sample = cursor.execute("SELECT * FROM zomato LIMIT 5;").fetchall()
print("[✓] Sample output:")
for row in sample:
    print(row)

# Close connection
conn.close()
