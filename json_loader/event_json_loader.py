import psycopg
import json
import os
import uuid
from multiprocessing import Pool

def format_uuid_array(data):
    if not data:
        return '{}'
    uuid_array = ','.join(str(uuid) for uuid in data)
    return f'{{{uuid_array}}}'

def json_dump(data):
    if data is None:
        return None
    try:
        return json.dumps(data)
    except (TypeError, ValueError):
        return None

def load_file_to_db(file_path, conn_params):
    try:
        with open(file_path, 'r') as file:
            events = json.load(file)

        with psycopg.connect(**conn_params) as conn:
            with conn.cursor() as cur:
                    insert_event_sql = """
                        INSERT INTO events (
                            id, index, period, timestamp, minute, second, type_id, type_name,
                            possession, possession_team_id, play_pattern_id, team_id, player_id,
                            location, under_pressure, related_events, duration, tactics, match_id
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """

                    insert_shot_sql = """
                        INSERT INTO event_shot (
                            event_id, key_pass_id, end_location, aerial_won, follows_dribble,
                            first_time, freeze_frame, open_goal, statsbomb_xg, deflected,
                            technique_id, technique_name, body_part_id, body_part_name,
                            shot_type_id, shot_type_name, outcome_id, outcome_name
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """

                    insert_pass_sql = """
                        INSERT INTO event_pass (
                            event_id, recipient_id, recipient_name, length, angle, height_id,
                            height_name, end_location, assisted_shot_id, backheel, deflected,
                            miscommunication, "cross", cut_back, switch, shot_assist, goal_assist,
                            body_part_id, body_part_name, pass_type_id, pass_type_name,
                            outcome_id, outcome_name, technique_id, technique_name, through_ball
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)

                    """

                    insert_dribble_sql = """
                        INSERT INTO event_dribble (
                            event_id, outcome_id, outcome_name, overrun, nutmeg, no_touch
                        )
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """

                    for event in events:
                        event_id = str(uuid.uuid4())
                        location = json_dump(event.get('location'))
                        related_events = format_uuid_array(event.get('related_events'))
                        tactics = json_dump(event.get('tactics', {}))
                        team_id = event['team']['id']

                        cur.execute("""
                            SELECT match_id
                            FROM matches
                            WHERE home_team_id = %s OR away_team_id = %s
                            LIMIT 1
                        """, (team_id, team_id))
                        match_id = cur.fetchone()[0]

                        cur.execute(insert_event_sql, (
                            event_id, event.get('index'), event.get('period'), event.get('timestamp'),
                            event.get('minute'), event.get('second'), event['type']['id'], event['type']['name'],
                            event.get('possession'), event['possession_team']['id'], event['play_pattern']['id'],
                            event['team']['id'], event.get('player', {}).get('id'), location,
                            event.get('under_pressure', False), related_events, event.get('duration', 0.0), tactics,
                            match_id
                        ))

                        if event['type']['name'] == 'Shot' and 'shot' in event:
                            shot = event['shot']
                            end_location = json_dump(shot.get('end_location'))
                            freeze_frame = json_dump(shot.get('freeze_frame'))
                            technique = shot.get('technique', {})
                            body_part = shot.get('body_part', {})
                            shot_type = shot['type']
                            outcome = shot['outcome']
                            

                            cur.execute(insert_shot_sql, (
                                event_id, shot.get('key_pass_id'), end_location,
                                shot.get('aerial_won', False), shot.get('follows_dribble', False),
                                shot.get('first_time', False), freeze_frame, shot.get('open_goal', False),
                                shot.get('statsbomb_xg'), shot.get('deflected', False),
                                technique.get('id'), technique.get('name'),
                                body_part.get('id'), body_part.get('name'),
                                shot_type['id'], shot_type['name'],
                                outcome['id'], outcome['name']
                            ))

                        if event['type']['name'] == 'Pass' and 'pass' in event:
                            pass_ = event['pass']
                            recipient = pass_.get('recipient', {})
                            height = pass_.get('height', {})
                            end_location = json_dump(pass_.get('end_location'))
                            body_part = pass_.get('body_part', {})
                            pass_type = pass_.get('type', {})
                            outcome = pass_.get('outcome', {})
                            technique = pass_.get('technique', {})

                            cur.execute(insert_pass_sql, (
                                event_id, recipient.get('id'), recipient.get('name'),
                                pass_.get('length'), pass_.get('angle'),
                                height.get('id'), height.get('name'),
                                end_location, pass_.get('assisted_shot_id'),
                                pass_.get('backheel', False), pass_.get('deflected', False),
                                pass_.get('miscommunication', False), pass_.get('cross', False),
                                pass_.get('cut_back', False), pass_.get('switch', False),
                                pass_.get('shot_assist', False), pass_.get('goal_assist', False),
                                body_part.get('id'), body_part.get('name'),
                                pass_type.get('id'), pass_type.get('name'),
                                outcome.get('id'), outcome.get('name'),
                                technique.get('id'), technique.get('name'),
                                pass_.get('through_ball', False)
                            ))

                        if event['type']['name'] == 'Dribble' and 'dribble' in event:
                            dribble = event['dribble']
                            outcome = dribble['outcome']

                            cur.execute(insert_dribble_sql, (
                                event_id, outcome['id'], outcome['name'],
                                dribble.get('overrun', False), dribble.get('nutmeg', False),
                                dribble.get('no_touch', False)
                            ))

                    conn.commit()
                    
        print(f"Data from {file_path} loaded successfully.")
    except Exception as e:
        print(f"Failed to load data from {file_path}: {e}")

def load_event_data(file_paths, conn_params):
    with Pool(processes=4) as pool:  
        pool.starmap(load_file_to_db, [(file_path, conn_params) for file_path in file_paths])

def main(directory_path, conn_params):
    json_files = []
    for root, dirs, files in os.walk(directory_path):
        for filename in files:
            if filename.endswith('.json'):
                file_path = os.path.join(root, filename)
                json_files.append(file_path)
        #         if len(json_files) >= 500:
        #             break
        # if len(json_files) >= 500:
        #     break

    try:
        load_event_data(json_files, conn_params)
        print("First 500 JSON files loaded successfully.")
    except Exception as e:
        print(f"Failed to load data: {e}")

if __name__ == "__main__":
    connection_params = {
        "dbname": "project_database",
        "user": "postgres",
        "password": "1234",
        "host": "localhost",
        "port": "5432"
    }
    main('open-data-master/data/events', connection_params)