package models

import (
	"fmt"

	"github.com/aws/aws-secretsmanager-caching-go/secretcache"
	"github.com/spf13/viper"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	DB             *gorm.DB
	dsn            string
	err            error
	secretCache, _ = secretcache.New()
)

func ConnectDatabase() {

	mode := viper.Get("MODE")
	connectionString := viper.GetString("DB_CONNECTION_STRING_SECRET")

	if mode == "production" {
		dsn, err = secretCache.GetSecretString(connectionString)
		if err != nil {
			fmt.Println("couldn't get database connection secret string: ", err)
		}
	}
	dsn = "host=localhost user=codez password=codez-control dbname=code port=5432 sslmode=disable"

	database, err := gorm.Open(postgres.Open(dsn))

	if err != nil {
		fmt.Println("the problem is: ", err)
		panic("failed to connect to database")
	}

	database.AutoMigrate(&Function{})

	DB = database
}
