# unreleased/ - content held back from the 0.1.0 pack

**Nothing here is deleted or broken.** This is finished content held back from the 0.1.0 release,
which ships the Sawmill only. The directory mirrors the pack's own `Server/` layout exactly, so
restoring is a move, not a rewrite.

`build.ps1` zips every top-level directory except those in its `$ExtraExcludeDirs` list, and
`'unreleased'` is in that list, so nothing here reaches the built pack zip. **If you rename this
directory, update that list in `build.ps1` too** or the held-back content ships. Every file is
still tracked in git and was moved with `git mv`, so `git log --follow` still works on each one.

## Restore everything

```powershell
cd 'D:\dev\business\hyMMO\content-packs\skill-stations-pack'
.\unreleased\restore.ps1              # moves it all back into Server/
.\unreleased\restore.ps1 -WhatIf      # preview without touching anything
.\unreleased\restore.ps1 -Only Anvil  # restore one group
```

Groups: `Anvil`, `Cooking`, `All` (default).

## What is held back

| Group | Files | Note |
| --- | --- | --- |
| `Anvil` | `RpgStations/Stations/Anvil.json`, `ZiggfreedCommon/RollPools/AnvilWeaponPool.json`, `Item/Items/RPG_Station_Anvil.json`, `Item/RootInteractions/RPG_Station_Anvil_Use.json`, `Emote/MMO_Emote_Hammer.json`, `MMOSkillTree/CustomSkills/Smithing.json`, `Item/ResourceTypes/MMO_Sharpened_Bar.json`, `Item/Items/Ingredient/MMO_Sharpened_*_Bar.json` (10) | The Sharpened bar items and their ResourceType are referenced by `Anvil.json` and nothing else, so they travel with it. Smithing exists only to receive anvil progression. |
| `Cooking` | `RpgStations/Extensions/CookingProgression.json`, `MMOSkillTree/CustomSkills/Cooking.json` | `CookingProgression` targets the `cookingfire` station, which is held back on the RPG Stations jar side. Restoring this without restoring that leaves the extension pointing at a station that does not exist. |

## What deliberately did NOT move

- **Every `.lang` key stayed in `Server/Languages/`,** all 9 locales, including the anvil, hammer
  emote, Sharpened bar, Smithing, and Cooking keys. An unreferenced lang key is invisible at
  runtime, so holding them back would only have risked losing translation work.
- Everything the Sawmill needs: `Drops/MMO_Station_Sawmill_T1..T5.json`, `Emote/MMO_Emote_Saw.json`,
  `Item/Items/RPG_Station_Sawmill.json`, `Item/RootInteractions/RPG_Station_Sawmill_Use.json`,
  `RpgStations/Extensions/SawmillProgression.json`, and its four Lootables
  (`SawmillLuckFinds`, `SawmillOutputLadders`, `SawmillMasterworkBonus`, `SawmillTrophy`).
  `SawmillProgression` contributes only to `WOODCUTTING` and `CRAFTING`, both built-in MMO skills,
  so it never depended on the held-back Smithing or Cooking skills.

## Companion change in the RPG Stations jar

`additional-mods/rpg-stations/unreleased/` holds the CookingFire, CuttingBoard, and MountSpike
stations plus the buildable CookingPit family for the same release. Restore the two together when
the anvil and cooking come back: the jar's `CookingFire` is what this pack's `CookingProgression`
targets.

## Version note

The pack was renumbered `1.0.0 -> 0.1.0` alongside the mod, and its manifest dependency floor moved
to `"Ziggfreed:RpgStations": ">=0.1.0"`. Restoring this content means bumping the pack version again
and raising that floor to whatever RPG Stations release carries the cooking fire back.
