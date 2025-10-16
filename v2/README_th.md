# LCKY v2 - แพลตฟอร์มเหรียญโชคดีข้ามสายโซ่ 🪄🍯

**ภาษา:** [English](README_en.md) | [中文](README_cn.md) | **ไทย** | [हिंदी](README_hi.md) | [עברית](README_he.md) | [Русский](README.md)

## เกี่ยวกับโครงการ

LCKY v2 เป็นแพลตฟอร์มเหรียญมหัศจรรย์ข้ามสายโซ่ที่ทำงานทั้งบน Ethereum (ERC20) และ Internet Computer (ICRC1)

## ปรัชญาของโครงการ

โครงการนี้ได้รับแรงบันดาลใจจากภาพยนตร์ "Pay It Forward" - เกี่ยวกับว่าคนๆ หนึ่งสามารถเปลี่ยนโลกได้อย่างไรโดยการทำดีกับผู้อื่น

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 [รับชม Trailer "Pay It Forward"](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## คุณสมบัติหลัก

### การออกเหรียญ LCKY
หม้อมหัศจรรย์สร้างการออกเหรียญ LCKY ที่น่าหลงใหล 🌟 ตัวเลขที่มีค่าคือ 108 พันล้านเหรียญ แต่เหมือนกับเวทมนตร์ที่แท้จริง เราจะไม่มีวันถึงขอบเขตนี้ ทุกสี่ปี เวทมนตร์ของหม้อของเราลดลง ทำให้อัตราการออกเหรียญลดลงครึ่งหนึ่ง ⏳

**สูตรการออกเหรียญ:**
- อัตราเริ่มต้น: 50 LCKY ต่อบล็อก
- การลดครึ่ง: ทุก 4 ปี (ประมาณทุก 2,102,400 บล็อกบน Ethereum)
- การออกเหรียญสูงสุด: 108,000,000,000 LCKY (จะไม่มีวันถึง)

### การแจกจ่ายแบบมหัศจรรย์
พ่อมดหัวหน้าแจกจ่าย LCKY Coin ผ่านระบบการเคลม โดยแจกเหรียญให้ผู้คนและสนับสนุนกิจการที่ดี 🏰🤝

### Donation Fire (การเผาด้วยข้อความ)
เหรียญ LCKY สามารถบริจาคได้โดยการเผาและทิ้งข้อความนิรันดร์ไว้บนบล็อกเชน 💬

### Donation Ether (การเติมสำรอง)
ส่ง ETH หรือ ICP ไปยังหม้อมหัศจรรย์ และมันจะให้รางวัลคุณด้วยเหรียญ LCKY อย่างใจกว้าง 🌈

**อัตราแลกเปลี่ยน:** แบบไดนามิก ขึ้นอยู่กับสำรองของสัญญา

### ฟังก์ชัน SOS (ทางออกฉุกเฉิน)
ในกรณีจำเป็นอย่างยิ่ง คุณสามารถเปิดใช้งาน SOS เพื่อรับ ETH/ICP ตามสัดส่วนของยอดคงเหลือ LCKY ของคุณ 🚨

**สูตร:** `ETH ของคุณ = (LCKY ของคุณ / อุปทานทั้งหมด) * ยอดคงเหลือของสัญญา`

## สถาปัตยกรรมโครงการ

```
LCKY/v2/
├── ethereum/               # การดำเนินการ ERC20
│   ├── contracts/          # สัญญา Solidity
│   ├── scripts/            # สคริปต์การปรับใช้
│   └── test/               # การทดสอบ
│
├── icp/                    # การดำเนินการ ICP
│   ├── src/
│   │   ├── lcky_backend/   # โทเค็น ICRC1
│   │   ├── payment_backend/# แบ็กเอนด์การชำระเงิน
│   │   └── lcky_frontend/  # ฟรอนต์เอนด์
│   └── dfx.json
│
├── frontend/               # ฟรอนต์เอนด์ทั่วไป
│   └── src/
│
└── docs/                   # เอกสาร
```

## แพลตฟอร์มที่รองรับ

### Ethereum (EVM Compatible)
- Ethereum Mainnet
- Polygon
- BSC
- Arbitrum
- Optimism

### Internet Computer
- ICP Mainnet
- ICP Local Replica

## เศรษฐศาสตร์โทเค็น

- **อุปทานทั้งหมด:** 108,000,000,000 LCKY (สูงสุดตามทฤษฎี)
- **การออกเหรียญเริ่มต้น:** 50 LCKY/บล็อก
- **การลดครึ่ง:** ทุก 4 ปี
- **ทศนิยม:** 18
- **การกระจาย:**
  - 70% - การขุด/การเคลม
  - 15% - ทีมและการพัฒนา
  - 10% - ชุมชนและการตลาด
  - 5% - สำรอง

## เริ่มต้นอย่างรวดเร็ว

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

## ฟังก์ชันสัญญาหลัก

### ERC20 (Ethereum)

```solidity
// เคลมเหรียญ (การออกเหรียญ)
function claim() external returns (uint256)

// การบริจาคพร้อมการเผา
function donateWithMessage(uint256 amount, string memory message) external

// บริจาค ETH เพื่อรับ LCKY
function donateETH() external payable returns (uint256)

// SOS - การถอน ETH ฉุกเฉิน
function emergencySOS() external returns (uint256)

// รับรางวัลบล็อกปัจจุบัน
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1 (ICP)

```motoko
// เคลมเหรียญ
public shared(msg) func claim() : async Result<Nat, Text>

// การบริจาคพร้อมข้อความ
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// บริจาค ICP
public shared(msg) func donateICP() : async Result<Nat, Text>

// ฟังก์ชัน SOS
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## การผสานรวม DEX

โทเค็น LCKY สามารถซื้อขายได้อย่างอิสระบนตลาดแลกเปลี่ยนแบบกระจายอำนาจ:
- **Ethereum:** Uniswap, Sushiswap
- **ICP:** ICPSwap, Sonic

## ความปลอดภัย

- ✅ ตรวจสอบโดย [TBD]
- ✅ ไลบรารี OpenZeppelin
- ✅ การป้องกัน Reentrancy
- ✅ การจำกัดอัตรา
- ✅ การหยุดฉุกเฉิน

## ใบอนุญาต

MIT License

## ติดต่อ

- เว็บไซต์: https://lckycoin.com
- Twitter: @lckycoin
- Discord: https://discord.gg/lckycoin
- อีเมล: info@lckycoin.com

---

**สำคัญ:** นี่คือเหรียญมหัศจรรย์ แต่กรุณาลงทุนอย่างมีความรับผิดชอบ! 🪄✨

