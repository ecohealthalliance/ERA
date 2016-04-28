# EcoHealth Realtime Analysis - ERA

Dashboard for viewing statistics about various EHA projects

## Setup
You will need to restore a mongodump of the `flights` collection for FLIRT:

```
mongorestore --collection flights --port 3401 -d meteor flights.bson
```

Once you have done this, log into the meteor mongo instance and execute the `.scripts/flight_counts.js` script:
```
load('.scripts/flight_counts.js')
```

Once this has completed you should be able to start up the application and view the flight count graph on the main page.
