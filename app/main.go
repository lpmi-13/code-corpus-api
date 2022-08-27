package main

import (
	"code-corpus-api/controllers"
	"code-corpus-api/models"

	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

func main() {

	// don't bother overriding the mode when developing locally
	viper.SetDefault("MODE", "dev")
	viper.SetDefault("PORT", "8080")
	// we only actually need this when the service is running in ECS
	viper.SetDefault("DB_CONNECTION_STRING_SECRET", "DEFAULT")

	viper.AutomaticEnv() // Automatically search for environment variables

	mode := viper.Get("MODE")
	if mode == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	port := viper.GetString("PORT")

	r := gin.Default()
	r.SetTrustedProxies(nil)

	models.ConnectDatabase()

	// probably paginate this, so we can bring back 10 at a time,
	// or even have the option to send the number requested via query params
	r.GET("/functions", controllers.FindFunctions)

	// this is just for a random function, we'll add specific language in a bit
	r.GET("/function", controllers.FindRandomFunction)

	// let fargate confirm the task is healthy
	r.GET("/healthcheck", controllers.HealthCheck)

	r.Run(":" + port)
}
