CREATE DATABASE code if not exists;
 
CREATE USER codez WITH PASSWORD 'codez-control';
 
ALTER ROLE codez SET client_encoding TO 'utf8';
ALTER ROLE codez SET default_transaction_isolation TO 'read committed';
ALTER ROLE codez SET timezone TO 'UTC';
 
GRANT ALL PRIVILEGES ON DATABASE code TO codez;
