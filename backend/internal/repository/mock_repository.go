package repositories

import "shopping/internal/models"

type Repository interface {
	GetBrands() []models.Brand
	GetProducts() []models.Product
}

type MockRe struct{}

func NewMockRepository() Repository {
	return &MockRe{}
}

func (m *MockRe) GetBrands() []models.Brand {
	return []models.Brand{
		{Name: "Apple", Logo: "http://10.0.2.2:8080/images/apple.png"},
		{Name: "Samsung", Logo: "http://10.0.2.2:8080/images/samsung.png"},
	}
}

func (m *MockRe) GetProducts() []models.Product {
	return []models.Product{
		{
			ID:       1,
			Name:     "iPhone 15",
			ImageURL: "http://10.0.2.2:8080/images/iphone15.png",
			Price:    45000,
			Brand:    "apple",
		},
		{
			ID:       2,
			Name:     "Galaxy S24",
			ImageURL: "http://10.0.2.2:8080/images/galaxys24.png",
			Price:    38000,
			Brand:    "samsung",
		},
	}
}
