
---
toc: Utilities / Snacks
summary: Give, store, and eat snacks with flavorful text.
---
# Snacks

Share tasty treats with a dash of flavor text. Snacks are stored per-character so you can save them for later or eat them right away.

## Commands

`snack <name>=<snack>` - Give someone a snack. Example: `snack Ari=klah`  
`snack <name1> <name2>=<snack>` - Give multiple people a snack.  
`eat/snack <snack>` - Eat a snack from your inventory.  
`store/snack <snack>` - Store a snack for yourself (configurable).  
`snacks` - Show your current snack inventory.

## Configuration

Edit `game/config/snacks.yml` to add new snack types and flavor text. Each snack may define `aliases`, `give`, `eat`, and `store` text.

