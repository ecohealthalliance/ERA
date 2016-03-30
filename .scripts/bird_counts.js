// creates new collection with aggregate bird count data
db.migrations.aggregate(
  {$unwind: "$sightings"},
  {$project: {sighting: {bird: "$sightings.bird_id", count: "$sightings.count"}}},
  {
    $group: {
      _id: {bird: "$sighting.bird"},
      count: {$sum: "$sighting.count"}
    }
  }
).result.forEach(function(res){
  db.birdCounts.insert({bird: res._id.bird, count: res.count })
})

