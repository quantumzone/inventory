// Path: backend/internal/auth/middleware/auth_middleware.go

package middleware

import (
    "net/http"
    "strings"
    "github.com/gin-gonic/gin"
    "github.com/quantumzone/inventory/internal/auth/services"
    "github.com/quantumzone/inventory/internal/auth/models"
)

type AuthMiddleware struct {
    authService *services.AuthService
}

func NewAuthMiddleware(authService *services.AuthService) *AuthMiddleware {
    return &AuthMiddleware{authService}
}

func (m *AuthMiddleware) AuthRequired() gin.HandlerFunc {
    return func(c *gin.Context) {
        auth := c.GetHeader("Authorization")
        if auth == "" {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "no authorization header"})
            c.Abort()
            return
        }

        token := strings.Replace(auth, "Bearer ", "", 1)
        claims, err := m.authService.ValidateToken(token)
        if err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
            c.Abort()
            return
        }

        c.Set("user_id", claims.UserID)
        c.Set("email", claims.Email)
        c.Set("role", claims.Role)
        c.Next()
    }
}

func (m *AuthMiddleware) AdminRequired() gin.HandlerFunc {
    return func(c *gin.Context) {
        role := c.GetString("role")
        if role != string(models.AdminRole) {
            c.JSON(http.StatusForbidden, gin.H{"error": "admin access required"})
            c.Abort()
            return
        }
        c.Next()
    }
}
