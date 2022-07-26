package main

import (
	"code-corpus-api/controllers"
	"code-corpus-api/models"

	"github.com/gin-gonic/gin"
)

func main() {
	// set the mode (ie, DEBUG or PRODUCTION) to be parameterized at startup
	r := gin.Default()

	models.ConnectDatabase()

	r.GET("/books", controllers.FindBooks)
	r.POST("/books", controllers.CreateBook)
	r.GET("/books/:id", controllers.FindBook)
	r.PATCH("/books/:id", controllers.UpdateBook)
	r.DELETE("/books/:id", controllers.DeleteBook)

	r.Run()
}
