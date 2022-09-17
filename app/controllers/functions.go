package controllers

import (
	"code-corpus-api/models"
	"fmt"
	"math/rand"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// as a general note, we probably also want some checking about whether
// the params passed are valid (eg, not negative or random chars),
// and we can add tests for that first, then implement those checks

// limit this to first 10 functions per language
func FindFunctions(c *gin.Context) {
	var functions []models.Function
	language := c.DefaultQuery("language", "javascript")
	page := c.DefaultQuery("page", "1")

	pagination, err := strconv.Atoi(page)
	if err != nil {
		fmt.Printf("error is: %v", err)
	}

	languageList := []string{"golang", "javascript", "python", "typescript"}

	if allowedLanguage(languageList, language) {

		models.DB.Where("language = ?", language).Offset(pagination * 10).Limit(10).Find(&functions)

		c.JSON(http.StatusOK, gin.H{"data": functions})
	} else {
		c.JSON(http.StatusNotFound, gin.H{"data": "this language not available or doesn't exist"})
	}
}

func allowedLanguage(s []string, language string) bool {
	for _, v := range s {
		if v == language {
			return true
		}
	}
	return false
}

// find one function from a specific language
func FindRandomFunction(c *gin.Context) {

	languageList := []string{"golang", "javascript", "python", "typescript"}

	language := c.DefaultQuery("language", "javascript")

	if allowedLanguage(languageList, language) {
		var count int64
		var function models.Function
		// this is a particular materialized view that needs to be created
		models.DB.Raw("SELECT count from language_counts WHERE language = ?", language).Find(&count)

		randomInt := rand.Intn(int(count))
		models.DB.Where("language = ?", language).Offset(randomInt).Limit(1).Find(&function)

		c.JSON(http.StatusOK, gin.H{"data": function})
	} else {
		c.JSON(http.StatusNotFound, gin.H{"data": "this language not available or doesn't exist"})
	}
}

// this is for integration with fargate health checks
func HealthCheck(c *gin.Context) {
	c.Writer.WriteHeader(200)
}
