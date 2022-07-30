package models

import (
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

type Function struct {
	gorm.Model
	Language string `json:"language"`
	Repo     string `json:"repo"`
	// we proably don't care about functions with more than 255 lines
	NumberOfLines uint8          `json:"numberOfLines"`
	Code          datatypes.JSON `json:"code"`
}
