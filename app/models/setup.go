package models

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
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

func ConnectDatabase() {

	mode := viper.Get("MODE")
	connectionSecretName := viper.GetString("DB_CONNECTION_STRING_SECRET")

	if mode == "production" {
		region := "eu-west-1"

		fmt.Println("starting new session...")
		//Create a Secrets Manager client
		sess, err := session.NewSession()
		if err != nil {
			// Handle session creation error
			fmt.Println(err.Error())
			return
		}
		svc := secretsmanager.New(sess,
			aws.NewConfig().WithRegion(region))
		input := &secretsmanager.GetSecretValueInput{
			SecretId:     aws.String(connectionSecretName),
			VersionStage: aws.String("AWSCURRENT"), // VersionStage defaults to AWSCURRENT if unspecified
		}

		fmt.Println("getting secret value...")
		result, err := svc.GetSecretValue(input)
		if err != nil {
			fmt.Println(err.Error())
		}

		dsn = *result.SecretString
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
