-- Important & Frequent Analysis Index
CREATE INDEX IF NOT EXISTS idx_trips_vehicle ON trips(vehicle);
CREATE INDEX IF NOT EXISTS idx_trips_payment_type ON trips(payment_type);
CREATE INDEX IF NOT EXISTS idx_trips_pickup_time ON trips(pickup_time);
CREATE INDEX IF NOT EXISTS idx_trips_pu_location ON trips(pu_location_id);
CREATE INDEX IF NOT EXISTS idx_trips_do_location ON trips(do_location_id);
CREATE INDEX IF NOT EXISTS idx_trips_passenger_count ON trips(passenger_count);
CREATE INDEX IF NOT EXISTS idx_locations_id ON locations(location_id);

-- 1) Vehicle Analysis Fares, distance, fee
SELECT 
	vehicle,
	COUNT(*) as trip_count,
	ROUND(AVG(fare_amount), 2) as avg_fare,
	ROUND(SUM(fare_amount), 2) as total_revenue,
	ROUND(AVG(trip_distance), 2) as avg_distance,
	ROUND(AVG(surge_fee), 2) as avg_surge,
	ROUND(SUM(surge_fee), 2) as total_surge
FROM trips
WHERE vehicle IS NOT NULL
GROUP BY vehicle
ORDER BY total_revenue DESC;

--2) Payment Analysis
SELECT 
	payment_type,
	COUNT(*) as trip_count,
	ROUND(AVG(fare_amount), 2) as avg_fare,
	ROUND(SUM(fare_amount), 2) as total_revenue,
	ROUND(AVG(trip_distance), 2) as avg_distance,
	COUNT(CASE WHEN surge_fee > 0 THEN 1 END) as trips_with_surge,
	ROUND(AVG(CASE WHEN surge_fee > 0 THEN surge_fee END), 2) as avg_surge_when_applied
FROM trips
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- 3) Day of Week Analysis
SELECT 
    EXTRACT(DOW FROM pickup_time) as day_of_week,
    CASE EXTRACT(DOW FROM pickup_time)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END as day_name,
    COUNT(*) as trip_count,
    ROUND(AVG(fare_amount), 2) as avg_fare,
    ROUND(SUM(fare_amount), 2) as total_revenue,
    ROUND(AVG(surge_fee), 2) as avg_surge
FROM trips
WHERE pickup_time IS NOT NULL
GROUP BY EXTRACT(DOW FROM pickup_time)
ORDER BY day_of_week;

--4) Hour of Day Analysis
SELECT 
    EXTRACT(HOUR FROM pickup_time) as hour_of_day,
    COUNT(*) as trip_count,
    ROUND(AVG(fare_amount), 2) as avg_fare,
    ROUND(SUM(fare_amount), 2) as total_revenue,
    ROUND(AVG(surge_fee), 2) as avg_surge,
    COUNT(CASE WHEN surge_fee > 0 THEN 1 END) as surge_trips
FROM trips
WHERE pickup_time IS NOT NULL
GROUP BY EXTRACT(HOUR FROM pickup_time)
ORDER BY hour_of_day;

--5) Passenger Count Analysis
SELECT 
	passenger_count,
	COUNT(*) as trip_count,
	ROUND(AVG(fare_amount), 2) as avg_fare,
	ROUND(SUM(fare_amount), 2) as total_revenue,
	ROUND(AVG(trip_distance), 2) as avg_distance,
	ROUND(AVG(fare_amount/NULLIF(trip_distance, 0)), 2) as avg_fare_per_mile,
	COUNT(CASE WHEN surge_fee > 0 THEN 1 END) as surge_trips,
	ROUND(AVG(surge_fee), 2) as avg_surge
FROM trips
WHERE passenger_count IS NOT NULL AND passenger_count > 0
GROUP BY passenger_count
ORDER BY passenger_count;