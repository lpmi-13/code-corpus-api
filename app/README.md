# The code corpus api

This is the application code that listens for incoming requests, queries the database and returns the results.

This has some open telemetry set up, so if you'd like to do that, follow the instructions at https://docs.honeycomb.io/getting-data-in/opentelemetry/go-distro/

...otherwise, there _will probably_ be some way to disable this when running locally

## Local development

1. You can start up the docker-compose stack (which is basically just postgres), and then run the webserver manually (so you can stop/start it for code changes). The scripts to create the database and table are both specified in the compose file, so that should be all set up once the postgres container is up and running.

2. After that, put in data via the included script `invoke.py`. It should persist between container runs, so you'll only have to put data in there once.

3. Finally, the random function endpoint relies on a materialized view called `language_counts` to get the count quickly, so if you're starting the database from scratch, make sure to create that with `psql -h localhost -U $DB_USER -d $DATABASE -f ~/create_materialized_view.sql`.

4. When that's all done, you should be able to start the application (I kept it out of the compose stack to allow restarts on code changes):

```
go run main.go controllers/ models/
```

> If you feel like having the code reload on changes and like using node to run go, use `nodemon --exec go run main.go controllers/ models/ --signal SIGTERM`

The application will be queryable on the default port (8080).

```
curl "localhost:8080/functions?language=python&page=10
```

## CI

the GitHub action pushes a new image to ECR, so make sure you have a repo set up there, to get all the container image pushes. You'll also need to make sure that you add

-   `AWS_ACCESS_KEY_ID`
-   `AWS_SECRET_ACCESS_KEY`

to your repository secrets. For these credentials, you can create an IAM user and add an inline policy that allows only pushing images to ECR.

This is currently set up to only fire when there is an explicit change to any file in the `./app` directory.

## Integration with the code in the "infra/" directory

The decision to keep both the application code and the infrastructure code in the same repo was to make it easier to access the sql creation scripts and the data injection script (both in this repo) from the other directory when setting things up.

The `sql/create_database.sql`, `sql/create_materialized_view.sql` and `inject.py` are used while testing locally as well as setting up the production service.
