# LCKY v2 - Multi-Chain Lucky Coin Platform 🪄🍯

**Languages:** [English](README_en.md) | [中文](README_cn.md) | [ไทย](README_th.md) | [हिंदी](README_hi.md) | [עברית](README_he.md) | **Русский**

## О проекте

LCKY v2 - это кросс-чейн платформа волшебных монет, работающая как на Ethereum (ERC20), так и на Internet Computer (ICRC1).

## Философия проекта

Идея проекта вдохновлена фильмом "Заплати вперед" (Pay It Forward) - о том, как один человек может изменить мир, делая добро другим.

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 [Смотреть трейлер "Заплати вперед" / Pay It Forward](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## Основные возможности

### Эмиссия LCKY Coin
В волшебном горшочке происходит чародейская эмиссия LCKY Coin 🌟. Заветная цифра - 108 миллиардов монет, но как истинное волшебство, мы никогда не достигнем этой границы. С каждым четырехлетием, магия нашего горшочка уменьшается, уменьшая скорость эмиссии вдвое ⏳.

**Формула эмиссии:**
- Начальная скорость: 50 LCKY в блок
- Халвинг: каждые 4 года (приблизительно каждые 2,102,400 блоков на Ethereum)
- Максимальная эмиссия: 108,000,000,000 LCKY (никогда не будет достигнута)

### Волшебное Распределение
Главный чародей распределяет LCKY Coin через систему клеймов, раздавая монеты людям и поддерживая благие дела 🏰🤝.

### Donation Fire (Сжигание с посланием)
Монеты LCKY можно пожертвовать, сжигая их и оставляя вечное послание в блокчейне 💬.

### Donation Ether (Пополнение резерва)
Отправьте ETH или ICP в волшебный горшочек, и он щедро отблагодарит вас LCKY монетами 🌈.

**Курс обмена:** Динамический, зависит от резерва контракта

### SOS функция (Экстренный выход)
В случае крайней необходимости, можно активировать SOS, получив ETH/ICP пропорционально вашему балансу LCKY 🚨.

**Формула:** `ваш_ETH = (ваш_LCKY / total_supply) * контракт_баланс`

## Архитектура проекта

```
LCKY/v2/
├── ethereum/               # ERC20 реализация
│   ├── contracts/          # Solidity контракты
│   ├── scripts/            # Deploy скрипты
│   └── test/               # Тесты
│
├── icp/                    # ICP реализация
│   ├── src/
│   │   ├── lcky_backend/   # ICRC1 токен
│   │   ├── payment_backend/# Платежный backend
│   │   └── lcky_frontend/  # Frontend
│   └── dfx.json
│
├── frontend/               # Общий frontend
│   └── src/
│
└── docs/                   # Документация
```

## Поддерживаемые платформы

### Ethereum (EVM Compatible)
- Ethereum Mainnet
- Polygon
- BSC
- Arbitrum
- Optimism

### Internet Computer
- ICP Mainnet
- ICP Local Replica

## Токеномика

- **Total Supply:** 108,000,000,000 LCKY (теоретический максимум)
- **Initial Emission:** 50 LCKY/block
- **Halving:** Every 4 years
- **Decimals:** 18
- **Distribution:**
  - 70% - Mining/Claiming
  - 15% - Team & Development
  - 10% - Community & Marketing
  - 5% - Reserve

## Быстрый старт

### Ethereum

```bash
cd ethereum
npm install
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.ts --network localhost
```

### ICP

```bash
cd icp
dfx start --background
dfx deploy
```

## Основные функции контракта

### ERC20 (Ethereum)

```solidity
// Claim монет (эмиссия)
function claim() external returns (uint256)

// Donation с сжиганием
function donateWithMessage(uint256 amount, string memory message) external

// Donation ETH для получения LCKY
function donateETH() external payable returns (uint256)

// SOS - экстренный вывод ETH
function emergencySOS() external returns (uint256)

// Получить текущую награду за блок
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1 (ICP)

```motoko
// Claim монет
public shared(msg) func claim() : async Result<Nat, Text>

// Donation с сообщением
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// Donation ICP
public shared(msg) func donateICP() : async Result<Nat, Text>

// SOS функция
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## Интеграция с DEX

Токены LCKY могут свободно торговаться на децентрализованных биржах:
- **Ethereum:** Uniswap, Sushiswap
- **ICP:** ICPSwap, Sonic

## Безопасность

- ✅ Audited by [TBD]
- ✅ OpenZeppelin библиотеки
- ✅ Reentrancy защита
- ✅ Rate limiting
- ✅ Emergency pause

## Лицензия

MIT License

## Контакты

- Website: https://lckycoin.com
- Twitter: @lckycoin
- Discord: https://discord.gg/lckycoin
- Email: info@lckycoin.com

---

**Важно:** Это волшебные монеты, но инвестируйте ответственно! 🪄✨

