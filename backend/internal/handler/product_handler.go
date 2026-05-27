package handler

import (
	"net/http"

	"shopping/internal/models"
	repository "shopping/internal/repository"

	"github.com/gin-gonic/gin"
)

type ProductHandler struct {
	repo repository.Repository
}

func NewProductHandler(r repository.Repository) *ProductHandler {
	return &ProductHandler{repo: r}
}

func (h *ProductHandler) GetProducts(c *gin.Context) {
	brand := c.Query("brand")

	products := h.repo.GetProducts()

	if brand != "" {
		var filtered []models.Product
		for _, p := range products {
			if p.Brand == brand {
				filtered = append(filtered, p)
			}
		}
		products = filtered
	}

	c.JSON(http.StatusOK, products)
}
