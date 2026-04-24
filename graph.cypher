// Q1a
CREATE (:Person {name:'SHAN', age:22});

// Q1b
CREATE (:City {name:'Kannur'});

// Q1c
MATCH (p:Person {name:'SHAN'}),(c:City {name:'Kannur'}) CREATE (p)-[:LIVES_IN]->(c);

// Q1d
CREATE (:Person {name:'SHARUN',age:22})-[:LIVES_IN]->(:City {name:'Kozhikode'}),(:Person {name:'AMITH',age:23})-[:LIVES_IN]->(:City {name:'Kochi'});

// Q2
MATCH (n) RETURN n;

// Q3.1
MATCH (p:Person) RETURN p;

// Q3.2
MATCH (p:Person {name:'SHAN'}) SET p.age=23;

// Q3.3
MATCH (p:Person {name:'SHARUN'}) DETACH DELETE p;

// Q3.4
MATCH (p:Person) SET p.gender='M';

// Q5
MATCH (p:Person)-[:LIVES_IN]->(c:City {name:'Kannur'}) RETURN p;

// Q6
MATCH (a)-[r]->(b) RETURN a,r,b;

// Q7 (create + match)
MATCH (a:Person {name:'SHAN'}),(b:Person {name:'AMITH'}) CREATE (a)-[:FRIEND]->(b);
MATCH (p1:Person)-[:FRIEND]->(p2:Person) RETURN p1,p2;

// Q8
MATCH (p1:Person)-[:FRIEND]-(p2:Person) RETURN p1,p2;

// Q9
MATCH (p:Person {name:'SHAN'})-[:FRIEND]->(f) RETURN f;

// Q10
MATCH (p:Person {name:'SHAN'})-[:FRIEND]->()-[:FRIEND]->(f2) RETURN DISTINCT f2.name;

// Q11
MATCH (p:Person {name:'SHAN'})-[:FRIEND*1..3]->(n) RETURN n;

// Q12
MATCH (p:Person {name:'SHAN'})-[:FRIEND*1..2]->(n) RETURN n;

// Q13
MATCH p=shortestPath((a:Person {name:'SHAN'})-[:FRIEND*]-(b:Person {name:'AMITH'})) RETURN p;

// Q14
MATCH p=(a:Person {name:'SHAN'})-[:FRIEND*]-(b:Person {name:'AMITH'}) RETURN p;

// Q15
MATCH p=(a:Person {name:'SHAN'})-[:FRIEND*1..3]-(b:Person {name:'AMITH'}) RETURN p;

// Q16
MATCH p=(a:Person {name:'SHAN'})-[:FRIEND*]-(b) WHERE ALL(n IN nodes(p) WHERE SINGLE(x IN nodes(p) WHERE x=n)) RETURN p;

// Q17
MATCH (p:Person) WHERE p.age > 25 RETURN p;

// Q18
MATCH (p:Person)-[:FRIEND]->(q:Person) WHERE p.age > 20 RETURN p,q;

// Q19
MATCH (p:Person {name:'SHAN'}) RETURN p;

// Q20
MATCH (p:Person) WHERE p.name IN ['SHAN','AMITH'] AND p.age > 20 RETURN p;

// Q21
MATCH (p:Person)-[:FRIEND]->(f) RETURN p.name, COUNT(f);

// Q22
MATCH (p:Person)-[:FRIEND]->(f) RETURN p, COUNT(f) AS c ORDER BY c DESC LIMIT 1;

// Q23
MATCH (p:Person) RETURN AVG(p.age);

// Q24
MATCH (p:Person)-[:LIVES_IN]->(c:City) RETURN c.name, COUNT(p);

// Q25
MATCH (p:Person)-[r]-() RETURN p, COUNT(r) AS deg ORDER BY deg DESC LIMIT 1;

// Q26
MATCH p=(n)-[:FRIEND*]->(n) RETURN p;

// Q27
MATCH (n)-[:FRIEND*]->(m) RETURN n,m;

// Q28
MATCH (p:Person)-[r]-() RETURN p, COUNT(r) AS connections ORDER BY connections DESC;