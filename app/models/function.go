package models

import (
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

// Function holds the data for one particular function result
type Function struct {
	gorm.Model
	Language string `json:"language"`
	Repo     string `json:"repo"`
	// we proably don't care about functions with more than 255 lines
	NumberOfLines uint8          `json:"numberOfLines"`
	Code          datatypes.JSON `json:"code"`
}
