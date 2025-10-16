# 🪄 LCKY v2 - START HERE! ✨

Добро пожаловать в LCKY v2 - кросс-чейн платформу волшебных токенов!

## 🎯 Что это?

LCKY v2 - это полнофункциональная платформа токенов, работающая на двух блокчейнах:
- **Ethereum (EVM)** - для широкой совместимости
- **Internet Computer (ICP)** - для масштабируемости и низких комиссий

## 🚀 С чего начать?

### Вариант 1: Быстрый старт (5 минут)

Читайте **[QUICKSTART.md](QUICKSTART.md)** для мгновенного запуска на локальной сети.

### Вариант 2: Полное изучение

1. **[README.md](README.md)** - Обзор проекта и основные возможности
2. **[ARCHITECTURE.md](ARCHITECTURE.md)** - Как всё работает под капотом
3. **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Развертывание в production
4. **[API_REFERENCE.md](API_REFERENCE.md)** - Справочник по всем функциям

## 📚 Документация

| Файл | Для кого | Что внутри |
|------|----------|------------|
| **QUICKSTART.md** | Новички | Запуск за 5 минут |
| **README.md** | Все | Обзор проекта |
| **ARCHITECTURE.md** | Разработчики | Детальная архитектура |
| **DEPLOYMENT_GUIDE.md** | DevOps | Полное руководство по развертыванию |
| **API_REFERENCE.md** | Интеграторы | Справочник API |
| **CONTRIBUTING.md** | Контрибьюторы | Как внести вклад |
| **SECURITY.md** | Security researchers | Политика безопасности |
| **PROJECT_SUMMARY.md** | Project managers | Полный обзор проекта |
| **CHANGELOG.md** | Все | История изменений |

## 🏗️ Структура проекта

```
LCKY/v2/
│
├── 📖 Документация (11 MD файлов)
│   ├── START_HERE.md          ← Вы здесь
│   ├── QUICKSTART.md          ← Начните отсюда!
│   ├── README.md
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT_GUIDE.md
│   ├── API_REFERENCE.md
│   └── ...
│
├── 🔷 ethereum/                ← Ethereum реализация
│   ├── contracts/              (2 Solidity контракта)
│   ├── test/                   (65+ тестов)
│   ├── scripts/                (3 полезных скрипта)
│   └── README.md               (Ethereum-specific docs)
│
├── ♾️ icp/                     ← ICP реализация
│   ├── src/
│   │   ├── lcky_backend/       (Основной токен)
│   │   ├── payment_backend/    (Платежи)
│   │   └── lcky_frontend/      (Web UI)
│   └── README.md               (ICP-specific docs)
│
└── 🎨 assets/                  ← Общие ресурсы
    └── lckycoin.json           (Метаданные токена)
```

## 🎬 Первые шаги

### Шаг 1: Выберите платформу

**Ethereum** - если вам нужна совместимость с существующими DeFi протоколами
```bash
cd ethereum
npm install
npx hardhat node
```

**ICP** - если важна скорость и низкие комиссии
```bash
cd icp
dfx start --background
dfx deploy
```

### Шаг 2: Запустите тесты

**Ethereum:**
```bash
cd ethereum
npm test
```

**ICP:**
```bash
cd icp
./test_canister.sh
```

### Шаг 3: Изучите функционал

Откройте **[API_REFERENCE.md](API_REFERENCE.md)** и попробуйте:
- ✅ Claim начальных токенов
- ✅ Ежедневный mining
- ✅ Donation с сообщением
- ✅ Обмен ETH/ICP на LCKY
- ✅ Emergency SOS

## 💡 Ключевые возможности

### 1. Mining с халвингом 🪙
```solidity
// Награда уменьшается каждые 4 года
getCurrentBlockReward() // 50 → 25 → 12.5 → ...
```

### 2. Donation с сообщениями 💬
```solidity
// Сожгите токены, оставив вечное послание
donateWithMessage(100, "Для храма!")
```

### 3. ETH/ICP → LCKY 💰
```solidity
// Обменяйте крипту на LCKY
donateETH() // 1 ETH = 10,000 LCKY
donateICP() // 1 ICP = 100 LCKY
```

### 4. Emergency SOS 🚨
```solidity
// Получите свою долю ETH/ICP обратно
emergencySOS() // Сожгите LCKY → Получите ETH/ICP
```

