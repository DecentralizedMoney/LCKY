# 🧪 LCKY v2 - Testnet Deployment Complete Guide

## ✅ Текущий статус

### Ethereum (Localhost) - DEPLOYED ✅

**Развернуто**: 16 октября 2025
**Network**: Localhost (Chain ID: 1337)
**Status**: ✅ Working

**Deployed Contracts:**
```
Main Token:
  LCKY: 0x5FbDB2315678afecb367f032d93F642f64180aa3
  
Multi-Currency Factory:
  Factory: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
  
Stable Tokens:
  LCKYUSD: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
  LCKYRUB: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
  LCKYCNY: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  LCKYINR: 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
  LCKYTHB: 0x0165878A594ca255338adfa4d48449f69242Eb8F
  LCKYUAH: 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853
```

**Test Results:**
- ✅ All 25 tests passed
- ✅ Initial claim working
- ✅ All functions operational

---

## 🚀 Развертывание на Sepolia Testnet

### Подготовка

#### 1. Создайте тестовый кошелек

```bash
# Опция А: Используйте существующий кошелек MetaMask
# Экспортируйте private key (Settings → Security → Export Private Key)

# Опция Б: Создайте новый кошелек с Hardhat
npx hardhat account
```

⚠️ **ВАЖНО**: Никогда не используйте кошелек с реальными средствами для testnet!

#### 2. Получите Sepolia ETH

Бесплатные faucets:
- https://sepoliafaucet.com/
- https://www.infura.io/faucet/sepolia
- https://faucet.quicknode.com/ethereum/sepolia

Вам нужно ~0.5 ETH для развертывания.

#### 3. Получите API ключи

**Infura/Alchemy** (для RPC):
- Infura: https://infura.io/
- Alchemy: https://www.alchemy.com/

**Etherscan** (для верификации):
- https://etherscan.io/apis

#### 4. Настройте окружение

Создайте файл `.env` в директории `ethereum/`:

```bash
cd LCKY/v2/ethereum

cat > .env << 'EOF'
# RPC URL (замените на ваш ключ)
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY

# Private key (без 0x префикса или с ним - оба работают)
PRIVATE_KEY=your_private_key_here

# Etherscan API key для верификации
ETHERSCAN_API_KEY=your_etherscan_api_key

# Optional
REPORT_GAS=true
EOF
```

⚠️ **БЕЗОПАСНОСТЬ**:
- Файл `.env` в `.gitignore` - не комиттите его!
- Используйте ТОЛЬКО testnet кошельки
- Никогда не делитесь private key

### Развертывание

#### Шаг 1: Проверьте баланс

```bash
cd LCKY/v2/ethereum
npx hardhat run scripts/check-balance.ts --network sepolia
```

Должно показать:
```
Account: 0x...
Balance: 0.5 ETH (или больше)
Network: sepolia (Chain ID: 11155111)
```

#### Шаг 2: Разверните контракты

```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

**Ожидаемый вывод:**
```
🪄 Deploying LCKY Token System...

Deploying contracts with account: 0x...
Account balance: 500000000000000000

📦 Deploying LCKYToken...
✅ LCKYToken deployed to: 0x...

📦 Deploying LCKYMultiCurrency...
✅ LCKYMultiCurrency deployed to: 0x...

... (все токены) ...

🎉 Deployment Summary
```

**Сохраните все адреса контрактов!**

#### Шаг 3: Верифицируйте контракты

```bash
# Основной токен
npx hardhat verify --network sepolia <LCKY_TOKEN_ADDRESS>

# Мульти-валютный factory
npx hardhat verify --network sepolia <FACTORY_ADDRESS>

# Stable токены
npx hardhat verify --network sepolia <LCKYUSD_ADDRESS>
# ... и т.д. для остальных
```

После верификации контракты будут доступны на Etherscan:
https://sepolia.etherscan.io/address/<YOUR_CONTRACT_ADDRESS>

#### Шаг 4: Тестирование

```bash
# Установите адрес контракта
export CONTRACT_ADDRESS=<YOUR_LCKY_TOKEN_ADDRESS>

