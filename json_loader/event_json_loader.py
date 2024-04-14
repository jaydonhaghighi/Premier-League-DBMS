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

def safe_json(data):
    if data is None:
        return None
    try:
        return json.dumps(data)
    except (TypeError, ValueError):
        return None

# Function to load data for a single file
def load_single_file_data(file_path, conn_params):
    try:
        with open(file_path, 'r') as file:
            events = json.load(file)

        with psycopg.connect(**conn_params) as conn:
            with conn.cursor() as cur:
                    insert_event_sql = """
                        INSERT INTO events (
                            event_id, index, period, timestamp, minute, second, type_id, type_name,
                            possession, possession_team_id, play_pattern_id, team_id, player_id,
                            location, under_pressure, related_events, duration, tactics
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
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
                            outcome_id, outcome_name, technique_id, technique_name
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """

                    insert_dribble_sql = """
                        INSERT INTO event_dribble (
                            event_id, outcome_id, outcome_name, overrun, nutmeg, no_touch
                        )
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """

                    # insert_ball_recovery_sql = """
                    #     INSERT INTO event_ball_recovery (
                    #         event_id, recovery_failure, offensive
                    #     )
                    #     VALUES (%s, %s, %s)
                    # """

                    # insert_block_sql = """
                    #     INSERT INTO event_block (
                    #         event_id, deflection, save_block, offensive, counterpress
                    #     )
                    #     VALUES (%s, %s, %s, %s, %s)
                    # """

                    # insert_carry_sql = """
                    #     INSERT INTO event_carry (
                    #         event_id, end_location
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_clearance_sql = """
                    #     INSERT INTO event_clearance (
                    #         event_id, aerial_won, body_part_id, body_part_name
                    #     )
                    #     VALUES (%s, %s, %s, %s)
                    # """

                    # insert_duel_sql = """
                    #     INSERT INTO event_duel (
                    #         event_id, duel_type_id, duel_type_name, outcome_id, outcome_name
                    #     )
                    #     VALUES (%s, %s, %s, %s, %s)
                    # """

                    # insert_foul_committed_sql = """
                    #     INSERT INTO event_foul_committed (
                    #         event_id, offensive, foul_type_id, foul_type_name, card_id, card_name
                    #     )
                    #     VALUES (%s, %s, %s, %s, %s, %s)
                    # """

                    # insert_foul_won_sql = """
                    #     INSERT INTO event_foul_won (
                    #         event_id, defensive
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_goalkeeper_sql = """
                    #     INSERT INTO event_goalkeeper (
                    #         event_id, body_part_id, body_part_name, technique_id, technique_name,
                    #         position_id, position_name, outcome_id, outcome_name, type_id, type_name
                    #     )
                    #     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    # """

                    # insert_half_end_sql = """
                    #     INSERT INTO event_half_end (
                    #         event_id, early_video_end
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_half_start_sql = """
                    #     INSERT INTO event_half_start (
                    #         event_id, late_video_start
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_injury_stoppage_sql = """
                    #     INSERT INTO event_injury_stoppage (
                    #         event_id, in_chain
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_interception_sql = """
                    #     INSERT INTO event_interception (
                    #         event_id, outcome_id, outcome_name
                    #     )
                    #     VALUES (%s, %s, %s)
                    # """

                    # insert_player_off_sql = """
                    #     INSERT INTO event_player_off (
                    #         event_id, permanent
                    #     )
                    #     VALUES (%s, %s)
                    # """

                    # insert_substitution_sql = """
                    #     INSERT INTO event_substitution (
                    #         event_id, outcome, replacement_id, replacement_name
                    #     )
                    #     VALUES (%s, %s, %s, %s)
                    # """

                    for event in events:
                        event_id = str(uuid.uuid4())
                        location = safe_json(event.get('location'))
                        related_events = format_uuid_array(event.get('related_events'))
                        tactics = safe_json(event.get('tactics', {}))

                        cur.execute(insert_event_sql, (
                            event_id, event.get('index'), event.get('period'), event.get('timestamp'),
                            event.get('minute'), event.get('second'), event['type']['id'], event['type']['name'],
                            event.get('possession'), event['possession_team']['id'], event['play_pattern']['id'],
                            event['team']['id'], event.get('player', {}).get('id'), location,
                            event.get('under_pressure', False), related_events, event.get('duration', 0.0), tactics
                        ))

                        if event['type']['name'] == 'Shot' and 'shot' in event:
                            shot = event['shot']
                            end_location = safe_json(shot.get('end_location'))
                            freeze_frame = safe_json(shot.get('freeze_frame'))
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
                            end_location = safe_json(pass_.get('end_location'))
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
                                technique.get('id'), technique.get('name')
                            ))

                        if event['type']['name'] == 'Dribble' and 'dribble' in event:
                            dribble = event['dribble']
                            outcome = dribble['outcome']

                            cur.execute(insert_dribble_sql, (
                                event_id, outcome['id'], outcome['name'],
                                dribble.get('overrun', False), dribble.get('nutmeg', False),
                                dribble.get('no_touch', False)
                            ))

                    #     if event['type']['name'] == 'Ball Recovery' and 'ball_recovery' in event:
                    #         ball_recovery = event['ball_recovery']
                    #         cur.execute(insert_ball_recovery_sql, (
                    #             event_id,
                    #             ball_recovery.get('recovery_failure', False),
                    #             ball_recovery.get('offensive', False)
                    #         ))

                    #     if event['type']['name'] == 'Block' and 'block' in event:
                    #         block = event['block']
                    #         cur.execute(insert_block_sql, (
                    #             event_id,
                    #             block.get('deflection', False),
                    #             block.get('save_block', False),
                    #             block.get('offensive', False),
                    #             block.get('counterpress', False)
                    #         ))

                    #     if event['type']['name'] == 'Carry' and 'carry' in event:
                    #         carry = event['carry']
                    #         end_location = safe_json(carry.get('end_location'))
                    #         cur.execute(insert_carry_sql, (
                    #             event_id,
                    #             end_location
                    #         ))

                    #     if event['type']['name'] == 'Clearance' and 'clearance' in event:
                    #         clearance = event['clearance']
                    #         body_part = clearance.get('body_part', {})
                    #         cur.execute(insert_clearance_sql, (
                    #             event_id,
                    #             clearance.get('aerial_won', False),
                    #             body_part.get('id'),
                    #             body_part.get('name')
                    #         ))

                    #     if event['type']['name'] == 'Duel' and 'duel' in event:
                    #         duel = event['duel']
                    #         duel_type = duel['type']
                    #         outcome = duel['outcome']
                    #         cur.execute(insert_duel_sql, (
                    #             event_id,
                    #             duel_type['id'],
                    #             duel_type['name'],
                    #             outcome['id'],
                    #             outcome['name']
                    #         ))

                    #     if event['type']['name'] == 'Foul Committed' and 'foul_committed' in event:
                    #         foul_committed = event['foul_committed']
                    #         foul_type = foul_committed['type']
                    #         card = foul_committed.get('card', {})
                    #         cur.execute(insert_foul_committed_sql, (
                    #             event_id,
                    #             foul_committed.get('offensive', False),
                    #             foul_type['id'],
                    #             foul_type['name'],
                    #             card.get('id'),
                    #             card.get('name')
                    #         ))

                    #     if event['type']['name'] == 'Foul Won' and 'foul_won' in event:
                    #         foul_won = event['foul_won']
                    #         cur.execute(insert_foul_won_sql, (
                    #             event_id,
                    #             foul_won.get('defensive', False)
                    #         ))

                    #     if event['type']['name'] == 'Goal Keeper' and 'goalkeeper' in event:
                    #         goalkeeper = event['goalkeeper']
                    #         body_part = goalkeeper.get('body_part', {})
                    #         technique = goalkeeper.get('technique', {})
                    #         position = goalkeeper['position']
                    #         outcome = goalkeeper['outcome']
                    #         gk_type = goalkeeper['type']
                    #         cur.execute(insert_goalkeeper_sql, (
                    #             event_id,
                    #             body_part.get('id'),
                    #             body_part.get('name'),
                    #             technique.get('id'),
                    #             technique.get('name'),
                    #             position['id'],
                    #             position['name'],
                    #             outcome['id'],
                    #             outcome['name'],
                    #             gk_type['id'],
                    #             gk_type['name']
                    #         ))

                    #     if event['type']['name'] == 'Half End' and 'half_end' in event:
                    #         half_end = event['half_end']
                    #         cur.execute(insert_half_end_sql, (
                    #             event_id,
                    #             half_end.get('early_video_end', False)
                    #         ))

                    #     if event['type']['name'] == 'Half Start' and 'half_start' in event:
                    #         half_start = event['half_start']
                    #         cur.execute(insert_half_start_sql, (
                    #             event_id,
                    #             half_start.get('late_video_start', False)
                    #         ))

                    #     if event['type']['name'] == 'Injury Stoppage' and 'injury_stoppage' in event:
                    #         injury_stoppage = event['injury_stoppage']
                    #         cur.execute(insert_injury_stoppage_sql, (
                    #             event_id,
                    #             injury_stoppage.get('in_chain', False)
                    #         ))

                    #     if event['type']['name'] == 'Interception' and 'interception' in event:
                    #         interception = event['interception']
                    #         outcome = interception['outcome']
                    #         cur.execute(insert_interception_sql, (
                    #             event_id,
                    #             outcome['id'],
                    #             outcome['name']
                    #         ))

                    #     if event['type']['name'] == 'Player Off' and 'player_off' in event:
                    #         player_off = event['player_off']
                    #         cur.execute(insert_player_off_sql, (
                    #             event_id,
                    #             player_off.get('permanent', False)
                    #         ))

                    # if event['type']['name'] == 'Substitution' and 'substitution' in event:
                    #         substitution = event['substitution']
                    #         replacement = substitution['replacement']
                    #         cur.execute(insert_substitution_sql, (
                    #             event_id,
                    #             substitution.get('outcome'),
                    #             replacement['id'],
                    #             replacement['name']
                    #         ))

                    conn.commit()
        print(f"Data from {file_path} loaded successfully.")
    except Exception as e:
        print(f"Failed to load data from {file_path}: {e}")


# def main(directory_path, conn_params):
#     json_files = []
#     for root, dirs, files in os.walk(directory_path):
#         for filename in files:
#             if filename.endswith('.json'):
#                 file_path = os.path.join(root, filename)
#                 json_files.append(file_path)

#     try:
#         load_event_data(json_files, conn_params)
#         print("All JSON files loaded successfully.")
#     except Exception as e:
#         print(f"Failed to load data: {e}")

# Main function to load data using multiple processes
def load_event_data(file_paths, conn_params):
    with Pool(processes=4) as pool:  
        pool.starmap(load_single_file_data, [(file_path, conn_params) for file_path in file_paths])

def main(directory_path, conn_params):
    json_files = []
    for root, dirs, files in os.walk(directory_path):
        for filename in files:
            if filename.endswith('.json'):
                file_path = os.path.join(root, filename)
                json_files.append(file_path)
                if len(json_files) >= 500:
                    break
        if len(json_files) >= 500:
            break

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