//in shell
//use admin
db.createUser({
    user: "admin",
    pwd: "adminPassword",
    roles: [
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "dbAdminAnyDatabase", db: "admin" },
        { role: "readWriteAnyDatabase", db: "admin" }
    ]
});
// mongosh --host localhost --port 27017

db.createUser({
    user: "maksarovd",
    pwd: "1",
    roles: [
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "dbAdminAnyDatabase", db: "admin" },
        { role: "readWriteAnyDatabase", db: "admin" }
    ]
});
// mongosh --host localhost --port 27017 -u maksarovd -p 1