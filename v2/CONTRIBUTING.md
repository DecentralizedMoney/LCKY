# Contributing to LCKY v2

Спасибо за интерес к проекту LCKY! 🪄

## Как внести вклад

### Отчеты об ошибках

Если вы нашли баг:

1. Проверьте, нет ли уже открытого issue
2. Создайте новый issue с:
   - Описанием проблемы
   - Шагами для воспроизведения
   - Ожидаемым поведением
   - Фактическим поведением
   - Скриншотами (если применимо)
   - Версией контракта/канистера

### Предложения улучшений

1. Откройте issue с тегом `enhancement`
2. Опишите предлагаемую функцию
3. Объясните, почему это будет полезно
4. Приложите примеры использования

### Pull Requests

1. **Fork** репозиторий
2. Создайте **feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit** изменения (`git commit -m 'Add amazing feature'`)
4. **Push** в branch (`git push origin feature/amazing-feature`)
5. Откройте **Pull Request**

#### Требования к PR

- [ ] Код следует style guide
- [ ] Все тесты проходят
- [ ] Добавлены новые тесты (если нужно)
- [ ] Документация обновлена
- [ ] Коммиты имеют понятные сообщения

## Структура проекта

```
LCKY/v2/
├── ethereum/           # Ethereum implementation
│   ├── contracts/      # Solidity contracts
│   ├── test/          # Tests
│   └── scripts/       # Deploy scripts
├── icp/               # ICP implementation
│   └── src/
│       ├── lcky_backend/      # Token canister
│       ├── payment_backend/   # Payment canister
│       └── lcky_frontend/     # Frontend
└── docs/              # Documentation
```

## Стандарты кодирования

### Solidity

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ContractName
 * @dev Description
 */
contract ContractName {
    // State variables
    uint256 public variable;
    
    // Events
    event SomethingHappened(address indexed user, uint256 amount);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    // Functions
    /**
     * @dev Function description
     * @param param Parameter description
     * @return Description of return value
     */
    function doSomething(uint256 param) external returns (uint256) {
        // Implementation
    }
}
```

### Motoko

```motoko
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor LCKYBackend {
    
    // Types
    type UserInfo = {
        balance : Nat;
        mined : Nat;
    };
    
    // State
    private var totalSupply : Nat = 0;
    
    // Public functions
    public query func getBalance(user: Principal) : async Nat {
        // Implementation
    };
    
    public shared(msg) func transfer(to: Principal, amount: Nat) : async Result.Result<(), Text> {
        // Implementation
    };
}
```

### JavaScript

```javascript
/**
 * Function description
 * @param {string} param - Parameter description
 * @returns {Promise<number>} Description of return value
 */
async function doSomething(param) {
    // Implementation
}
```

## Тестирование

### Ethereum Tests

```bash
cd ethereum
npm test
```

Покрытие кода:
```bash
npm run coverage
```

### ICP Tests

```bash
cd icp
# Add tests and run with:
dfx test
```

## Безопасность

### Отчеты о уязвимостях

**НЕ создавайте публичные issue для уязвимостей!**

Отправьте отчет на: security@lckycoin.com

Включите:
- Описание уязвимости
- Шаги для воспроизведения
- Потенциальное влияние
- Предложения по исправлению

## Процесс разработки

1. **Обсуждение**: Обсудите большие изменения в issue
2. **Разработка**: Работайте в feature branch
3. **Тестирование**: Добавьте и запустите тесты
4. **Код-ревью**: Создайте PR для ревью
5. **Слияние**: После одобрения код сливается в main

## Релизы

Следуем [Semantic Versioning](https://semver.org/):

- **MAJOR**: Несовместимые изменения API
- **MINOR**: Новая функциональность (обратно совместимая)
- **PATCH**: Исправления багов

## Код поведения

- Будьте уважительны
- Конструктивная критика
- Фокус на проблеме, а не личности
- Помогайте новичкам

## Вопросы?

- Discord: [link]
- Telegram: [link]
- Email: dev@lckycoin.com

## Лицензия

Внося вклад, вы соглашаетесь, что ваш код будет лицензирован под MIT License.

---

**Спасибо за вклад в LCKY! 🪄✨**

