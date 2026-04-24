// 1. Create Database & Collection
use CollegeDB; db.createCollection("students");

// 2. Insert Documents
db.students.insertMany([{name:"Arun",age:20,dept:"CSE",marks:85,skills:["Java","DBMS"],address:{city:"Kannur"}},{name:"Anu",age:21,dept:"ECE",marks:78,skills:["C","Python"],address:{city:"Kochi"}},{name:"Rahul",age:22,dept:"CSE",marks:92,skills:["Java","React"],address:{city:"Calicut"}}]);

// 3. Read
db.students.find();

// 4. Projection
db.students.find({}, {name:1,marks:1,_id:0});

// 5. Update Queries
db.students.updateOne({name:"Arun"},{$set:{marks:90}});

// 6. Delete Queries
db.students.deleteOne({name:"Anu"});

// 7. Sorting
db.students.find().sort({marks:-1});

// 8. Limit & Skip
db.students.find().limit(2); db.students.find().skip(1);

// 9. Aggregation Framework
db.students.aggregate([{$group:{_id:"$dept",avgMarks:{$avg:"$marks"}}}]);

// 10. Match and Group
db.students.aggregate([{$match:{dept:"CSE"}},{$group:{_id:"$dept",total:{$sum:1}}}]);

// 11. Lookup (Join)
db.createCollection("courses"); db.courses.insertMany([{studentName:"Arun",course:"DBMS"},{studentName:"Rahul",course:"React"}]); db.students.aggregate([{$lookup:{from:"courses",localField:"name",foreignField:"studentName",as:"courseDetails"}}]);

// 12. Indexing
db.students.createIndex({name:1});

// 13. Text Search
db.students.createIndex({name:"text"}); db.students.find({$text:{$search:"Arun"}});

// 14. Count Documents
db.students.countDocuments();

// 15. Distinct Values
db.students.distinct("dept");

// 16. Embedded Document Query
db.students.find({"address.city":"Kannur"});

// 17. Array Query
db.students.find({skills:"Java"});

// 18. Bulk Operations
db.students.bulkWrite([{insertOne:{document:{name:"Meera",age:23,dept:"EEE",marks:70}}},{updateOne:{filter:{name:"Rahul"},update:{$set:{marks:95}}}},{deleteOne:{filter:{name:"Arun"}}}]);