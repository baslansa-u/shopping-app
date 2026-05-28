package handler

import (
	"context"
	"encoding/json"
	"net/http"
	"shopping/internal/models"
	repositories "shopping/internal/repository"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
)

type BrandHandler struct {
	repo repositories.Repository
	rdb  *redis.Client
}

func NewBrandHandler(repo repositories.Repository, rdb *redis.Client) *BrandHandler {
	return &BrandHandler{
		repo: repo,
		rdb:  rdb,
	}
}

func (h *BrandHandler) GetBrands(c *gin.Context) {
	ctx := context.Background()
	cacheKey := "brands"

	// 1. check cache
	val, err := h.rdb.Get(ctx, cacheKey).Result()
	if err == nil {
		var brands []models.Brand
		json.Unmarshal([]byte(val), &brands)

		c.JSON(http.StatusOK, gin.H{
			"source": "redis",
			"data":   brands,
		})
		return
	}

	// 2. miss → repo
	brands := h.repo.GetBrands()

	// 3. save cache
	data, _ := json.Marshal(brands)
	h.rdb.Set(ctx, cacheKey, data, 6*time.Hour)

	c.JSON(http.StatusOK, gin.H{
		"source": "db",
		"data":   brands,
	})
}
