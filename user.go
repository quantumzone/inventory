// Path: backend/internal/auth/models/user.go

package models

import (
    "time"
    "golang.org/x/crypto/bcrypt"
)

type Role string

const (
    AdminRole  Role = "admin"
    RegularRole Role = "regular"
)

type User struct {
    ID           uint      `gorm:"primaryKey"`
    Email        string    `gorm:"uniqueIndex;not null"`
    PasswordHash string    `gorm:"not null"`
    Role         Role      `gorm:"not null;type:varchar(50)"`
    Active       bool      `gorm:"default:true"`
    CreatedAt    time.Time `gorm:"autoCreateTime"`
    UpdatedAt    time.Time `gorm:"autoUpdateTime"`
}

// Validaciones de usuario
type CreateUserInput struct {
    Email    string `json:"email" validate:"required,email"`
    Password string `json:"password" validate:"required,min=8"`
    Role     Role   `json:"role" validate:"required,oneof=admin regular"`
}

// HashPassword crea un hash seguro de la contraseña
func (u *User) HashPassword(password string) error {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
    if err != nil {
        return err
    }
    u.PasswordHash = string(bytes)
    return nil
}

// CheckPassword verifica si la contraseña es correcta
func (u *User) CheckPassword(password string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(password))
    return err == nil
}
