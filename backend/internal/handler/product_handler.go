package handler

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"shopping/internal/models"
	repository "shopping/internal/repository"

	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
)

type ProductHandler struct {
	rdb  *redis.Client
	repo repository.Repository
}

func NewProductHandler(r repository.Repository, rdb *redis.Client) *ProductHandler {
	return &ProductHandler{
		repo: r,
		rdb:  rdb,
	}
}

func (h *ProductHandler) GetProducts(c *gin.Context) {
	ctx := context.Background()

	brand := c.Query("brand")
	cacheKey := "products:" + brand

	// 1. check cache
	val, err := h.rdb.Get(ctx, cacheKey).Result()
	if err == nil {
		var cached []models.Product
		json.Unmarshal([]byte(val), &cached)

		c.JSON(http.StatusOK, gin.H{
			"source": "redis",
			"data":   cached,
		})
		return
	}

	// 2. miss → repo
	products := h.repo.GetProducts()

	// filter
	if brand != "" {
		var filtered []models.Product
		for _, p := range products {
			if p.Brand == brand {
				filtered = append(filtered, p)
			}
		}
		products = filtered
	}

	// 3. save cache
	data, _ := json.Marshal(products)
	h.rdb.Set(ctx, cacheKey, data, 15*time.Minute)

	c.JSON(http.StatusOK, gin.H{
		"source": "db",
		"data":   products,
	})
}
