```cypher
// 1. Basic Graph Creation 
// a. Create a node labeled Person with properties (name, age).
CREATE (:Person {name: "SHAN", age: 22});

// b. Create a node labeled City.
CREATE (:City {name: "Kannur"});

// c. Create a relationship LIVES_IN between Person and City.
MATCH (p:Person {name: "SHAN"}), (c:City {name: "Kannur"})
CREATE (p)-[:LIVES_IN]->(c);

// d. Create multiple nodes and relationships in one query.
CREATE 
(shan:Person {name: "SHAN", age: 22}),
(sharun:Person {name: "SHARUN", age: 24}),
(amith:Person {name: "AMITH", age: 27}),
(kannur:City {name: "Kannur"}),
(kochi:City {name: "Kochi"}),
(shan)-[:LIVES_IN]->(kannur),
(sharun)-[:LIVES_IN]->(kochi),
(amith)-[:LIVES_IN]->(kochi),
(shan)-[:FRIEND]->(sharun),
(sharun)-[:FRIEND]->(amith),
(amith)-[:FRIEND]->(shan);

// 2. Retrieve all nodes from the graph.
MATCH (n) RETURN n;

// 1. Find all Person nodes.
MATCH (p:Person) RETURN p;

// 2. Update a person’s age.
MATCH (p:Person {name: "SHARUN"})
SET p.age = 26;

// 3. Delete a node and its relationships.
MATCH (p:Person {name: "AMITH"})
DETACH DELETE p;

// 4. Add a new property to existing nodes.
MATCH (p:Person)
SET p.gender = "Male";

// 5. Find all persons who live in a specific city.
MATCH (p:Person)-[:LIVES_IN]->(c:City {name: "Kochi"})
RETURN p;

// 6. Find all relationships between nodes.
MATCH ()-[r]->() RETURN r;

// 7. Match patterns of type (Person)-[:FRIEND]->(Person)
MATCH (p1:Person)-[:FRIEND]->(p2:Person)
RETURN p1, p2;

// 8. Find bidirectional relationships.
MATCH (p1:Person)-[r]-(p2:Person)
RETURN p1, p2;

// 9. Find friends of a person (1-hop traversal)
MATCH (p:Person {name: "SHAN"})-[:FRIEND]->(f)
RETURN f;

// 10. Find friends of friends (2-hop traversal)
MATCH (p:Person {name: "SHAN"})-[:FRIEND*2]->(f)
RETURN f;

// 11. Find all nodes reachable within depth 3
MATCH (p:Person {name: "SHAN"})-[:FRIEND*1..3]->(f)
RETURN f;

// 12. Limit traversal depth.
MATCH (p:Person {name: "SHAN"})-[:FRIEND*1..2]->(f)
RETURN f;

// 13. Find shortest path between two nodes
MATCH (p1:Person {name: "SHAN"}), (p2:Person {name: "SHARUN"})
MATCH path = shortestPath((p1)-[*]-(p2))
RETURN path;

// 14. Find all paths between two nodes
MATCH (p1:Person {name: "SHAN"}), (p2:Person {name: "SHARUN"})
MATCH path = (p1)-[*]-(p2)
RETURN path;

// 15. Find paths with length ≤ 3
MATCH (p1:Person {name: "SHAN"}), (p2:Person {name: "SHARUN"})
MATCH path = (p1)-[*1..3]-(p2)
RETURN path;

// 16. Avoid revisiting nodes in a path
MATCH path = (p:Person {name: "SHAN"})-[:FRIEND*]->(f)
WHERE ALL(n IN nodes(path) WHERE SINGLE(x IN nodes(path) WHERE x = n))
RETURN path;

// 17. Find nodes with age > 25
MATCH (p:Person)
WHERE p.age > 25
RETURN p;

// 18. Use WHERE clause with relationships
MATCH (p:Person)-[:LIVES_IN]->(c:City)
WHERE c.name = "Kochi"
RETURN p;

// 19. Find nodes with specific property values
MATCH (p:Person {name: "SHAN"})
RETURN p;

// 20. Use IN and AND conditions.
MATCH (p:Person)
WHERE p.name IN ["SHAN","SHARUN"] AND p.age > 20
RETURN p;

// 21. Count number of friends per person
MATCH (p:Person)-[:FRIEND]->(f)
RETURN p.name, COUNT(f) AS friends;

// 22. Find node with maximum connections
MATCH (p:Person)-[r]-()
RETURN p, COUNT(r) AS connections
ORDER BY connections DESC
LIMIT 1;

// 23. Calculate average age
MATCH (p:Person)
RETURN AVG(p.age) AS avg_age;

// 24. Group by city.
MATCH (p:Person)-[:LIVES_IN]->(c:City)
RETURN c.name, COUNT(p);

// 25. Find nodes with highest degree
MATCH (p:Person)-[r]-()
RETURN p, COUNT(r) AS degree
ORDER BY degree DESC;

// 26. Detect cycles in graph
MATCH path = (p:Person)-[:FRIEND*]->(p)
RETURN path;

// 27. Find strongly connected components (conceptual)
CALL gds.stronglyConnectedComponents.stream('graph')
YIELD nodeId, componentId;

// 28. Find central nodes (high connectivity)
MATCH (p:Person)-[r]-()
RETURN p, COUNT(r) AS centrality
ORDER BY centrality DESC
LIMIT 5;
```
