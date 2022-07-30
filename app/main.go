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

	// probably paginate this, so we can bring back 10 at a time,
	// or even have the option to send the number requested via query params
	r.GET("/functions", controllers.FindFunctions)

	// this is just for a random function, we'll add specific language in a bit
	r.GET("/function", controllers.FindRandomFunction)

	r.Run()
}
