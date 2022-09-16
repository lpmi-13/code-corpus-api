CREATE MATERIALIZED VIEW IF NOT EXISTS language_counts
AS
  SELECT language, count(*) from functions
  GROUP BY language;