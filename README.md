[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![AUR](https://img.shields.io/badge/volts-v0.1.3-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://aur.archlinux.org/packages/volts)

<div align="center">
  
# volts
A Simple program to show battery status and info, written in bash
</div>

---

**Volts:** is a script to show battery info and percentage of your laptop/notebook, written in pure bash, without dependencies.

### Features:
**All Details** - Print percentage, AC, charge cycles, battery health, etc.

**Ascii** - volts have a functional ascii image of your battery, with 5 different styles.

**Compact mode** - with the flag `-c`, you can print a compact style of your choosen battery style.

## Installation

**From Source**

```bash
git clone https://github.com/xmlzitos154/volts.git
cd volts
chmod +x install.sh
sudo ./install.sh

```

**From source with only one command**

```
git clone https://github.com/xmlzitos154/volts.git && cd volts && chmod +x install.sh && sudo ./install.sh

```

**From AUR**

```bash
# With yay
yay -S volts

# With paru
paru -S volts

```

---

## Usage

| Command                     | Alias   | Description                                                                                                 |
| --------------------------- | ------- | ----------------------------------------------------------------------------------------------------------- |
| `--style`                   | `-s`    | Change Battery style (8 Available: 4 Compact styles)                                                        |
| `--help`                    | `-h`    | Show how to use the program                                                                                 |
| `--version`                 | `-v`    | Display program version                                                                                     |
| `--compact`                 | `-c`    | Show a compact version of the battery style                                                                 |
| `--watch`                   | `-w`    | Show real-time battery information                                                                          |


---

Developed with <3 by xml.dev

version: **0.1.3** (beta)

**tip:** if you like the project, leave a star for support the creator.