## 🎯 Следующие шаги

### Для разработчиков
1. Изучите [ARCHITECTURE.md](ARCHITECTURE.md)
2. Прочитайте [API_REFERENCE.md](API_REFERENCE.md)
3. Запустите тесты
4. Начните интеграцию

### Для деплоя
1. Изучите [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
2. Настройте окружение
3. Разверните на testnet
4. Протестируйте
5. Deploy на mainnet

### Для контрибьюторов
1. Прочитайте [CONTRIBUTING.md](CONTRIBUTING.md)
2. Fork репозитория
3. Создайте feature branch
4. Сделайте PR

## 📊 Статистика проекта

- **📝 Lines of Code**: 3,500+
- **🔐 Smart Contracts**: 4 (2 Ethereum + 2 ICP)
- **🧪 Tests**: 65+
- **📖 Documentation**: 11 файлов
- **🌍 Networks**: 2 блокчейна
- **⚡ Features**: 10+ основных функций
- **✅ Test Coverage**: >95%

## 🛠️ Быстрые команды

### Ethereum
```bash
cd ethereum

# Setup
npm install

# Test
npm test

# Deploy (local)
npx hardhat node                              # Terminal 1
npx hardhat run scripts/deploy.ts --network localhost  # Terminal 2

# Interact
export CONTRACT_ADDRESS=0x...
npx hardhat run scripts/interact.ts --network localhost
```

### ICP
```bash
cd icp

# Setup & Deploy
dfx start --background
dfx deploy

# Test
./test_canister.sh

# Interact
dfx canister call lcky_backend getStats '()'
dfx canister call lcky_backend claimInitial '()'
```

## 🎓 Обучающие материалы

### Новичкам в блокчейне
1. Начните с [QUICKSTART.md](QUICKSTART.md)
2. Попробуйте все функции на локальной сети
3. Изучите базовые концепции в [README.md](README.md)

### Опытным разработчикам
1. Dive into [ARCHITECTURE.md](ARCHITECTURE.md)
2. Review контракты в `ethereum/contracts/`
3. Explore Motoko code в `icp/src/`
4. Check тесты для примеров использования

## 🔒 Безопасность

**Важно!** Прочитайте [SECURITY.md](SECURITY.md) перед использованием в production.

- ✅ OpenZeppelin контракты
- ✅ ReentrancyGuard
- ✅ Comprehensive тесты
- ⏳ Audit запланирован

**Нашли уязвимость?** → security@lckycoin.com

## 🤝 Сообщество

- **Discord**: [Join us](https://discord.gg/lckycoin) (TBD)
- **Telegram**: [@lckycoin](https://t.me/lckycoin) (TBD)
- **Twitter**: [@lckycoin](https://twitter.com/lckycoin) (TBD)
- **Email**: info@lckycoin.com

## 📅 Roadmap

- **Q1 2025**: Testnet deployment, Security audit ✅
- **Q2 2025**: Mainnet launch, DEX listings 🔄
- **Q3 2025**: Cross-chain bridge, Mobile app 📅
- **Q4 2025**: DAO governance, V3 planning 📅

## 🆘 Помощь

Нужна помощь?

1. **Документация**: Проверьте соответствующий .md файл
2. **GitHub Issues**: Откройте issue
3. **Discord**: Спросите в сообществе
4. **Email**: support@lckycoin.com

## 🎉 Готовы начать?

### Выберите свой путь:

**🚀 Быстрый старт (5 мин)**
→ [QUICKSTART.md](QUICKSTART.md)

**📖 Полное изучение (30 мин)**
→ [README.md](README.md) → [ARCHITECTURE.md](ARCHITECTURE.md)

**💻 Разработка (1-2 часа)**
→ [API_REFERENCE.md](API_REFERENCE.md) → Код → Тесты

**🚢 Production Deploy**
→ [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

<div align="center">

## 🪄 Добро пожаловать в волшебный мир LCKY! ✨

**Где технология встречается с магией**

Made with ❤️ by LCKY Team

[Website](https://lckycoin.com) • [GitHub](https://github.com/lckycoin) • [Discord](https://discord.gg/lckycoin) • [Twitter](https://twitter.com/lckycoin)

</div>

