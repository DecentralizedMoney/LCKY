# LCKY v2 - 多链幸运币平台 🪄🍯

**语言:** [English](README_en.md) | **中文** | [ไทย](README_th.md) | [हिंदी](README_hi.md) | [עברית](README_he.md) | [Русский](README.md)

## 关于项目

LCKY v2 是一个跨链魔法币平台，同时在以太坊（ERC20）和互联网计算机（ICRC1）上运行。

## 项目理念

该项目的灵感来自电影《让爱传出去》（Pay It Forward）——讲述一个人如何通过向他人行善来改变世界。

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 [观看《让爱传出去》预告片](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## 主要功能

### LCKY 币发行
魔法罐产生迷人的 LCKY 币发行 🌟。珍贵的数字是 1080 亿枚硬币，但就像真正的魔法一样，我们永远不会达到这个极限。每四年，我们罐子的魔力就会减弱，使发行速度减半 ⏳。

**发行公式：**
- 初始速率：每区块 50 LCKY
- 减半：每 4 年（以太坊上大约每 2,102,400 个区块）
- 最大发行量：108,000,000,000 LCKY（永远不会达到）

### 魔法分配
首席巫师通过领取系统分配 LCKY 币，向人们发放硬币并支持善举 🏰🤝。

### 捐赠火焰（带消息的销毁）
LCKY 币可以通过销毁并在区块链上留下永恒的消息来捐赠 💬。

### 捐赠以太（储备补充）
将 ETH 或 ICP 发送到魔法罐，它会慷慨地用 LCKY 币奖励你 🌈。

**兑换率：** 动态的，取决于合约储备

### SOS 功能（紧急退出）
在极端必要的情况下，您可以激活 SOS，获得与您的 LCKY 余额成比例的 ETH/ICP 🚨。

**公式：** `您的_ETH = (您的_LCKY / 总供应量) * 合约余额`

## 项目架构

```
LCKY/v2/
├── ethereum/               # ERC20 实现
│   ├── contracts/          # Solidity 合约
│   ├── scripts/            # 部署脚本
│   └── test/               # 测试
│
├── icp/                    # ICP 实现
│   ├── src/
│   │   ├── lcky_backend/   # ICRC1 代币
│   │   ├── payment_backend/# 支付后端
│   │   └── lcky_frontend/  # 前端
│   └── dfx.json
│
├── frontend/               # 通用前端
│   └── src/
│
└── docs/                   # 文档
```

## 支持的平台

### 以太坊（EVM 兼容）
- 以太坊主网
- Polygon
- BSC
- Arbitrum
- Optimism

### 互联网计算机
- ICP 主网
- ICP 本地副本

## 代币经济学

- **总供应量：** 108,000,000,000 LCKY（理论最大值）
- **初始发行：** 50 LCKY/区块
- **减半：** 每 4 年
- **小数位数：** 18
- **分配：**
  - 70% - 挖矿/领取
  - 15% - 团队与开发
  - 10% - 社区与营销
  - 5% - 储备

## 快速开始

### 以太坊

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

## 主要合约函数

### ERC20（以太坊）

```solidity
// 领取币（发行）
function claim() external returns (uint256)

// 带销毁的捐赠
function donateWithMessage(uint256 amount, string memory message) external

// 捐赠 ETH 以获得 LCKY
function donateETH() external payable returns (uint256)

// SOS - 紧急 ETH 提取
function emergencySOS() external returns (uint256)

// 获取当前区块奖励
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1（ICP）

```motoko
// 领取币
public shared(msg) func claim() : async Result<Nat, Text>

// 带消息的捐赠
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// 捐赠 ICP
public shared(msg) func donateICP() : async Result<Nat, Text>

// SOS 功能
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## DEX 集成

LCKY 代币可以在去中心化交易所自由交易：
- **以太坊：** Uniswap、Sushiswap
- **ICP：** ICPSwap、Sonic

## 安全性

- ✅ 由 [待定] 审计
- ✅ OpenZeppelin 库
- ✅ 重入保护
- ✅ 速率限制
- ✅ 紧急暂停

## 许可证

MIT 许可证

## 联系方式

- 网站：https://lckycoin.com
- Twitter：@lckycoin
- Discord：https://discord.gg/lckycoin
- 电子邮件：info@lckycoin.com

---

**重要提示：** 这些是魔法币，但请负责任地投资！🪄✨

