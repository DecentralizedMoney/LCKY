# LCKY v2 - Quick Start Guide 🪄

## 🚀 Быстрый старт за 5 минут

### Выберите платформу

#### 📘 Ethereum (Локальный запуск)

```bash
# 1. Перейдите в директорию Ethereum
cd LCKY/v2/ethereum

# 2. Установите зависимости
npm install

# 3. Запустите локальную ноду (в отдельном терминале)
npx hardhat node

# 4. Разверните контракты
npx hardhat run scripts/deploy.ts --network localhost

# 5. Откройте фронтенд в браузере
# (подключите MetaMask к localhost:8545)
```

**Готово!** 🎉 Контракты развернуты и готовы к использованию.

---

#### ♾️ ICP (Локальный запуск)

```bash
# 1. Перейдите в директорию ICP
cd LCKY/v2/icp

# 2. Запустите DFX (в фоновом режиме)
dfx start --background --clean

# 3. Разверните канистеры
dfx deploy

# 4. Получите URL фронтенда
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "Frontend: http://${FRONTEND_ID}.localhost:4943"

# 5. Откройте URL в браузере
```

**Готово!** 🎉 Канистеры развернуты и работают.

---

## 📝 Первые шаги

### Для Ethereum

#### Добавить токен в MetaMask

1. Откройте MetaMask
2. Нажмите "Import tokens"
3. Вставьте адрес контракта (из вывода deploy)
4. Token symbol: `LCKY`
5. Decimals: `18`

#### Получить первые токены

```javascript
// В Hardhat Console:
const LCKY = await ethers.getContractAt("LCKYToken", "CONTRACT_ADDRESS");
await LCKY.claimInitial();

// Проверить баланс:
const balance = await LCKY.balanceOf("YOUR_ADDRESS");
console.log("Balance:", ethers.formatEther(balance), "LCKY");
```

### Для ICP

#### Получить первые токены

```bash
# Claim initial tokens
dfx canister call lcky_backend claimInitial '()'

# Проверить баланс
dfx canister call lcky_backend balanceOf "(principal \"$(dfx identity get-principal)\")"
```

---

## 🧪 Тестирование

### Ethereum Tests

```bash
cd ethereum
npm test

# С покрытием кода:
npm run coverage
```

### ICP Tests

```bash
cd icp
# Добавьте тесты и запустите
```

---

## 📚 Основные команды

### Ethereum (Hardhat)

```bash
# Компиляция
npx hardhat compile

# Тесты
npx hardhat test

# Развертывание
npx hardhat run scripts/deploy.ts --network <network>

# Верификация
npx hardhat verify --network <network> <address>

# Консоль
npx hardhat console --network localhost
```

### ICP (DFX)

```bash
# Сборка
dfx build

# Развертывание
dfx deploy

# Обновление канистера
dfx canister install lcky_backend --mode upgrade

# Вызов функции
dfx canister call lcky_backend <function> '(<args>)'

# Логи
dfx canister logs lcky_backend

# Остановка
dfx stop
```

---

## 🎯 Основные функции

### Claim токены

**Ethereum:**
```javascript
await lcky.claimInitial(); // Одноразово 1000 LCKY
await lcky.claim();        // Ежедневная награда
```

**ICP:**
```bash
dfx canister call lcky_backend claimInitial '()'
dfx canister call lcky_backend claim '()'
```

### Donation с сообщением

**Ethereum:**
```javascript
const amount = ethers.parseEther("100");
await lcky.donateWithMessage(amount, "Для храма!");
```

**ICP:**
```bash
dfx canister call lcky_backend donateWithMessage '(100_000_000_000_000_000_000, "Для храма!")'
```

### Donate ETH/ICP за LCKY

**Ethereum:**
```javascript
await lcky.donateETH({ value: ethers.parseEther("1") });
```

**ICP:**
```bash
dfx canister call lcky_backend donateICP --with-cycles 100000000
```

### Emergency SOS

**Ethereum:**
```javascript
await lcky.emergencySOS();
```

**ICP:**
```bash
dfx canister call lcky_backend emergencySOS '()'
```

---

## 🔍 Примеры использования

### JavaScript (Web3)

```javascript
import Web3 from 'web3';

const web3 = new Web3(window.ethereum);
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

// Получить статистику
const stats = await contract.methods.getStats().call();
console.log('Total Supply:', web3.utils.fromWei(stats[0], 'ether'));

// Claim токены
const accounts = await web3.eth.getAccounts();
await contract.methods.claim().send({ from: accounts[0] });
```

### JavaScript (ICP Agent)

```javascript
import { Actor, HttpAgent } from '@dfinity/agent';

const agent = new HttpAgent({ host: 'http://localhost:4943' });
const actor = Actor.createActor(idlFactory, {
    agent,
    canisterId: 'CANISTER_ID',
});

// Получить статистику
const stats = await actor.getStats();
console.log('Total Supply:', stats.totalSupply);

// Claim токены
const result = await actor.claim();
console.log('Result:', result);
```

---

## 🐛 Устранение неполадок

### Ethereum

**Проблема:** MetaMask не подключается к localhost
```bash
# Проверьте, что Hardhat node запущен:
npx hardhat node

# В MetaMask:
# Networks → Add Network → RPC URL: http://127.0.0.1:8545
# Chain ID: 1337
```

**Проблема:** "Nonce too high"
```
# В MetaMask: Settings → Advanced → Reset Account
```

### ICP

**Проблема:** dfx не запускается
```bash
# Очистить и перезапустить:
dfx stop
rm -rf .dfx
dfx start --background --clean
```

**Проблема:** "Cannot find canister"
```bash
# Пересоздать и развернуть:
dfx canister create --all
dfx build
dfx deploy
```

---

## 📖 Дополнительная документация

- [README.md](README.md) - Общая информация
- [ARCHITECTURE.md](ARCHITECTURE.md) - Архитектура системы
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Детальное руководство по развертыванию
- [API_REFERENCE.md](API_REFERENCE.md) - Справочник по API
- [CONTRIBUTING.md](CONTRIBUTING.md) - Как внести вклад
- [SECURITY.md](SECURITY.md) - Безопасность

---

## 💡 Полезные ссылки

### Ethereum
- [Hardhat Documentation](https://hardhat.org/docs)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)
- [Ethers.js](https://docs.ethers.org)

### ICP
- [Internet Computer Documentation](https://internetcomputer.org/docs)
- [Motoko Documentation](https://internetcomputer.org/docs/current/motoko/main/getting-started/motoko-introduction)
- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install)

---

## 🆘 Помощь

Нужна помощь? Свяжитесь с нами:

- **Discord:** [Server invite]
- **Telegram:** [@lckycoin]
- **Email:** support@lckycoin.com
- **GitHub Issues:** [Open issue](https://github.com/...)

---

## 🎉 Готово!

Поздравляем! Вы готовы работать с LCKY v2. 

**Следующие шаги:**
1. Изучите [примеры](examples/)
2. Прочитайте [документацию](docs/)
3. Присоединяйтесь к [сообществу](https://discord.gg/...)

**Happy coding! 🪄✨**

