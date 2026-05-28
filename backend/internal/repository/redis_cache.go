package repositories

import (
	"context"
	"encoding/json"
	"shopping/internal/models"
	"time"

	"github.com/redis/go-redis/v9"
)

type RedisCacheRepo struct {
	rdb *redis.Client
	ttl time.Duration
}

func NewRedisCacheRepo(rdb *redis.Client) *RedisCacheRepo {
	return &RedisCacheRepo{
		rdb: rdb,
		ttl: 15 * time.Minute,
	}
}

func (r *RedisCacheRepo) GetBrands() ([]models.Brand, error) {
	var brands []models.Brand

	data, err := r.rdb.Get(context.Background(), "brands").Result()
	if err == redis.Nil {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	err = json.Unmarshal([]byte(data), &brands)
	if err != nil {
		return nil, err
	}

	return brands, nil
}

func (r *RedisCacheRepo) GetProducts() ([]models.Product, error) {
	var products []models.Product

	data, err := r.rdb.Get(context.Background(), "products").Result()
	if err == redis.Nil {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	err = json.Unmarshal([]byte(data), &products)
	if err != nil {
		return nil, err
	}

	return products, nil
}

func (r *RedisCacheRepo) SetBrands(brands []models.Brand) error {
	data, err := json.Marshal(brands)
	if err != nil {
		return err
	}

	return r.rdb.Set(context.Background(), "brands", data, r.ttl).Err()
}

func (r *RedisCacheRepo) SetProducts(products []models.Product) error {
	data, err := json.Marshal(products)
	if err != nil {
		return err
	}

	return r.rdb.Set(context.Background(), "products", data, r.ttl).Err()
}
