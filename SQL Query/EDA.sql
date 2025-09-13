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