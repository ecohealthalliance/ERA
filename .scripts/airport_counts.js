// I looked at doing this all in one query but it was so giant and complicated that I decided to 
// break it up into multiple queries to simplify things. 
// Related: http://stackoverflow.com/questions/36363112/grouping-and-counting-across-documents

// insert the base records with a departure count
db.legs.aggregate([
  {
    "$group":{
      _id: "$departureAirport._id",
      departureCount: {$sum: 1}
    }
  }
]).result.forEach(function(airport){
  db.airportCounts.insert(airport)
});

// add in the arrival counts
db.legs.aggregate([
  {
    "$group":{
      _id: "$arrivalAirport._id",
      arrivalCount: {$sum: 1}
    }
  }
]).result.forEach(function(airport){
  db.airportCounts.update({_id: airport._id}, {$set: {arrivalCount: airport.arrivalCount}})
});

// get the total of arrivals + departures
db.airportCounts.aggregate(
   [
     {
       $project:
         { 
           totalAmount: { $add: [ "$arrivalCount", "$departureCount" ] }
         }
     }
   ]
).result.forEach(function(airport){
  db.airportCounts.update({_id: airport._id}, {$set: {total: airport.totalAmount}})
})