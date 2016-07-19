//script to get the number of flights that occur on a specific day.  To determine this we
//check to see if the specific day lies within the effectiveDate and discontinuedDate for each record
//Creates a new collection called flightCounts that is used for calculations

db.legs.ensureIndex({effectiveDate: 1})
db.legs.ensureIndex({discontinuedDate: -1})

var startDate = db.legs.find().sort({effectiveDate: 1}).limit(1).toArray()[0].effectiveDate
startDate.setUTCHours(0,0,0,0)
var endDate = db.legs.find().sort({discontinuedDate: -1}).limit(1).toArray()[0].discontinuedDate
print(startDate, endDate)
db.flightCounts.remove({}) //clear out the flightCounts collection
while(startDate < endDate){
  var counts = db.legs.find(
      {
        effectiveDate: {$lte: startDate},
        discontinuedDate: {$gte: startDate}
      }
    ).count()
  db.flightCounts.insert({date: startDate, count: counts})
  printjson({date: startDate, count: counts})
  startDate.setHours(startDate.getHours() + 25) //need to do this to account for daylight savings time
  startDate.setUTCHours(0,0,0,0)
}

// var averageFlights = db.flightCounts.aggregate({
//   "$group": {
//     "_id": null,
//     "avg_days": { "$avg": "$count" }
//   }
// })

// printjson(averageFlights)
