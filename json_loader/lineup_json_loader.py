import psycopg
import json
import os

def load_data_to_db(file_path, conn_params):
    with open(file_path, 'r') as file:
        data = json.load(file)

    with psycopg.connect(**conn_params) as conn:
        with conn.cursor() as cur:
            for team in data:
                team_id = team['team_id']
                team_name = team['team_name']

                cur.execute("""
                    INSERT INTO teams (team_id, team_name)
                    VALUES (%s, %s)
                    ON CONFLICT (team_id) DO UPDATE SET
                    team_name = EXCLUDED.team_name;
                """, (team_id, team_name))

                for player in team['lineup']:
                    player_id = player['player_id']
                    player_name = player['player_name']
                    jersey_number = player.get('jersey_number')
                    country_data = player.get('country', {})

                    # Default values for country_id and country_name if 'country' key is missing
                    country_id = country_data.get('id')
                    country_name = country_data.get('name')

                    if country_id and country_name:
                        cur.execute("""
                            INSERT INTO countries (country_id, country_name)
                            VALUES (%s, %s)
                            ON CONFLICT (country_id) DO UPDATE SET
                            country_name = EXCLUDED.country_name;
                        """, (country_id, country_name))

                    cur.execute("""
                        INSERT INTO players (player_id, player_name, jersey_number, country_id, team_id)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (player_id) DO UPDATE SET
                        player_name = EXCLUDED.player_name,
                        jersey_number = EXCLUDED.jersey_number,
                        country_id = EXCLUDED.country_id,
                        team_id = EXCLUDED.team_id;
                    """, (player_id, player_name, jersey_number, country_id, team_id))

                    for position in player.get('positions', []):
                        position_id = position['position_id']
                        position_name = position['position']
                        start_time = position.get('from')
                        end_time = position.get('to')
                        from_period = position.get('from_period')
                        to_period = position.get('to_period')
                        start_reason = position.get('start_reason')
                        end_reason = position.get('end_reason')

                        cur.execute("""
                            INSERT INTO positions (position_id, position_name)
                            VALUES (%s, %s)
                            ON CONFLICT (position_id) DO UPDATE SET
                            position_name = EXCLUDED.position_name;
                        """, (position_id, position_name))

                        cur.execute("""
                            INSERT INTO player_positions (player_id, position_id, start_time, end_time, from_period, to_period, start_reason, end_reason)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
                        """, (player_id, position_id, start_time, end_time, from_period, to_period, start_reason, end_reason))
                conn.commit()

def main(directory_path, conn_params):
    for filename in os.listdir(directory_path):
        if filename.endswith('.json'):
            file_path = os.path.join(directory_path, filename)
            try:
                load_data_to_db(file_path, conn_params)
                print(f"Data from {filename} loaded successfully.")
            except Exception as e:
                print(f"Failed to load data from {filename}: {e}")

if __name__ == "__main__":
    file_path = 'open-data-master/data/lineups'
    connection_params = {
        "dbname": "project_database",
        "user": "postgres",
        "password": "1234",
        "host": "localhost",
        "port": "5432"
    }

    main(file_path, connection_params)
