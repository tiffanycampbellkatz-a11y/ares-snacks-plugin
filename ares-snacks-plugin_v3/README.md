
# Ares Snacks Plugin

A drop-in AresMUSH plugin for flavorful snacks: give them, store them, and eat them.

## Install

1. Copy this folder to your game plugins directory OR install via GitHub like any standard Ares plugin.
2. Add `"snacks"` to your `game/plugins.yml` list.
3. `load all` then `reload` in-game.
4. Edit `game/config/snacks.yml` to customize snacks and flavor text.

## Commands

- `snack <name>=<snack>` — give a snack to someone (multiple names supported).  
- `eat/snack <snack>` — eat a snack from your inventory.  
- `store/snack <snack>` — store a snack for yourself (if enabled).  
- `snacks` — view your snack inventory.

## Notes

- Inventory is stored on the character record as a hash (`snack_inventory`).  
- Snacks are totally customizable via config, including aliases and flavor text.


## Web Portal Integration

This plugin ships a `ProfileSnacks` component and auto-includes it via a `profile-extras` template hook used by the standard Ares web portal. If your portal is customized and does not have that hook, drop the component wherever you like:

```hbs
<ProfileSnacks @char={{this.model.char}} />
```

Buttons to **Eat** are shown only on your own profile.
