package controllers

import (
	"code-corpus-api/models"
	"math/rand"
	"net/http"

	"github.com/gin-gonic/gin"
)

// limit this to first 10 functions per language
func FindFunctions(c *gin.Context) {
	var functions []models.Function
	models.DB.Where("language = ?", c.Query("language")).Find(&functions).Limit(10)

	c.JSON(http.StatusOK, gin.H{"data": functions})
}

// find one language from a specific language
func FindRandomFunction(c *gin.Context) {
	var count int64
	var function models.Function
	models.DB.Model(&function).Where("language = ?", c.Query("language")).Count(&count)

	randomInt := rand.Intn(int(count))
	models.DB.Where("language = ?", c.Query("language")).Offset(randomInt).Find(&function)
	c.JSON(http.StatusOK, gin.H{"data": function})
}
