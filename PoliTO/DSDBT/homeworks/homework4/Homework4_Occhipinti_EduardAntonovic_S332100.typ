#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#show math.equation: set block(spacing: 0.65em)
#show math.equation.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)
#show math.equation.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#let _block(title: "", text: []) = box(
  width: 100%,
  fill: gradient.linear(luma(240), luma(245), angle: 270deg),
  stroke: 2pt + gradient.linear(luma(240), luma(245), angle: 270deg),
  radius: 4pt,
)[
  #block(
    fill: gradient.linear(luma(240), luma(245), angle: 270deg),
    //inset: (top: -38pt, x: 10pt, bottom: 0pt),
    text,
  )
  #align(right)[#block(
    fill: luma(255),
    inset: (top: 10pt, x: 10pt, bottom: 0pt),
    radius: 4pt,
  )[
    #emph(title)
  ]]
]

#show raw.where(block: true): set text(font: "FiraCode Nerd Font")
#show raw.where(block: true): block.with(
  fill: gradient.linear(luma(240), luma(245), angle: 270deg),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)
#show raw.where(block: false): box.with(
  fill: gradient.linear(luma(240), luma(245), angle: 270deg),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show heading.where(level: 1): it => block(width: 100%, height: 8%)[
  #set align(center)
  #set text(1.2em, weight: "bold")
  #smallcaps(it.body)
]
#show heading.where(level: 2): it => block(width: 100%)[
  #set align(center)
  #set text(1.1em, weight: "bold")
  #smallcaps(it.body)
]
#show heading.where(level: 3): it => block(width: 100%)[
  #set align(left)
  #set text(1em, weight: "bold")
  #smallcaps(it.body)
]

= Homework 4

== Question 1

=== input

```sql
  db.BikeStations.aggregate([
    { $group: { _id: "$extra.status", count: { $sum: 1 } } },
    {
      $match: {
        _id: { $in: ["online", "offline"] },
      },
    },
  ]);
  ```

=== output
```sql
[
  {
    "_id": "online",
    "count": 33
  },
  {
    "_id": "offline",
    "count": 28
  }
]
  ```

== Question 2

=== input

```sql
  db.BikeStations.countDocuments({
    "extra.status": { $nin: ["online", "offline"] },
  });
  ```

=== output
```sql
  32
  ```

== Question 3

=== input

```sql
db.BikeStations.find(
  { "extra.status": { $nin: ["online", "offline"] } },
  { "extra.status": 1, _id: 0 }
);
  ```

=== output

```sql
[
  {
    "extra": {
      "status": "maintenance"
    }
  },
  {
    "extra": {
      "status": "maintenance"
    }
  },
  {
    "extra": {
      "status": "maintenance"
    }
  },
  {
    "extra": {
      "status": "maintenance"
    }
  }
]

```

== Question 4

=== input

```sql
db.BikeStations.find(
  { "extra.status": "online", "extra.score": { $gte: 4 } },
  { name: 1 }
).sort({ name: 1 });
```

=== output

