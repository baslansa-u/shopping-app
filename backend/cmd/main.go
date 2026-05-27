package main

import (
	"shopping/internal/handler"
	repository "shopping/internal/repository"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// serve local images
	r.Static("/images", "./images")

	repo := repository.NewMockRepository()

	brandHandler := handler.NewBrandHandler(repo)
	productHandler := handler.NewProductHandler(repo)

	r.GET("/brands", brandHandler.GetBrands)
	r.GET("/products", productHandler.GetProducts)

	r.Run(":8080")
}
