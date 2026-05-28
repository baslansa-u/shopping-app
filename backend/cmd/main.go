package main

import (
	"shopping/internal/handler"
	repository "shopping/internal/repository"
	"shopping/pkg/redis"

	"github.com/gin-gonic/gin"
)

func main() {

	// Redis
	rdb := redis.NewRedis("localhost:6379")

	r := gin.Default()

	// serve local images
	r.Static("/data/logo", "./data/logo")
	r.Static("/data/imgs", "./data/imgs")

	repo := repository.NewMockRepository()

	brandHandler := handler.NewBrandHandler(repo, rdb)
	productHandler := handler.NewProductHandler(repo, rdb)

	r.GET("/brands", brandHandler.GetBrands)
	r.GET("/products", productHandler.GetProducts)

	r.Run(":8080")
}
