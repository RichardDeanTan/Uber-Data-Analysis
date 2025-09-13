-- 1) View Column Names
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name IN ('locations', 'trips')
ORDER BY table_name, ordinal_position;

-- 2) View Join Result
SELECT
	t.trip_id,
	t.pickup_time,
	t.drop_off_time,
	lpu.location_name AS pickup_location,
	ldo.location_name AS dropoff_location
FROM trips AS t
JOIN locations AS lpu ON t.pu_location_id = lpu.location_id
JOIN locations AS ldo ON t.do_location_id = ldo.location_id
LIMIT 5;

-- 3) Count NULL
CREATE OR REPLACE FUNCTION count_nulls(table_name TEXT, schema_name TEXT DEFAULT 'public')
RETURNS TABLE(column_name TEXT, null_count BIGINT) AS $$
DECLARE
	col_record RECORD;
	sql_query TEXT := '';
BEGIN
	FOR col_record IN 
		SELECT c.column_name
		FROM information_schema.columns c
		WHERE c.table_name = count_nulls.table_name 
			AND c.table_schema = count_nulls.schema_name
		ORDER BY c.ordinal_position
	LOOP
		IF sql_query != '' THEN
			sql_query := sql_query || ' UNION ALL ';
		END IF;
        
		sql_query := sql_query || FORMAT(
			'SELECT %L as column_name, SUM(CASE WHEN %I IS NULL THEN 1 ELSE 0 END) as null_count FROM %I.%I',
			col_record.column_name,
			col_record.column_name,
			schema_name,
			table_name
			);
		END LOOP;
		
	-- Execute
	RETURN QUERY EXECUTE sql_query;
END;
$$ LANGUAGE plpgsql;

-- Usage:
SELECT * FROM count_nulls('trips');