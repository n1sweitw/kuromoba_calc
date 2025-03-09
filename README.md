# Kuromoba Calc

## 概要 (Overview)

**Kuromoba Calc** は、ゲーム内の **覚醒突破 (Awakened Enhancement, AE)** をシミュレートする CLI ツールです。
最大突破レベルや試行回数を指定し、結果の統計を出力します。本ツールでは、**2シグマ (σ) を用いて、期待値ではなく必要になるリソース量を計算** し、より実際のプレイヤー体験に即したリソース見積もりを提供します。

---

## 使い方 (Usage)

### インストール (Installation)

```sh
swift build -c release
```

### 実行 (Run)

#### 基本的な使い方 (Basic Usage)

```sh
swift run kuromoba_calc ae --max-level 9 --trials 2000
```

#### シンプルな実行 (Simple Run)

```sh
swift run kuromoba_calc ae
```

(デフォルトの設定が適用されます: `maxLevel=9, trials=1000`)

#### オプション (Options)

```sh
swift run kuromoba_calc ae --help
```

```
USAGE: kuromoba_calc ae [--max-level <maxLevel>] [--trials <trials>]

OPTIONS:
  -m, --max-level <maxLevel>    最大覚醒突破レベルを指定 (デフォルト: 9)
  -t, --trials <trials>         シミュレーションの回数を指定 (デフォルト: 1000)
  -h, --help                    ヘルプ情報を表示
```

---

## 関数 (Functions)

| 名前         | 説明                            |
| ---------- | ----------------------------- |
| `maxLevel` | 最大覚醒突破レベルを指定 (デフォルト: 9)       |
| `trials`   | シミュレーションを実行する回数 (デフォルト: 1000) |

---

## Overview (English)

**Kuromoba Calc** is a CLI tool that simulates **Awakened Enhancement (AE)** in games.
Specify the maximum enhancement level and the number of trials to calculate the statistical results. This tool uses **2-sigma (σ) to calculate the required resource amount instead of just using the expected value**, ensuring a more realistic estimation of resource needs.

---

## Usage

### Installation

```sh
swift build -c release
```

### Run

#### Basic Usage

```sh
swift run kuromoba_calc ae --max-level 9 --trials 2000
```

#### Simple Run

```sh
swift run kuromoba_calc ae
```

(Default settings applied: `maxLevel=9, trials=1000`)

#### Options

```sh
swift run kuromoba_calc ae --help
```

```
USAGE: kuromoba_calc ae [--max-level <maxLevel>] [--trials <trials>]

OPTIONS:
  -m, --max-level <maxLevel>    Specify the maximum awakened enhancement level. (Default: 9)
  -t, --trials <trials>         Specify the number of trials for the simulation. (Default: 1000)
  -h, --help                    Show help information.
```

---

## Functions

| Name       | Description                                                    |
| ---------- | -------------------------------------------------------------- |
| `maxLevel` | Specifies the maximum awakened enhancement level. (Default: 9) |
| `trials`   | Number of times to run the simulation. (Default: 1000)         |

---

## License

This project is licensed under the MIT License.

