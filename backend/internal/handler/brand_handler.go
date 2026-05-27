package handler

import (
	"net/http"
	repositories "shopping/internal/repository"

	"github.com/gin-gonic/gin"
)

type BrandHandler struct {
	repo repositories.Repository
}

func NewBrandHandler(repo repositories.Repository) *BrandHandler {
	return &BrandHandler{repo: repo}
}

func (h *BrandHandler) GetBrands(c *gin.Context) {
	c.JSON(http.StatusOK, h.repo.GetBrands())
}
