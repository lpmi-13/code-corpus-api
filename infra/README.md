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

for the moment, we're still installing postgresql client tooling manually, but we can probably put this in user data or something:

```
sudo apt install -y postgresql-client
```

you can use the endpoint for the RDS to connect to the database from the bastion and check what databases exist.

(for example)
```
psql -h api-datastore.cjzeg4bvhcx2.eu-west-1.rds.amazonaws.com -U CHANGE_ME -l
```