# Запустите интерактивный скрипт
npx hardhat run scripts/interact.ts --network sepolia
```

**Протестируйте:**
- ✅ Claim initial 1000 LCKY
- ✅ Donate ETH для получения LCKY
- ✅ Donate LCKY с сообщением
- ✅ Проверьте баланс
- ✅ View donation messages

### Автоматизированный deploy (рекомендуется)

```bash
cd LCKY/v2/ethereum
./deploy.sh

# Выберите:
# 2) Sepolia Testnet

# Скрипт автоматически:
# - Проверит баланс
# - Скомпилирует контракты
# - Запустит тесты
# - Развернет на Sepolia
# - Выдаст инструкции по верификации
```

---

## ♾️ Развертывание на ICP (Local/Testnet)

### Подготовка

#### 1. Установите DFX SDK

```bash
# macOS/Linux
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

# Проверьте установку
dfx --version
```

#### 2. Установите Mops (Motoko Package Manager)

```bash
npm install -g ic-mops
```

#### 3. Получите Cycles (для mainnet/testnet)

Для локального развертывания - не требуется.

Для mainnet/testnet:
- Получите через Cycles Faucet: https://faucet.dfinity.org/
- Или купите через NNS dApp

### Локальное развертывание

#### Шаг 1: Запустите локальную реплику

```bash
cd LCKY/v2/icp
dfx start --background --clean
```

#### Шаг 2: Разверните канистеры

```bash
dfx deploy
```

Или используйте автоматический скрипт:

```bash
./deploy.sh
```

**Ожидаемый вывод:**
```
🪄 LCKY - Internet Computer Deployment
=======================================
✅ dfx is installed
✅ dfx is running

📦 Building canisters...
🔨 Compiling Motoko code...
🚀 Deploying canisters...

Deploying ICRC1 Ledger...
Deploying LCKY Backend...
Deploying Payment Backend...
Deploying Frontend...

🎉 Deployment Complete!

📋 Canister IDs:
lcky_backend: xxxxx-xxxxx-xxxxx-xxxxx-cai
payment_backend: xxxxx-xxxxx-xxxxx-xxxxx-cai
lcky_frontend: xxxxx-xxxxx-xxxxx-xxxxx-cai

🌐 Frontend URL:
http://xxxxx-xxxxx-xxxxx-xxxxx-cai.localhost:4943
```

#### Шаг 3: Протестируйте

```bash
./test_canister.sh
```

**Скрипт автоматически проверит:**
- ✅ Token info (name, symbol, decimals)
- ✅ Statistics
- ✅ Claim initial tokens
- ✅ Balance check
- ✅ Donation с сообщением
- ✅ Payment backend
- ✅ All functions

#### Шаг 4: Откройте Frontend

```bash
# Получите URL
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "http://${FRONTEND_ID}.localhost:4943"

# Откройте в браузере
open "http://${FRONTEND_ID}.localhost:4943"
```

### Развертывание на ICP Mainnet

⚠️ **Требуется:** Cycles (минимум 10T cycles для всех канистеров)

#### Проверьте cycles wallet

```bash
dfx wallet --network ic balance
```

#### Разверните на mainnet

```bash
dfx deploy --network ic --with-cycles 10000000000000
```

**Или используйте скрипт:**

```bash
./deploy.sh
# (скрипт спросит о сети)
```

#### После развертывания

1. **Сохраните Canister IDs:**
```bash
dfx canister --network ic id lcky_backend
dfx canister --network ic id payment_backend
dfx canister --network ic id lcky_frontend
```

2. **Настройте controllers:**
```bash
# Добавьте дополнительные контроллеры для безопасности
dfx canister --network ic update-settings lcky_backend \
  --add-controller <PRINCIPAL_ID>
```

3. **Мониторинг cycles:**
```bash
# Проверяйте регулярно
dfx canister --network ic status lcky_backend

