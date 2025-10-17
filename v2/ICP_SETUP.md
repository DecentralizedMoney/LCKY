# 🔧 LCKY v2 - ICP Setup Guide

## ⚠️ DFX Installation Required

Для развертывания LCKY на Internet Computer необходимо установить DFX SDK вручную.

---

## 📥 Установка DFX SDK

### Способ 1: Интерактивная установка (Рекомендуется)

Откройте терминал и выполните:

```bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
```

Следуйте инструкциям на экране:
- Нажмите `y` для подтверждения
- DFX будет установлен в `~/Library/Application Support/org.dfinity.dfx/bin`
- PATH будет обновлен автоматически

### Способ 2: Установка из GitHub Release

```bash
# Скачайте последний release
VERSION=0.16.1  # или последняя версия
curl -LO "https://github.com/dfinity/sdk/releases/download/${VERSION}/dfx-${VERSION}-aarch64-apple-darwin.tar.gz"

# Распакуйте
tar -xzf "dfx-${VERSION}-aarch64-apple-darwin.tar.gz"

# Переместите в PATH
sudo mv dfx /usr/local/bin/

# Проверьте установку
dfx --version
```

### Способ 3: Homebrew (если доступен)

```bash
brew install dfinity/tap/dfx
```

---

## ✅ Проверка установки

После установки проверьте:

```bash
dfx --version
```

Ожидаемый вывод:
```
dfx 0.16.1
```

---

## 🚀 Развертывание LCKY на ICP

После успешной установки DFX:

### 1. Перейдите в директорию ICP

```bash
cd /Users/anton/proj/web3.nativemind.net/LCKY/v2/icp
```

### 2. Запустите локальную реплику

```bash
dfx start --background --clean
```

### 3. Разверните канистеры

#### Автоматический deploy (рекомендуется):

```bash
./deploy.sh
```

#### Или вручную:

```bash
# Создайте канистеры
dfx canister create --all

# Соберите код
dfx build

# Разверните ICRC1 Ledger
dfx deploy icrc1_ledger_canister --argument '(record {
  token_name = "Lucky Coin";
  token_symbol = "LCKY";
  minting_account = record {
    owner = principal "'$(dfx identity get-principal)'";
  };
  initial_balances = vec {};
  transfer_fee = 10_000;
  metadata = vec {};
  archive_options = record {
    trigger_threshold = 2000;
    num_blocks_to_archive = 1000;
    controller_id = principal "'$(dfx identity get-principal)'";
  };
})'

# Разверните LCKY Backend
dfx deploy lcky_backend

# Разверните Payment Backend
dfx deploy payment_backend

# Разверните Frontend
dfx deploy lcky_frontend
```

### 4. Протестируйте развертывание

```bash
./test_canister.sh
```

### 5. Откройте Frontend

```bash
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "Frontend URL: http://${FRONTEND_ID}.localhost:4943"
open "http://${FRONTEND_ID}.localhost:4943"
```

---

## 🧪 Базовые команды DFX

### Управление репликой

```bash
# Запустить
dfx start --background

# Остановить
dfx stop

# Статус
dfx ping
```

### Работа с канистерами

```bash
# Список канистеров
dfx canister ls

# ID канистера
dfx canister id lcky_backend

# Статус канистера
dfx canister status lcky_backend

# Вызов функции
dfx canister call lcky_backend getStats '()'
```

### Identity

```bash
# Текущая identity
dfx identity whoami

# Получить principal
dfx identity get-principal

# Создать новую identity
dfx identity new alice
```

---

## 📊 Текущий статус

### ✅ Готово к развертыванию

**Код ICP:**
- ✅ `lcky_backend/main.mo` - 444 строки
- ✅ `payment_backend/main.mo` - 226 строк
- ✅ `lcky_frontend/index.html` - Frontend готов
- ✅ `dfx.json` - Конфигурация готова
- ✅ `deploy.sh` - Deploy скрипт готов
- ✅ `test_canister.sh` - Тестовый скрипт готов

**Что будет развернуто:**

1. **lcky_backend** - Основной токен канистер
   - ICRC-1 подобная реализация
   - Mining с халвингом
   - Donation механизмы
   - Emergency SOS

2. **payment_backend** - Платежный процессор
   - ICP payment обработка
   - Exchange rate расчет
   - История транзакций

3. **lcky_frontend** - Web интерфейс
   - Универсальный UI для Ethereum и ICP
   - Network switching
   - Real-time статистика

---

