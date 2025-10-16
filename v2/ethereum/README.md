# LCKY Ethereum Implementation

Реализация LCKY токена на Ethereum с использованием Solidity и Hardhat.

## Быстрый старт

```bash
# Установка зависимостей
npm install

# Компиляция
npx hardhat compile

# Тесты
npm test

# Развертывание (локально)
npx hardhat node                           # Терминал 1
npx hardhat run scripts/deploy.ts --network localhost  # Терминал 2
```

## Контракты

### LCKYToken.sol
Основной ERC20 токен с расширенной функциональностью:
- Mining с халвингом
- Donation механизмы
- Emergency SOS
- Pausable & Ownable

### LCKYMultiCurrency.sol
Factory для создания токенов, привязанных к фиатным валютам.

## Скрипты

- `deploy.ts` - Развертывание всех контрактов
- `interact.ts` - Интерактивное взаимодействие с контрактами
- `check-balance.ts` - Проверка баланса аккаунта

## Тестирование

```bash
# Запуск всех тестов
npm test

# С покрытием кода
npm run coverage

# Газ репорт
REPORT_GAS=true npm test
```

## Развертывание

### Локальная сеть
```bash
./deploy.sh
# Выберите опцию 1 (Local)
```

### Testnet (Sepolia)
```bash
# Настройте .env
cp .env.example .env
# Добавьте PRIVATE_KEY и SEPOLIA_RPC_URL

# Разверните
npx hardhat run scripts/deploy.ts --network sepolia

# Верифицируйте
npx hardhat verify --network sepolia <CONTRACT_ADDRESS>
```

### Mainnet
⚠️ Используйте с осторожностью! Проверьте все несколько раз.

```bash
npx hardhat run scripts/deploy.ts --network mainnet
```

## Взаимодействие с контрактом

```bash
# Установите адрес контракта
export CONTRACT_ADDRESS=0x...

# Запустите интерактивный скрипт
npx hardhat run scripts/interact.ts --network localhost
```

## Структура

```
ethereum/
├── contracts/          # Solidity контракты
├── scripts/           # Deployment и interaction скрипты
├── test/              # Тесты
├── hardhat.config.ts  # Hardhat конфигурация
└── package.json       # Зависимости
```

## Безопасность

- OpenZeppelin контракты (v5.0.1)
- ReentrancyGuard на всех критичных функциях
- Pausable для аварийной остановки
- Comprehensive тесты (>95% coverage)

## Лицензия

MIT

