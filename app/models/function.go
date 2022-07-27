package models

type CodeSnippet struct {
	LineNumber  uint   `json:"lineNumber"`
	LineContent string `json:"lineContent"`
}

type Function struct {
	ID            uint          `json:"if" gorm:"primary_key"`
	Language      string        `json:"language"`
	Repo          string        `json:"repo"`
	NumberOfLines uint          `json:"numberOfLines"`
	Code          []CodeSnippet `json:"code"`
}
