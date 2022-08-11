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

## CI

the GitHub action pushes a new image to ECR, so make sure you have a repo set up there, to get all the container image pushes. You'll also need to make sure that you add

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

to your repository secrets. For these credentials, you can create an IAM user and add an inline policy that allows only pushing images to ECR.

This is currently set up to only fire when there is an explicit change to any file in the `./app` directory.
