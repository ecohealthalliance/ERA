db.legs.ensureIndex({day1:1})
db.legs.ensureIndex({day2:1})
db.legs.ensureIndex({day3:1})
db.legs.ensureIndex({day4:1})
db.legs.ensureIndex({day5:1})
db.legs.ensureIndex({day6:1})
db.legs.ensureIndex({day7:1})

var dayCounts = db.legs.aggregate([
  {"$project": 
    { "mondayNum": {"$cond": ["$day1",1,0]},
      "tuesdayNum":{"$cond": ["$day2",1,0]},
      "wednesdayNum":{"$cond": ["$day3",1,0]},
      "thursdayNum":{"$cond": ["$day4",1,0]},
      "fridayNum":{"$cond": ["$day5",1,0]},
      "saturdayNum":{"$cond": ["$day6",1,0]},
      "sundayNum":{"$cond": ["$day7",1,0]}
    }
  },
  {"$group": 
    {
      "_id": null,
      "monday":{
        "$sum":"$mondayNum"
      },
      "tuesday":{
        "$sum":"$tuesdayNum"
      },
      "wednesday":{
        "$sum":"$wednesdayNum"
      },
      "thursday":{
        "$sum":"$thursdayNum"
      },
      "friday":{
        "$sum":"$fridayNum"
      },
      "saturday":{
        "$sum":"$saturdayNum"
      },
      "sunday":{
        "$sum":"$sundayNum"
      }
    }   
  }
]).toArray()
db.dayCounts.remove({});
db.dayCounts.insert({day: "Monday", count: dayCounts[0].monday})
db.dayCounts.insert({day: "Tuesday", count: dayCounts[0].tuesday})
db.dayCounts.insert({day: "Wednesday", count: dayCounts[0].wednesday})
db.dayCounts.insert({day: "Thursday", count: dayCounts[0].thursday})
db.dayCounts.insert({day: "Friday", count: dayCounts[0].friday})
db.dayCounts.insert({day: "Saturday", count: dayCounts[0].saturday})
db.dayCounts.insert({day: "Sunday", count: dayCounts[0].sunday})

// db.legs.dropIndex({day1:1})
// db.legs.dropIndex({day2:1})
// db.legs.dropIndex({day3:1})
// db.legs.dropIndex({day4:1})
// db.legs.dropIndex({day5:1})
// db.legs.dropIndex({day6:1})
// db.legs.dropIndex({day7:1})
