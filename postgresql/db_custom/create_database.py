import psycopg2
from psycopg2 import sql
import os

def connect_to_postgres(host, dbname, user, password, port, ssl_cert):
    """
    Connects to PostgreSQL with SSL.
    """
    try:
        conn = psycopg2.connect(
            host=host,
            dbname=dbname,
            user=user,
            password=password,
            port=port,
            sslmode='require',  # Enables SSL verification
            sslrootcert=ssl_cert    # Path to the CA certificate
        )
        print(f"Connected to PostgreSQL database: {dbname}")
        return conn
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None

def create_database(conn, new_db_name):
    """
    Creates a new database if it does not exist.
    """
    try:
        conn.autocommit = True
        cursor = conn.cursor()
        
        # Check if the database exists
        cursor.execute("SELECT 1 FROM pg_database WHERE datname = %s;", (new_db_name,))
        exists = cursor.fetchone()
        
        if not exists:
            cursor.execute(sql.SQL("CREATE DATABASE {};").format(sql.Identifier(new_db_name)))
            print(f"Database {new_db_name} created successfully!")
        else:
            print(f"Database {new_db_name} already exists.")
        
        cursor.close()
    except psycopg2.Error as e:
        print(f"Error creating database: {e}")
    
if __name__ == "__main__":
    # Read environment variables (set by Terraform's local-exec)
    host = os.environ['HOST']
    dbname = "postgres"  # Connect to the default 'postgres' database first
    user = os.environ['MASTER_USER']
    password = os.environ['MASTER_PASSWORD']
    port = os.environ['PORT']
    ssl_cert = os.path.join(os.path.dirname(__file__), "oci_pg_cert.pem")  # Certificate file
    new_db_name = os.environ['DATABASE']  # The new database to create
    
    conn = connect_to_postgres(host, dbname, user, password, port, ssl_cert)
    if conn:
        create_database(conn, new_db_name)
        conn.close()