## 🌐 Развертывание на ICP Mainnet

### Подготовка

1. **Получите Cycles**
   - Минимум: 10T cycles (~$13 USD)
   - Faucet: https://faucet.dfinity.org/
   - Или купите через NNS dApp

2. **Создайте cycles wallet**

```bash
dfx identity --network ic get-wallet
```

3. **Проверьте баланс**

```bash
dfx wallet --network ic balance
```

### Deploy на mainnet

```bash
# Разверните все канистеры
dfx deploy --network ic --with-cycles 10000000000000

# Получите Canister IDs
dfx canister --network ic id lcky_backend
dfx canister --network ic id payment_backend
dfx canister --network ic id lcky_frontend
```

### Frontend URL

После развертывания на mainnet, frontend будет доступен по адресу:

```
https://<CANISTER_ID>.icp0.io
```

или

```
https://<CANISTER_ID>.raw.icp0.io
```

---

## 💰 Стоимость развертывания

### Локальная реплика
- **Бесплатно** - работает на вашем компьютере

### ICP Mainnet
- **Создание канистера**: ~100B cycles (~$0.13) за канистер
- **Deployment**: ~1-5B cycles (~$0.001-0.007)
- **Хранилище**: ~1B cycles/GB/месяц (~$0.001/GB)
- **Общая стоимость**: ~500B cycles (~$0.65) для всех канистеров

---

## 🐛 Troubleshooting

### DFX не найден после установки

```bash
# Добавьте в PATH (для zsh)
echo 'export PATH="$HOME/Library/Application Support/org.dfinity.dfx/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Для bash
echo 'export PATH="$HOME/Library/Application Support/org.dfinity.dfx/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

### Replica не запускается

```bash
# Очистите и перезапустите
dfx stop
rm -rf .dfx
dfx start --background --clean
```

### Out of cycles

```bash
# Пополните cycles
dfx canister --network ic deposit-cycles 1000000000000 <CANISTER_ID>
```

### Build failed

```bash
# Установите mops (если нужно)
npm install -g ic-mops

# Очистите и пересоберите
dfx cache clean
dfx build
```

---

## 📚 Полезные ресурсы

### Официальная документация
- **DFX SDK**: https://internetcomputer.org/docs/current/developer-docs/setup/install/
- **Motoko**: https://internetcomputer.org/docs/current/motoko/main/getting-started/motoko-introduction
- **ICRC Standards**: https://github.com/dfinity/ICRC

### Инструменты
- **Candid UI**: http://localhost:4943/?canisterId=<canister-id>
- **NNS dApp**: https://nns.ic0.app/
- **ICP Dashboard**: https://dashboard.internetcomputer.org/

### Сообщество
- **Forum**: https://forum.dfinity.org/
- **Discord**: https://discord.com/invite/cA7y6ezyE2

---

## ✅ Checklist для развертывания

### Локальное развертывание
- [ ] DFX SDK установлен
- [ ] `dfx --version` работает
- [ ] Запустили `dfx start --background`
- [ ] Выполнили `dfx deploy`
- [ ] Протестировали с `./test_canister.sh`
- [ ] Открыли frontend в браузере

### Mainnet развертывание
- [ ] Cycles wallet создан
- [ ] Достаточно cycles (>10T)
- [ ] Код протестирован локально
- [ ] Развернули с `dfx deploy --network ic`
- [ ] Сохранили Canister IDs
- [ ] Настроили controllers
- [ ] Проверили frontend URL
- [ ] Настроили мониторинг cycles

---

## 🎯 Что дальше?

После успешной установки DFX:

1. **Разверните локально** - следуйте инструкциям выше
2. **Протестируйте** - используйте `./test_canister.sh`
3. **Изучите код** - смотрите `src/lcky_backend/main.mo`
4. **Прочитайте API** - см. `API_REFERENCE.md`
5. **Deploy на mainnet** - когда будете готовы

---

## 📞 Помощь

Проблемы с установкой или развертыванием?

1. Проверьте [официальную документацию](https://internetcomputer.org/docs/)
2. Спросите на [форуме DFINITY](https://forum.dfinity.org/)
3. Откройте issue на GitHub
4. Email: dev@lckycoin.com

---

<div align="center">

**🪄 ICP код готов - установите DFX и начинайте! ✨**

[Назад к главной](START_HERE.md) • [Ethereum Deploy](TESTNET_DEPLOYMENT.md) • [Статус](DEPLOYMENT_STATUS.md)

</div>

