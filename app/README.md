# The code corpus api

This is the application code that listens for incoming requests, queries the database and returns the results.

## Local development

Make sure postgres is up and running, and ideally has some data in it. Then, start up the service:

```
go run main.go controllers/ models/
```

It will be queryable on the default port (8080).

```
curl "localhost:8080/functions?language=python&page=10
```
