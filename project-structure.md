```
inventory/
├── backend/
│   ├── cmd/
│   │   └── main.go
│   ├── internal/
│   │   ├── auth/
│   │   │   ├── controllers/
│   │   │   ├── middleware/
│   │   │   └── services/
│   │   ├── equipment/
│   │   │   ├── controllers/
│   │   │   ├── models/
│   │   │   └── services/
│   │   ├── maintenance/
│   │   │   ├── controllers/
│   │   │   ├── models/
│   │   │   └── services/
│   │   └── reports/
│   │       ├── controllers/
│   │       ├── templates/
│   │       └── services/
│   ├── pkg/
│   │   ├── database/
│   │   ├── logger/
│   │   └── validator/
│   ├── migrations/
│   │   └── schemas/
│   ├── scripts/
│   │   └── setup.sh
│   └── tests/
│       ├── integration/
│       └── unit/
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── assets/
│   │   ├── components/
│   │   │   ├── equipment/
│   │   │   ├── maintenance/
│   │   │   └── reports/
│   │   ├── layouts/
│   │   ├── pages/
│   │   ├── router/
│   │   ├── services/
│   │   └── store/
│   └── tests/
├── docs/
│   ├── api/
│   ├── database/
│   └── deployment/
├── .gitignore
├── README.md
├── docker-compose.yml
└── Makefile
```
