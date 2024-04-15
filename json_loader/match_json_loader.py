import psycopg
import json
import os

def load_data_to_db(file_path, conn_params):
    with open(file_path, 'r') as file:
        matches = json.load(file)

    with psycopg.connect(**conn_params) as conn:
        with conn.cursor() as cur:
            for match in matches:
                # Season data
                season = match['season']
                cur.execute("""
                    INSERT INTO seasons (season_id, season_name)
                    VALUES (%s, %s)
                    ON CONFLICT (season_id) DO NOTHING;
                """, (season['season_id'], season['season_name']))

                # Competition data
                competition = match['competition']
                cur.execute("""
                    INSERT INTO competitions (
                        competition_id, season_id, country_name, competition_name,
                        competition_gender, competition_youth, competition_international,
                        season_name, match_updated, match_updated_360, match_available_360, match_available
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (competition_id, season_id) DO NOTHING;
                """, (
                    competition['competition_id'], season['season_id'],
                    competition['country_name'], competition['competition_name'],
                    competition.get('competition_gender', 'unknown'),
                    competition.get('competition_youth', False),
                    competition.get('competition_international', False),
                    season['season_name'],
                    None, None, None, None 
                ))

                # Team data for both home and away
                for team_key in ['home_team', 'away_team']:
                    team = match[team_key]
                    team_id = team[team_key + '_id']
                    team_name = team[team_key + '_name']
                    team_gender = team.get(team_key + '_gender', 'unknown')
                    team_group = team.get(team_key + '_group', None) 

                    cur.execute("""
                        INSERT INTO teams (team_id, team_name, team_gender, team_group)
                        VALUES (%s, %s, %s, %s)
                        ON CONFLICT (team_id) DO UPDATE SET
                            team_name = EXCLUDED.team_name,
                            team_gender = EXCLUDED.team_gender,
                            team_group = EXCLUDED.team_group;
                    """, (team_id, team_name, team_gender, team_group))

                    # Manager data for each team
                    for manager in team.get('managers', []):
                        cur.execute("""
                            INSERT INTO managers (manager_id, name, nickname, dob, country_id)
                            VALUES (%s, %s, %s, %s, %s)
                            ON CONFLICT (manager_id) DO NOTHING;
                        """, (manager['id'], manager['name'], manager.get('nickname', 'N/A'), manager['dob'], manager['country']['id']))

                        # Link team and manager
                        cur.execute("""
                            INSERT INTO team_managers (team_id, manager_id)
                            VALUES (%s, %s)
                            ON CONFLICT DO NOTHING;
                        """, (team[team_key + '_id'], manager['id']))

                # Stadium data
                stadium = match.get('stadium')
                if stadium:
                    cur.execute("""
                        INSERT INTO stadiums (stadium_id, name, country_id)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (stadium_id) DO NOTHING;
                    """, (stadium['id'], stadium['name'], stadium['country']['id']))

                # Referee data
                referee = match.get('referee')
                if referee:
                    cur.execute("SELECT 1 FROM countries WHERE country_id = %s", (referee['country']['id'],))
                    if cur.fetchone() is None:
                        print(f"Inserting missing country: ID={referee['country']['id']}, Name={referee['country']['name']}")
                        cur.execute(
                            "INSERT INTO countries (country_id, country_name) VALUES (%s, %s)",
                            (referee['country']['id'], referee['country']['name'])
                        )

                    cur.execute("""
                        INSERT INTO referees (referee_id, name, country_id)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (referee_id) DO NOTHING;
                    """, (referee['id'], referee['name'], referee['country']['id']))

                # Competition stage data
                stage = match['competition_stage']
                
                cur.execute("""
                    INSERT INTO competition_stages (stage_id, name)
                    VALUES (%s, %s)
                    ON CONFLICT (stage_id) DO NOTHING;
                """, (stage['id'], stage['name']))

                # Match data
                cur.execute("""
                    INSERT INTO matches (
                        match_id, match_date, kick_off, home_team_id, away_team_id, home_score, away_score, 
                        match_status, match_week, competition_id, season_id, stadium_id, referee_id, 
                        competition_stage_id, last_updated
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (match_id) DO NOTHING;
                """, (
                    match['match_id'], match['match_date'], match['kick_off'], match['home_team']['home_team_id'], 
                    match['away_team']['away_team_id'], match['home_score'], match['away_score'], 
                    match['match_status'], match['match_week'], competition['competition_id'], season['season_id'], 
                    stadium['id'] if stadium else None, referee['id'] if referee else None, stage['id'], 
                    match['last_updated']
                ))

                conn.commit()

def main(directory_path, conn_params):
    for dirpath, dirnames, filenames in os.walk(directory_path):
        for filename in filenames:
            if filename.endswith('.json'):
                file_path = os.path.join(dirpath, filename)

                try:
                    load_data_to_db(file_path, conn_params)
                    print(f"Data from {filename} loaded successfully.")
                except Exception as e:
                    print(f"Failed to load data from {filename}: {e}")

if __name__ == "__main__":
    directory_path = 'open-data-master/data/matches'
    connection_params = {
        "dbname": "project_database",
        "user": "postgres",
        "password": "1234",
        "host": "localhost",
        "port": "5432"
    }
    main(directory_path, connection_params)