# Пополняйте при необходимости
dfx canister --network ic deposit-cycles 1000000000000 lcky_backend
```

4. **Frontend доступен по адресу:**
```
https://<CANISTER_ID>.icp0.io
```

или
```
https://<CANISTER_ID>.raw.icp0.io
```

---

## 📋 Post-Deployment Checklist

### Ethereum

- [ ] Контракты развернуты на Sepolia
- [ ] Все контракты верифицированы на Etherscan
- [ ] Протестированы все основные функции
- [ ] Адреса контрактов сохранены
- [ ] Frontend обновлен с новыми адресами
- [ ] Документация обновлена
- [ ] Ownership настроен (multisig recommended)
- [ ] Мониторинг настроен

### ICP

- [ ] Канистеры развернуты (local/mainnet)
- [ ] Все функции протестированы
- [ ] Canister IDs сохранены
- [ ] Controllers настроены
- [ ] Cycles мониторинг настроен
- [ ] Frontend доступен
- [ ] Backup кода создан
- [ ] Upgrade процедуры документированы

---

## 🔍 Проверка развертывания

### Ethereum

1. **Проверьте на Etherscan:**
```
https://sepolia.etherscan.io/address/<CONTRACT_ADDRESS>
```

2. **Подключите MetaMask:**
- Network: Sepolia Test Network
- Add Token: Вставьте адрес LCKY контракта

3. **Claim токены:**
```javascript
// В браузере с Web3
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);
await contract.methods.claimInitial().send({ from: YOUR_ADDRESS });
```

### ICP

1. **Проверьте canister:**
```bash
dfx canister --network ic info lcky_backend
```

2. **Тестовые вызовы:**
```bash
dfx canister --network ic call lcky_backend getStats '()'
dfx canister --network ic call lcky_backend claimInitial '()'
```

3. **Откройте frontend:**
```
https://<CANISTER_ID>.icp0.io
```

---

## 🐛 Troubleshooting

### Ethereum

**Проблема: Insufficient funds**
```bash
# Получите больше testnet ETH из faucet
# Проверьте баланс:
npx hardhat run scripts/check-balance.ts --network sepolia
```

**Проблема: Nonce too high**
```bash
# Сбросьте account в MetaMask:
# Settings → Advanced → Reset Account
```

**Проблема: Contract verification failed**
```bash
# Попробуйте снова с аргументами конструктора:
npx hardhat verify --network sepolia <ADDRESS> \
  --constructor-args arguments.js
```

### ICP

**Проблема: Out of cycles**
```bash
# Пополните cycles:
dfx canister --network ic deposit-cycles 1000000000000 <CANISTER_ID>
```

**Проблема: Canister not found**
```bash
# Убедитесь, что канистер развернут:
dfx canister --network ic id lcky_backend
```

**Проблема: Build failed**
```bash
# Очистите и пересоберите:
dfx stop
rm -rf .dfx
dfx start --background --clean
dfx deploy
```

---

## 💰 Costs Estimate

### Ethereum Sepolia (Testnet)
- **Deploy все контракты**: ~0.15-0.3 ETH (testnet)
- **Verification**: Бесплатно
- **Transactions**: ~0.001 ETH каждая

### ICP
- **Canister creation**: ~100B cycles (~$0.13)
- **Code deployment**: ~1-5B cycles (~$0.001-0.007)
- **Monthly storage**: ~1B cycles/GB (~$0.001/GB)
- **Total initial**: ~500B cycles (~$0.65)

---

## 📞 Support

Проблемы с развертыванием?

1. Проверьте логи: `npx hardhat node` (Ethereum) или `dfx logs` (ICP)
2. Изучите [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
3. Откройте issue на GitHub
4. Спросите в Discord: [link]
5. Email: dev@lckycoin.com

---

## 🎉 Next Steps

После успешного развертывания:

1. **Обновите документацию** с реальными адресами
2. **Announce** в сообществе
3. **Setup monitoring** для контрактов/канистеров
4. **Prepare for audit** если планируется mainnet
5. **Collect feedback** от тестировщиков

---

**Last Updated**: October 16, 2025
**Version**: 2.0.0
**Status**: Ethereum Localhost ✅ | ICP Pending ⏳

