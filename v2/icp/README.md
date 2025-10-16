# LCKY Internet Computer Implementation

Реализация LCKY токена на Internet Computer с использованием Motoko.

## Быстрый старт

```bash
# Запуск локальной реплики
dfx start --background --clean

# Развертывание всех канистеров
dfx deploy

# Получение URL фронтенда
echo "http://$(dfx canister id lcky_frontend).localhost:4943"
```

## Канистеры

### lcky_backend
Основной токен канистер:
- ICRC-1 подобная реализация
- Mining механизм с халвингом
- Donation функции
- Emergency SOS

### payment_backend
Обработка платежей:
- Прием ICP
- Расчет exchange rate
- История транзакций

### lcky_frontend
Web интерфейс:
- Универсальный UI для Ethereum и ICP
- Wallet интеграция
- Real-time обновления

## Основные команды

```bash
# Сборка
dfx build

# Развертывание
dfx deploy

# Тестирование
./test_canister.sh

# Вызов функций
dfx canister call lcky_backend <function> '(<args>)'

# Просмотр логов
dfx canister logs lcky_backend

# Остановка
dfx stop
```

## Примеры использования

### Claim токены
```bash
# Initial claim (1000 LCKY)
dfx canister call lcky_backend claimInitial '()'

# Daily claim
dfx canister call lcky_backend claim '()'
```

### Проверка баланса
```bash
dfx canister call lcky_backend balanceOf "(principal \"$(dfx identity get-principal)\")"
```

### Donation с сообщением
```bash
dfx canister call lcky_backend donateWithMessage '(100_000_000_000_000_000_000, "Для храма!")'
```

### Просмотр статистики
```bash
dfx canister call lcky_backend getStats '()'
```

## Развертывание на mainnet

```bash
# Убедитесь, что у вас есть циклы
dfx wallet --network ic balance

# Разверните
dfx deploy --network ic --with-cycles 10000000000000

# Получите canister IDs
dfx canister --network ic id lcky_backend
```

## Структура

```
icp/
├── src/
│   ├── lcky_backend/      # Основной токен
│   ├── payment_backend/   # Платежи
│   └── lcky_frontend/     # Frontend
├── dfx.json              # DFX конфигурация
├── mops.toml             # Motoko пакеты
└── deploy.sh             # Deploy скрипт
```

## Тестирование

Запустите комплексное тестирование:
```bash
./test_canister.sh
```

Скрипт проверит:
- ✅ Token info
- ✅ Claiming механизм
- ✅ Donations
- ✅ Payment backend
- ✅ Все основные функции

## Мониторинг

### Проверка циклов
```bash
dfx canister --network ic status lcky_backend
```

### Пополнение циклов
```bash
dfx canister --network ic deposit-cycles 1000000000000 lcky_backend
```

## Безопасность

- Access control на всех функциях
- Stable storage для persistence
- Input validation
- Cycles monitoring

## Лицензия

MIT

