# Setting up the infrastructure

I chose AWS for this api, mostly since I know it the best, and I wanted to get more experience using terraform in this particular cloud.

## preliminary steps

to set it all up, first generate your SSH keys, and set your public IP in the variables with the following:

```
./generate_keys.sh
```

and then

```
./set_public_ip.sh
```

## creating resources in AWS

> NOTE: since you need to push an image to ECR before the api service can start up, follow the instructions in the [app README](../app/README.md) to run the workflow and push an image for fargate to find.

when everything's ready, go ahead and run

```
./apply.sh
```

That should create everything you need, and you'll see the public IP of the new bastion host output to the terminal. Use that IP to ssh in and seed the database.

> NOTE: since this host is running an ubuntu AMI, you'll need to use `ssh -i terraform.ed25519 ubuntu@PUBLIC_IP`, _not_ `ec2-user@PUBLIC_IP`

## Post-create actions

now you should be able to hit the api and get back some functions:

```
curl --silent 'https://DOMAIN/function?language=golang' | jq .

{
  "data": {
    "ID": 3841,
    "CreatedAt": "0001-01-01T00:00:00Z",
    "UpdatedAt": "0001-01-01T00:00:00Z",
    "DeletedAt": null,
    "language": "golang",
    "repo": "https://github.com/repositories/hybridgroup/gocv",
    "numberOfLines": 3,
    "code": [
      {
        "line_number": 1,
        "line_content": "func (m *Mat) MultiplyFloat(val float32) {"
      },
      {
        "line_number": 2,
        "line_content": "\tC.Mat_MultiplyFloat(m.p, C.float(val))"
      },
      {
        "line_number": 3,
        "line_content": "}"
      }
    ]
  }
}

```
