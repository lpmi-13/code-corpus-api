package controllers

import (
	"code-corpus-api/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func FindFunction(c *gin.Context) {
	var function models.Function
	if err := models.DB.Where("id = ?", c.Param("id")).First(&function).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Function not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": function})
}

// this currently will bring back all the functions, so we probably
// want to limit it to the first 10 found
func FindFunctions(c *gin.Context) {
	var functions []models.Function
	models.DB.Find(&functions)

	c.JSON(http.StatusOK, gin.H{"data": functions})
}
