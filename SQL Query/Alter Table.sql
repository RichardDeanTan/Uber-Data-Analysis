-- locations table
ALTER TABLE locations
	RENAME COLUMN LocationID TO location_id;

ALTER TABLE locations
	RENAME COLUMN "Location" TO location_name;

-- trips table
ALTER TABLE trips
	RENAME COLUMN TripID TO trip_id;

ALTER TABLE trips
	RENAME COLUMN PickupTime TO pickup_time;

ALTER TABLE trips
  RENAME COLUMN DropOffTime TO drop_off_time;

ALTER TABLE trips
	RENAME COLUMN PULocationID TO pu_location_id;

ALTER TABLE trips
	RENAME COLUMN DOLocationID TO do_location_id;

ALTER TABLE trips
	RENAME COLUMN SurgeFee TO surge_fee;