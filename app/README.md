# The code corpus api

This is the application code that listens for incoming requests, queries the database and returns the results.

## Local development

You can start up the docker-compose stack (which is basically just postgres), and then run the webserver manually (so you can stop/start it for code changes):

> Putting in data can be done via the included script `invoke.py` after postgres is up. It should persist between container runs, so you'll only have to put data in there once.

```
go run main.go controllers/ models/
```

> If you feel like having the code reload on changes and like using node to run go, use `nodemon --exec go run main.go controllers/ models/ --signal SIGTERM`

The application will be queryable on the default port (8080).

```
curl "localhost:8080/functions?language=python&page=10
```

> Note: the random function endpoint relies on a materialized view called `language_counts` to get the count quickly, so if you're starting the database from scratch, make sure to create that with `CREATE MATERIALIZED VIEW language_counts AS select count(*), language FROM functions GROUP BY language;`

## CI

the GitHub action pushes a new image to ECR, so make sure you have a repo set up there, to get all the container image pushes. You'll also need to make sure that you add

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

to your repository secrets. For these credentials, you can create an IAM user and add an inline policy that allows only pushing images to ECR.

This is currently set up to only fire when there is an explicit change to any file in the `./app` directory.
