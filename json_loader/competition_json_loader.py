import json
import psycopg

def load_data(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def insert_data(data, connection_params):
    with psycopg.connect(**connection_params) as conn:
        with conn.cursor() as cur:

            insert_sql = '''
            INSERT INTO competitions (
                competition_id, season_id, country_name, competition_name, competition_gender,
                competition_youth, competition_international, season_name, match_updated, match_updated_360,
                match_available_360, match_available
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (competition_id, season_id) DO UPDATE SET
                country_name = EXCLUDED.country_name,
                competition_name = EXCLUDED.competition_name,
                competition_gender = EXCLUDED.competition_gender,
                competition_youth = EXCLUDED.competition_youth,
                competition_international = EXCLUDED.competition_international,
                season_name = EXCLUDED.season_name,
                match_updated = EXCLUDED.match_updated,
                match_updated_360 = EXCLUDED.match_updated_360,
                match_available_360 = EXCLUDED.match_available_360,
                match_available = EXCLUDED.match_available;
            '''
            for item in data:
                cur.execute(insert_sql, (
                    item["competition_id"], item["season_id"], item["country_name"], item["competition_name"],
                    item["competition_gender"], item["competition_youth"], item["competition_international"],
                    item["season_name"], item["match_updated"], item.get("match_updated_360"), item.get("match_available_360"),
                    item["match_available"]
                ))

            conn.commit()
            print("Data has been successfully loaded into the database.")


            
# def fetch_data(connection_params):
#     with psycopg.connect(**connection_params) as conn:
#         with conn.cursor() as cur:
#             
#             cur.execute("SELECT * FROM competitions;")
            
#             
#             rows = cur.fetchall()
            
#             
#             for row in rows:
#                 print(row)

if __name__ == "__main__":
    
    file_path = 'open-data-master/data/competitions.json'

    # Database connection parameters
    connection_params = {
        "dbname": "project_database",
        "user": "postgres",
        "password": "1234",
        "host": "localhost",
        "port": "5432"
    }

    # Load data from JSON file
    data = load_data(file_path)

    # Insert data into the database
    insert_data(data, connection_params)

    # Fetch and display the data
    # fetch_data(connection_params)
