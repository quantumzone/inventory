// Path: backend/internal/auth/services/auth_service.go

package services

import (
    "errors"
    "time"
    "github.com/golang-jwt/jwt/v4"
    "github.com/quantumzone/inventory/internal/auth/models"
    "gorm.io/gorm"
)

type AuthService struct {
    db          *gorm.DB
    jwtSecret   []byte
    tokenExpiry time.Duration
}

type TokenClaims struct {
    UserID uint   `json:"user_id"`
    Email  string `json:"email"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

func NewAuthService(db *gorm.DB, jwtSecret string) *AuthService {
    return &AuthService{
        db:          db,
        jwtSecret:   []byte(jwtSecret),
        tokenExpiry: 24 * time.Hour,
    }
}

func (s *AuthService) CreateUser(input models.CreateUserInput) (*models.User, error) {
    user := &models.User{
        Email: input.Email,
        Role:  input.Role,
    }

    if err := user.HashPassword(input.Password); err != nil {
        return nil, err
    }

    if err := s.db.Create(user).Error; err != nil {
        return nil, err
    }

    return user, nil
}

func (s *AuthService) GenerateToken(user *models.User) (string, error) {
    claims := TokenClaims{
        user.ID,
        user.Email,
        string(user.Role),
        jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(s.tokenExpiry)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
        },
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(s.jwtSecret)
}

func (s *AuthService) ValidateToken(tokenString string) (*TokenClaims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &TokenClaims{}, func(token *jwt.Token) (interface{}, error) {
        return s.jwtSecret, nil
    })

    if err != nil {
        return nil, err
    }

    if claims, ok := token.Claims.(*TokenClaims); ok && token.Valid {
        return claims, nil
    }

    return nil, errors.New("invalid token")
}

func (s *AuthService) Authenticate(email, password string) (*models.User, string, error) {
    var user models.User
    if err := s.db.Where("email = ?", email).First(&user).Error; err != nil {
        return nil, "", errors.New("invalid credentials")
    }

    if !user.CheckPassword(password) {
        return nil, "", errors.New("invalid credentials")
    }

    token, err := s.GenerateToken(&user)
    if err != nil {
        return nil, "", err
    }

    return &user, token, nil
}
