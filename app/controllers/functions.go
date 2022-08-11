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
// and we can add tests for that first, then implement that checks

// limit this to first 10 functions per language
func FindFunctions(c *gin.Context) {
	var functions []models.Function
	language := c.DefaultQuery("language", "javascript")
	page := c.DefaultQuery("page", "1")

	fmt.Println(page)
	pagination, err := strconv.Atoi(page)
	if err != nil {
		fmt.Printf("error is: %v", err)
	}

	models.DB.Where("language = ?", language).Offset(pagination * 10).Limit(10).Find(&functions)

	c.JSON(http.StatusOK, gin.H{"data": functions})
}

// find one function from a specific language
func FindRandomFunction(c *gin.Context) {
	var count int64
	var function models.Function
	models.DB.Model(&function).Where("language = ?", c.Query("language")).Count(&count)

	randomInt := rand.Intn(int(count))
	models.DB.Where("language = ?", c.Query("language")).Offset(randomInt).Limit(1).Find(&function)

	c.JSON(http.StatusOK, gin.H{"data": function})
}
