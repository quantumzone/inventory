// Path: backend/internal/auth/controllers/auth_controller.go

package controllers

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "github.com/quantumzone/inventory/internal/auth/models"
    "github.com/quantumzone/inventory/internal/auth/services"
)

type AuthController struct {
    authService *services.AuthService
}

func NewAuthController(authService *services.AuthService) *AuthController {
    return &AuthController{authService}
}

func (c *AuthController) Register(ctx *gin.Context) {
    var input models.CreateUserInput
    if err := ctx.ShouldBindJSON(&input); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    user, err := c.authService.CreateUser(input)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating user"})
        return
    }

    ctx.JSON(http.StatusCreated, gin.H{
        "user": gin.H{
            "id":    user.ID,
            "email": user.Email,
            "role":  user.Role,
        },
    })
}

func (c *AuthController) Login(ctx *gin.Context) {
    var input struct {
        Email    string `json:"email" binding:"required,email"`
        Password string `json:"password" binding:"required"`
    }

    if err := ctx.ShouldBindJSON(&input); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    user, token, err := c.authService.Authenticate(input.Email, input.Password)
    if err != nil {
        ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    ctx.JSON(http.StatusOK, gin.H{
        "token": token,
        "user": gin.H{
            "id":    user.ID,
            "email": user.Email,
            "role":  user.Role,
        },
    })
}
