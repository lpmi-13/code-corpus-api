package main

import (
	"code-corpus-api/controllers"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func SetUpRouter() *gin.Engine {
	router := gin.Default()
	return router
}

func TestHealthCheckHandler(t *testing.T) {
	// this is just an empty response with a 200 status code
	mockResponse := ``
	r := SetUpRouter()
	r.GET("/healthcheck", controllers.HealthCheck)
	req, _ := http.NewRequest("GET", "/healthcheck", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	responseData, _ := ioutil.ReadAll(w.Body)
	assert.Equal(t, mockResponse, string(responseData))
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestPageNotFound(t *testing.T) {
	mockResponse := `404 page not found`
	r := SetUpRouter()
	req, _ := http.NewRequest("GET", "/pageDoesNotExist", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	responseData, _ := ioutil.ReadAll(w.Body)
	assert.Equal(t, mockResponse, string(responseData))
	assert.Equal(t, http.StatusNotFound, w.Code)
}
