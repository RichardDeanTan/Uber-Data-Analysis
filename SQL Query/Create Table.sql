CREATE TABLE locations (
    LocationID   INT PRIMARY KEY,
    "Location"     VARCHAR(255),
    City         VARCHAR(255)
);

CREATE TABLE trips (
    TripID          INT PRIMARY KEY,
    PickupTime      TIMESTAMP,
    DropOffTime     TIMESTAMP,
    passenger_count INT,
    trip_distance   NUMERIC(5, 2),
    PULocationID    INT,
    DOLocationID    INT,
    fare_amount     NUMERIC(10, 2),
    SurgeFee        NUMERIC(10, 2),
    Vehicle         VARCHAR(50),
    Payment_type    VARCHAR(50),
    CONSTRAINT fk_trips_pickup_location FOREIGN KEY (PULocationID)
    REFERENCES locations(LocationID),

    CONSTRAINT fk_trips_dropoff_location FOREIGN KEY (DOLocationID)
    REFERENCES locations(LocationID)
);