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

	// we'll probably only need this for a randomly chosen function,
	// but we might also want to pass query params to narrow down where
	// a random function is chosen from (eg, language, length, etc)
	r.GET("/function/:id", controllers.FindFunction)

	r.Run()
}
