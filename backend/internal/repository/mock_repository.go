package repositories

import (
	"encoding/json"
	"os"
	"shopping/internal/models"
)

type Repository interface {
	GetBrands() []models.Brand
	GetProducts() []models.Product
}

type MockRe struct {
	products []models.Product
}

func NewMockRepository() Repository {
	r := &MockRe{}
	r.loadProducts()
	return r
}

func (m *MockRe) loadProducts() {
	file, err := os.ReadFile("data/products.json")
	if err != nil {
		panic(err)
	}

	var products []models.Product
	err = json.Unmarshal(file, &products)
	if err != nil {
		panic(err)
	}

	m.products = products
}

func (m *MockRe) GetBrands() []models.Brand {
	return []models.Brand{
		{Name: "Apple", Logo: "http://10.0.2.2:8080/data/logo/apple.png"},
		{Name: "Samsung", Logo: "http://10.0.2.2:8080/data/logo/samsung.png"},
	}
}

func (m *MockRe) GetProducts() []models.Product {
	return m.products
}
