#!/bin/bash

psql << EOF
\c code;
CREATE TABLE functions(
    id        serial primary key,
	created_at timestamp with time zone default current_timestamp,
	updated_at timestamp with time zone,
	deleted_at timestamp with time zone NULL,
	language  text,
	repo      text,
	/* we probably don't care about functions with more than 255 lines */
	number_of_lines smallint,
	code          jsonb
);

ALTER TABLE functions
  OWNER TO $USER;

EOF