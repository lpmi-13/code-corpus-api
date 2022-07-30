package models

import (
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	// this host is for inside the compose network...should be parameterized
	dsn := "host=localhost user=codez password=codez-control dbname=code port=5432 sslmode=disable"

	database, err := gorm.Open(postgres.Open(dsn))

	if err != nil {
		panic("failed to connect to database")
	}

	database.AutoMigrate(&Function{})

	DB = database
}
