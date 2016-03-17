db.legs.ensureIndex({day1:1})
db.legs.ensureIndex({day2:1})
db.legs.ensureIndex({day3:1})
db.legs.ensureIndex({day4:1})
db.legs.ensureIndex({day5:1})
db.legs.ensureIndex({day6:1})
db.legs.ensureIndex({day7:1})

db.legs.aggregate([
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
      "mondayCount":{
        "$sum":"$mondayNum"
      },
      "tuesdayCount":{
        "$sum":"$tuesdayNum"
      },
      "wednesdayCount":{
        "$sum":"$wednesdayNum"
      },
      "thursdayCount":{
        "$sum":"$thursdayNum"
      },
      "fridayCount":{
        "$sum":"$fridayNum"
      },
      "saturdayCount":{
        "$sum":"$saturdayNum"
      },
      "sundayCount":{
        "$sum":"$sundayNum"
      }
    }
  }
])

// db.legs.dropIndex({day1:1})
// db.legs.dropIndex({day2:1})
// db.legs.dropIndex({day3:1})
// db.legs.dropIndex({day4:1})
// db.legs.dropIndex({day5:1})
// db.legs.dropIndex({day6:1})
// db.legs.dropIndex({day7:1})
