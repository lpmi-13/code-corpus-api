package models

import (
	"database/sql"
	"time"

	"gorm.io/datatypes"
)

// Function holds the data for one particular function result
type Function struct {
	ID        uint `gorm:"primarykey"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt sql.NullTime `gorm:"index"`
	Language  string       `json:"language"`
	Repo      string       `json:"repo"`
	// we proably don't care about functions with more than 255 lines
	NumberOfLines uint8          `json:"numberOfLines"`
	Code          datatypes.JSON `json:"code"`
}