```sql
[
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c983"
    },
    "name": "02. Pettiti"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a6"
    },
    "name": "04. Reggia"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a7"
    },
    "name": "06. Municipio"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c987"
    },
    "name": "08. San Marchese"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c988"
    },
    "name": "10. Gallo Praile"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c994"
    },
    "name": "Belfiore"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c99a"
    },
    "name": "Borromini"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a5"
    },
    "name": "Castello 1"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c96b"
    },
    "name": "Corte d`Appello"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c96e"
    },
    "name": "Giolitti 1"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a1"
    },
    "name": "Politecnico 1"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c99e"
    },
    "name": "Politecnico 3"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c96c"
    },
    "name": "Porta Palatina"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a2"
    },
    "name": "Principi d`Acaja 1"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a3"
    },
    "name": "Principi d`Acaja 2"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c96f"
    },
    "name": "San Francesco da Paola"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c98e"
    },
    "name": "Sant´Anselmo"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c9a0"
    },
    "name": "Tribunale"
  }
]
```

== Question 5

=== input - inactive stations with free slots or bikes

```sql
db.BikeStations.find(
  {
    "extra.status": "offline",
    $or: [{ empty_slots: { $gt: 0 } }, { free_bikes: { $gt: 0 } }],
  },
  { name: 1 }
);
```

=== output 

```sql
[
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c976"
    },
    "empty_slots": 1,
    "free_bikes": 0,
    "name": "06. Le Serre"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c985"
    },
    "empty_slots": 0,
    "free_bikes": 5,
    "name": "05. Corso Garibaldi"
  }
]
```

=== input - count free slots or bikes

```sql
db.BikeStations.aggregate([
  {
    $match: {
      $and: [
        { "extra.status": "offline" },
        { $or: [{ empty_slots: { $gt: 0 } }, { free_bikes: { $gt: 0 } }] },
      ],
    },
  },
  {
    $group: {
      _id: null,
      total_empty_slots: { $sum: "$empty_slots" },
      total_free_bikes: { $sum: "$free_bikes" },
    },
  },
]);
```

=== output

```sql
[
  {
    "_id": null,
    "total_empty_slots": 1,
    "total_free_bikes": 5
  }
]
```

== Question 6

=== input

```sql
db.BikeStations.aggregate([
  { $group: { _id: null, tot_reviews: { $sum: "$extra.reviews" } } },
]);
```

=== output

```sql
[
  {
    "_id": null,
    "tot_reviews": 15311
  }
]
```

== Question 7

=== input

```sql
db.BikeStations.aggregate([
  { $group: { _id: "$extra.score", num: { $sum: 1 } } },
  { $sort: { _id: -1 } },
]);
```

=== output

```sql
[
  {
    "_id": 4.7,
    "num": 1
  },
  {
    "_id": 4.5,
    "num": 2
  },
  {
    "_id": 4.4,
    "num": 2
  },
  {
    "_id": 4.3,
    "num": 2
  },
  {
    "_id": 4.2,
    "num": 7
  },
  {
    "_id": 4.1,
    "num": 5
  },
  {
    "_id": 4,
    "num": 9
  },
  {
    "_id": 3.9,
    "num": 9
  },
  {
    "_id": 3.8,
    "num": 1
  },
  {
    "_id": 3.7,
    "num": 2
  },
  {
    "_id": 3.6,
    "num": 1
  },
  {
    "_id": 3.5,
    "num": 4
  },
  {
    "_id": 3.4,
    "num": 3
  },
  {
    "_id": 3.2,
    "num": 1
  },
  {
    "_id": 3,
    "num": 4
  },
  {
    "_id": 2.8,
    "num": 2
  },
  {
    "_id": 2.7,
    "num": 1
  },
  {
    "_id": 2.5,
    "num": 1
  },
  {
    "_id": 2.4,
    "num": 1
  },
  {
    "_id": 2.1,
    "num": 1
  },
  {
    "_id": 1.5,
    "num": 1
  },
  {
    "_id": 1.4,
    "num": 1
  },
  {
    "_id": 1.2,
    "num": 1
  },
  {
    "_id": 1,
    "num": 3
  }
]
```

== Question 8

=== input

```sql
db.BikeStations.aggregate([
  {
    $match: {
      $or: [{ "extra.status": "online" }, { "extra.status": "offline" }],
    },
  },
  { $group: { _id: "$extra.status", rating: { $avg: "$extra.score" } } },
]);
```

=== output

```sql
[
  {
    "_id": "online",
    "rating": 3.8454545454545452
  },
  {
    "_id": "offline",
    "rating": 3.0285714285714285
  }
]
```

== Question 9

=== input

```sql
db.BikeStations.aggregate([
  {
    $group: {
      _id: {
        $cond: [{ $gt: ["$free_bikes", 0] }, "with bikes", "without bikes"],
      },
      avg_rating: { $avg: "$extra.score" },
    },
  },
]);
```

=== input - using MapReduce paradigm (deprecated)

```sql
var mapper = function () {
  emit(this.free_bikes > 0 ? "with bikes" : "without bikes", this.extra.score);
};

var reducer = function (key, values) {
  return Array.avg(values);
};

db.BikeStations.mapReduce(mapper, reducer, { out: "avg_rating" });
```

=== output

```sql
[
  {
    "_id": "with bikes",
    "avg_rating": 3.8758620689655174
  },
  {
    "_id": "without bikes",
    "avg_rating": 3.2305555555555556
  }
]
```

== Question 10

=== input

```sql
db.BikeStations.aggregate([
  { $match: { "extra.status": "online" } },
  {
    $group: {
      _id: {
        $cond: [{ $gt: ["$free_bikes", 0] }, "with bikes", "without bikes"],
      },
      avg_rating: { $avg: "$extra.score" },
    },
  },
]);
```

=== input - using MapReduce paradigm (deprecated)

```sql
var mapper = function () {
  if (this.extra.status != "online") return;
  emit(this.free_bikes > 0 ? "with bikes" : "without bikes", this.extra.score);
};

var reducer = function (key, values) {
  return Array.avg(values);
};

db.BikeStations.mapReduce(mapper, reducer, { out: "avg_rating" });
```

=== output

```sql
[
  {
    "_id": "with bikes",
    "avg_rating": 3.8642857142857143
  },
  {
    "_id": "without bikes",
    "avg_rating": 3.7399999999999998
  }
]
```

== Question 11

=== input

```sql
db.BikeStations.createIndex( {location: “2dsphere”} );

db.BikeStations.find(
  {
    free_bikes: { $gt: 0 },
    location: {
      $near: {
        $geometry: {
          type: "Point",
          coordinates: [45.07456, 7.69463],
        },
      },
    },
  },
  { name: 1 }
)
  .sort({ name: 1 })
  .limit(3);
```

=== output

```sql
[
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c982"
    },
    "name": "01. Concordia"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c98c"
    },
    "name": "02. BIKE POINT Mandria"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c983"
    },
    "name": "02. Pettiti"
  }
]
```

== Question 12

=== input

```sql
db.BikeStations.find(
  {
    free_bikes: { $gt: 0 },
    location: {
      $near: {
        $geometry: {
          type: "Point",
          coordinates: db.BikeStations.findOne({ name: "Politecnico 4" })
            .location.coordinates,
        },
      },
    },
  },
  { name: 1, free_bikes: 1 }
)
  .sort({ name: 1 })
  .limit(3);
```

=== output

```sql
[
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c982"
    },
    "free_bikes": 2,
    "name": "01. Concordia"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c98c"
    },
    "free_bikes": 2,
    "name": "02. BIKE POINT Mandria"
  },
  {
    "_id": {
      "$oid": "6586ed046f7432c6fa55c983"
    },
    "free_bikes": 2,
    "name": "02. Pettiti"
  }
]
```
