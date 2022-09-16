import psycopg2
import json
import os


LANGUAGES = [
    'typescript',
    'python',
    'javascript',
    'golang',
]

# this is so it works easily with the current dev setup even without
# setting any environment variables
HOST = os.getenv('HOST', 'localhost')
PORT = os.getenv('PORT', 5432)
USERNAME = os.getenv('USERNAME', 'codez')
PASSWORD = os.getenv('PASSWORD', 'codezcontrol')
DATABASE = os.getenv('DATABASE', 'code')
TABLE = os.getenv('TABLE', 'functions')

# set this in the environment if you want a higher number
NUMBER_OF_FUNCTIONS = os.getenv('NUMBER_OF_FUNCTIONS', 500)

conn = psycopg2.connect(host=HOST,
                        port=PORT,
                        user=USERNAME,
                        password=PASSWORD,
                        database=DATABASE)

# read in each file, then insert each line from each file into the DB
for language in LANGUAGES:
    print(f'processing {language}...')
    input_file = open(f'{language}.json', 'r')

    line_number = 0

    while True:
        # only read one line at a time so we can deal with big files
        line = input_file.readline()

        if not line:
            print('no more lines to process')
            conn.commit()
            break

        content = json.loads(line)

        cursor = conn.cursor()
        if not 'language' in content:
            content['language'] = language

        if content['contents']['total_lines'] >= 244:
            # this code won't fit in the database at present, so just skip it
            print('skipping this code, because is has too many lines')
            continue

        cursor.execute(
            "INSERT INTO functions (language, repo, number_of_lines, code) VALUES (%s, %s, %s, %s::json)",
            (content['language'], content['project_source'], content['contents']['total_lines'], json.dumps(content['contents']['lines']))
        )

        if line_number >= NUMBER_OF_FUNCTIONS:
            # for testing purposes, we probably don't need ALL the data
            break

        if line_number != 0 and line_number % 100 == 0:
            print(f'inserting {language} line number: {line_number}')
            conn.commit()
        line_number += 1
        cursor.close()

    input_file.close()

conn.close()
