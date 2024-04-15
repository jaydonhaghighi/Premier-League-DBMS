import json
import psycopg

def load_data(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def insert_data(data, connection_params):
    with psycopg.connect(**connection_params) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT season_id FROM seasons")
            existing_season_ids = {row[0] for row in cur.fetchall()}

            insert_season_sql = '''
            INSERT INTO seasons (season_id, season_name)
            VALUES (%s, %s) ON CONFLICT (season_id) DO NOTHING;
            '''
            insert_competition_sql = '''
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
                if item["season_id"] not in existing_season_ids:
                    cur.execute(insert_season_sql, (item["season_id"], item["season_name"]))
                    existing_season_ids.add(item["season_id"])

                cur.execute(insert_competition_sql, (
                    item["competition_id"], item["season_id"], item["country_name"], item["competition_name"],
                    item["competition_gender"], item["competition_youth"], item["competition_international"],
                    item["season_name"], item["match_updated"], item.get("match_updated_360"), item.get("match_available_360"),
                    item["match_available"]
                ))

            conn.commit()
            print("Data has been successfully loaded into the database.")

if __name__ == "__main__":
    
    file_path = 'open-data-master/data/competitions.json'

    connection_params = {
        "dbname": "project_database",
        "user": "postgres",
        "password": "1234",
        "host": "localhost",
        "port": "5432"
    }

    data = load_data(file_path)
    insert_data(data, connection_params)

