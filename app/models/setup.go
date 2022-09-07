package models

import (
	"encoding/json"
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/secretsmanager"
	"github.com/spf13/viper"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	DB  *gorm.DB
	dsn string
)

type SecretString struct {
	ConnectionString string
}

func ConnectDatabase() {

	mode := viper.Get("MODE")
	connectionSecretName := viper.GetString("DB_CONNECTION_STRING_SECRET")

	if mode == "production" {
		region := "eu-west-1"
		// this is unfortunate hardcoding, but no obvious way to get it dynamically
		role_arn := "arn:aws:iam::366325906679:role/ecs-task-role"

		fmt.Println("starting new session...")

		// create a session for the service to assume the role
		sess := session.Must(session.NewSession())
		creds := stscreds.NewCredentials(sess, role_arn)

		svc := secretsmanager.New(sess,
			&aws.Config{
				Credentials: creds,
				Region:      &region,
			})
		input := &secretsmanager.GetSecretValueInput{
			SecretId:     aws.String(connectionSecretName),
			VersionStage: aws.String("AWSCURRENT"), // VersionStage defaults to AWSCURRENT if unspecified
		}

		fmt.Println("getting secret value...")
		result, err := svc.GetSecretValue(input)
		if err != nil {
			fmt.Println(err.Error())
		}

		var connectionString string
		json.Unmarshal([]byte(*result.SecretString), &connectionString)

		dsn = connectionString
		fmt.Println("dsn set as: ", dsn)
	} else {
		dsn = "host=localhost user=codez password=codez-control dbname=code port=5432 sslmode=disable"
	}

	database, err := gorm.Open(postgres.Open(dsn))

	if err != nil {
		fmt.Println("the problem is: ", err)
		panic("failed to connect to database")
	}

	database.AutoMigrate(&Function{})

	DB = database
}
