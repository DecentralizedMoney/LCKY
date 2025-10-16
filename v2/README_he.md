# LCKY v2 - פלטפורמת מטבעות מזל רב-שרשרת 🪄🍯

**שפות:** [English](README_en.md) | [中文](README_cn.md) | [ไทย](README_th.md) | [हिंदी](README_hi.md) | **עברית** | [Русский](README.md)

## אודות הפרויקט

LCKY v2 היא פלטפורמת מטבעות קסומה חוצת-שרשראות הפועלת הן על Ethereum (ERC20) והן על Internet Computer (ICRC1).

## פילוסופיית הפרויקט

הפרויקט השתאה מהסרט "Pay It Forward" - על איך אדם אחד יכול לשנות את העולם על ידי עשיית טוב לאחרים.

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 [צפו בטריילר "Pay It Forward"](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## תכונות עיקריות

### הנפקת מטבעות LCKY
הסיר הקסום מייצר הנפקה מרתקת של מטבעות LCKY 🌟. המספר היקר הוא 108 מיליארד מטבעות, אבל כמו קסם אמיתי, לעולם לא נגיע למגבלה הזו. כל ארבע שנים, הקסם של הסיר שלנו פוחת, מחצית את קצב ההנפקה ⏳.

**נוסחת ההנפקה:**
- קצב התחלתי: 50 LCKY לבלוק
- חציית תגמול: כל 4 שנים (בערך כל 2,102,400 בלוקים ב-Ethereum)
- הנפקה מקסימלית: 108,000,000,000 LCKY (לעולם לא תושג)

### הפצה קסומה
הקוסם הראשי מחלק מטבעות LCKY דרך מערכת תביעות, מחלק מטבעות לאנשים ותומך במטרות טובות 🏰🤝.

### Donation Fire (שריפה עם הודעה)
ניתן לתרום מטבעות LCKY על ידי שריפתם והשארת הודעה נצחית בבלוקצ'יין 💬.

### Donation Ether (מילוי רזרבה)
שלחו ETH או ICP לסיר הקסום, והוא יתגמל אתכם בנדיבות במטבעות LCKY 🌈.

**שער החליפין:** דינמי, תלוי ברזרבת החוזה

### פונקציית SOS (יציאת חירום)
במקרה של צורך קיצוני, ניתן להפעיל SOS, לקבל ETH/ICP פרופורציונלית ליתרת ה-LCKY שלכם 🚨.

**נוסחה:** `ה-ETH_שלך = (ה-LCKY_שלך / היצע_כולל) * יתרת_חוזה`

## ארכיטקטורת הפרויקט

```
LCKY/v2/
├── ethereum/               # יישום ERC20
│   ├── contracts/          # חוזי Solidity
│   ├── scripts/            # סקריפטי פריסה
│   └── test/               # בדיקות
│
├── icp/                    # יישום ICP
│   ├── src/
│   │   ├── lcky_backend/   # טוקן ICRC1
│   │   ├── payment_backend/# Backend תשלומים
│   │   └── lcky_frontend/  # Frontend
│   └── dfx.json
│
├── frontend/               # Frontend משותף
│   └── src/
│
└── docs/                   # תיעוד
```

## פלטפורמות נתמכות

### Ethereum (תואם EVM)
- Ethereum Mainnet
- Polygon
- BSC
- Arbitrum
- Optimism

### Internet Computer
- ICP Mainnet
- ICP Local Replica

## טוקנומיקה

- **היצע כולל:** 108,000,000,000 LCKY (מקסימום תיאורטי)
- **הנפקה התחלתית:** 50 LCKY/בלוק
- **חציית תגמול:** כל 4 שנים
- **עשרוניות:** 18
- **חלוקה:**
  - 70% - כרייה/תביעות
  - 15% - צוות ופיתוח
  - 10% - קהילה ושיווק
  - 5% - רזרבה

## התחלה מהירה

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

## פונקציות חוזה עיקריות

### ERC20 (Ethereum)

```solidity
// תבע מטבעות (הנפקה)
function claim() external returns (uint256)

// תרומה עם שריפה
function donateWithMessage(uint256 amount, string memory message) external

// תרום ETH כדי לקבל LCKY
function donateETH() external payable returns (uint256)

// SOS - משיכת ETH חירום
function emergencySOS() external returns (uint256)

// קבל תגמול בלוק נוכחי
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1 (ICP)

```motoko
// תבע מטבעות
public shared(msg) func claim() : async Result<Nat, Text>

// תרומה עם הודעה
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// תרום ICP
public shared(msg) func donateICP() : async Result<Nat, Text>

// פונקציית SOS
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## אינטגרציה עם DEX

ניתן לסחור בטוקני LCKY בחופשיות בבורסות מבוזרות:
- **Ethereum:** Uniswap, Sushiswap
- **ICP:** ICPSwap, Sonic

## אבטחה

- ✅ נבדק על ידי [TBD]
- ✅ ספריות OpenZeppelin
- ✅ הגנת Reentrancy
- ✅ הגבלת קצב
- ✅ השהיית חירום

## רישיון

MIT License

## יצירת קשר

- אתר: https://lckycoin.com
- Twitter: @lckycoin
- Discord: https://discord.gg/lckycoin
- דוא"ל: info@lckycoin.com

---

**חשוב:** אלה מטבעות קסומים, אבל השקיעו באחריות! 🪄✨

