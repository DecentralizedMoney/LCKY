# LCKY v2 - मल्टी-चेन लकी कॉइन प्लेटफॉर्म 🪄🍯

**भाषाएँ:** [English](README_en.md) | [中文](README_cn.md) | [ไทย](README_th.md) | **हिंदी** | [עברית](README_he.md) | [Русский](README.md)

## परियोजना के बारे में

LCKY v2 एक क्रॉस-चेन जादुई सिक्का प्लेटफॉर्म है जो Ethereum (ERC20) और Internet Computer (ICRC1) दोनों पर काम करता है।

## परियोजना का दर्शन

यह परियोजना "Pay It Forward" फिल्म से प्रेरित है - यह बताती है कि कैसे एक व्यक्ति दूसरों के लिए अच्छा करके दुनिया को बदल सकता है।

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 ["Pay It Forward" ट्रेलर देखें](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## मुख्य विशेषताएं

### LCKY कॉइन उत्सर्जन
जादुई बर्तन LCKY कॉइन का मंत्रमुग्ध करने वाला उत्सर्जन करता है 🌟। पसंदीदा संख्या 108 बिलियन सिक्के है, लेकिन असली जादू की तरह, हम कभी भी इस सीमा तक नहीं पहुंचेंगे। हर चार साल में, हमारे बर्तन का जादू कम हो जाता है, उत्सर्जन दर को आधा कर देता है ⏳।

**उत्सर्जन सूत्र:**
- प्रारंभिक दर: 50 LCKY प्रति ब्लॉक
- हाफिंग: हर 4 साल (Ethereum पर लगभग हर 2,102,400 ब्लॉक)
- अधिकतम उत्सर्जन: 108,000,000,000 LCKY (कभी नहीं पहुंचेगा)

### जादुई वितरण
मुख्य जादूगर दावा प्रणाली के माध्यम से LCKY कॉइन वितरित करता है, लोगों को सिक्के देता है और अच्छे कारणों का समर्थन करता है 🏰🤝।

### डोनेशन फायर (संदेश के साथ जलना)
LCKY सिक्कों को जलाकर और ब्लॉकचेन पर एक शाश्वत संदेश छोड़कर दान किया जा सकता है 💬।

### डोनेशन ईथर (रिजर्व पूर्ति)
जादुई बर्तन में ETH या ICP भेजें, और यह आपको उदारता से LCKY सिक्कों से पुरस्कृत करेगा 🌈।

**विनिमय दर:** गतिशील, अनुबंध रिजर्व पर निर्भर करता है

### SOS फंक्शन (आपातकालीन निकास)
अत्यधिक आवश्यकता की स्थिति में, आप SOS को सक्रिय कर सकते हैं, अपने LCKY बैलेंस के अनुपात में ETH/ICP प्राप्त कर सकते हैं 🚨।

**सूत्र:** `आपका_ETH = (आपका_LCKY / कुल_आपूर्ति) * अनुबंध_शेष`

## परियोजना वास्तुकला

```
LCKY/v2/
├── ethereum/               # ERC20 कार्यान्वयन
│   ├── contracts/          # Solidity अनुबंध
│   ├── scripts/            # तैनाती स्क्रिप्ट
│   └── test/               # परीक्षण
│
├── icp/                    # ICP कार्यान्वयन
│   ├── src/
│   │   ├── lcky_backend/   # ICRC1 टोकन
│   │   ├── payment_backend/# भुगतान बैकएंड
│   │   └── lcky_frontend/  # फ्रंटएंड
│   └── dfx.json
│
├── frontend/               # सामान्य फ्रंटएंड
│   └── src/
│
└── docs/                   # दस्तावेज़ीकरण
```

## समर्थित प्लेटफॉर्म

### Ethereum (EVM Compatible)
- Ethereum Mainnet
- Polygon
- BSC
- Arbitrum
- Optimism

### Internet Computer
- ICP Mainnet
- ICP Local Replica

## टोकनोमिक्स

- **कुल आपूर्ति:** 108,000,000,000 LCKY (सैद्धांतिक अधिकतम)
- **प्रारंभिक उत्सर्जन:** 50 LCKY/ब्लॉक
- **हाफिंग:** हर 4 साल
- **दशमलव:** 18
- **वितरण:**
  - 70% - माइनिंग/क्लेमिंग
  - 15% - टीम और विकास
  - 10% - समुदाय और मार्केटिंग
  - 5% - रिजर्व

## त्वरित शुरुआत

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

## मुख्य अनुबंध फंक्शन

### ERC20 (Ethereum)

```solidity
// सिक्के का दावा करें (उत्सर्जन)
function claim() external returns (uint256)

// जलने के साथ दान
function donateWithMessage(uint256 amount, string memory message) external

// LCKY प्राप्त करने के लिए ETH दान करें
function donateETH() external payable returns (uint256)

// SOS - आपातकालीन ETH निकासी
function emergencySOS() external returns (uint256)

// वर्तमान ब्लॉक पुरस्कार प्राप्त करें
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1 (ICP)

```motoko
// सिक्के का दावा करें
public shared(msg) func claim() : async Result<Nat, Text>

// संदेश के साथ दान
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// ICP दान करें
public shared(msg) func donateICP() : async Result<Nat, Text>

// SOS फंक्शन
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## DEX एकीकरण

LCKY टोकन विकेंद्रीकृत एक्सचेंजों पर स्वतंत्र रूप से कारोबार किया जा सकता है:
- **Ethereum:** Uniswap, Sushiswap
- **ICP:** ICPSwap, Sonic

## सुरक्षा

- ✅ [TBD] द्वारा ऑडिट किया गया
- ✅ OpenZeppelin लाइब्रेरी
- ✅ रीएंट्रेंसी सुरक्षा
- ✅ दर सीमा
- ✅ आपातकालीन रोक

## लाइसेंस

MIT License

## संपर्क

- वेबसाइट: https://lckycoin.com
- Twitter: @lckycoin
- Discord: https://discord.gg/lckycoin
- ईमेल: info@lckycoin.com

---

**महत्वपूर्ण:** ये जादुई सिक्के हैं, लेकिन जिम्मेदारी से निवेश करें! 🪄✨

