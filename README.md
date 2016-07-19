# EcoHealth Realtime Analysis - ERA

Dashboard for viewing statistics about various EHA projects

## Setup
You will need to restore a mongodump of the `flights`, `legs`, `migrations` and `airports` collections:

```
mongorestore --collection flights --port 3541 -d meteor flights.bson
mongorestore --collection legs --port 3541 -d meteor legs.bson
mongorestore --collection migrations --port 3541 -d meteor migrations.bson
mongoimport -h localhost:3541 --db meteor --collection airports --type json --file airports.json
```

Once you have done this, log into the meteor mongo instance and execute the scripts from .scripts/ directory:
```
load('.scripts/flight_counts.js')
load('.scripts/airport_counts.js')
load('.scripts/day_counts.js')
load('.scripts/bird_counts.js')
```

Once this has completed you should be able to start up the application and view the flight count graph on the main page.
