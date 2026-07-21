# MMO Skill Stations Pack

A standalone Hytale content pack for the [MMO Skill Tree](https://www.curseforge.com/hytale/mods/mmo-skill-tree) mod (1.5.2+). It ships the **interactive work stations** content: the **Sawmill**, a diegetic third-person work loop (press use, a looping sawing emote plays, logs turn into planks one cycle at a time) that grants passive Woodcutting + Crafting XP, scaled by the held hatchet's power, with luck-tiered bonus loot.

The mod jar ships only the station *engine* (`StationService`, the `StationAsset` codec, the camera/hold/luck/swing machinery, the registered `mmo_station_use` interaction type). It ships no station content, so this pack is what makes any station appear. It is a **hard dependency** on the mod, declared in `manifest.json`.

## What is inside

| Path | What it is |
|------|------------|
| `Server/MMOSkillTree/Stations/Sawmill.json` | The Sawmill's `StationAsset` (work loop, recipe, luck tiers, tool gate, camera, animation, presentation) |
| `Server/Item/Items/MMO_Station_Sawmill.json` | The placeable Sawmill block (reuses the vanilla Lumbermill bench model/texture/icon) |
| `Server/Item/RootInteractions/MMO_Station_Sawmill_Use.json` | The block's interaction, `{ "Type": "mmo_station_use", "Station": "sawmill" }` |
| `Server/Drops/MMO_Station_Sawmill_T1/T2/T3.json` | The three luck-tier bonus-loot drop tables |
| `Server/Emote/MMO_Emote_Saw.json` | The looping sawing work emote |
| `Server/Languages/en-US/items.lang` | Block name, description, and interaction hint |
| `Server/Languages/en-US/avatarCustomization.lang` | The emote's display name (Hytale's own `avatarCustomization` namespace) |

All 9 shipped locales carry the same two `.lang` files translated. The mod's own `station.sawmill.name`/`station.sawmill.desc` display keys (used by the `StationAsset.Identity` name/desc, resolved through the mod's own localization convention) live in the JAR, not here.

## Build

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
```

Produces `MMOSkillStationsPack.zip` (forward-slash entries plus explicit directory entries, which the bundled `.lang` files need). The script is cross-platform (`pwsh ./build.ps1` works on macOS/Linux). To have it also copy the zip into your Hytale `Mods/` folder, set `HYTALE_MODS_DIR` once to that folder (or pass `-ModsDir <path>`); without it the script just builds the zip. Start a server with both the mod jar and this zip in `Mods/`, then craft and place a Sawmill block in the world and press use.

## Author your own station

A station is pure JSON, no plugin code:

1. **The station itself**: `Server/MMOSkillTree/Stations/<Name>.json`, decoded through the mod's `StationAsset` Pattern A codec (the filename, lowercased, is the station id). See `Sawmill.json` for the full shape (`Identity`/`Work`/`Recipe`/`Hold`/`Tool`/`Camera`/`Animation`/`Luck`/`Presentation`).
2. **The block**: `Server/Item/Items/MMO_Station_<Name>.json`, a native Hytale block item whose `BlockType.Interactions.Use` points at a `RootInteraction`.
3. **The interaction**: `Server/Item/RootInteractions/MMO_Station_<Name>_Use.json`, a 3-line stub: `{ "Interactions": [ { "Type": "mmo_station_use", "Station": "<id>" } ] }`. The `mmo_station_use` type is Java-registered once in the jar; a single interaction type backs any number of stations, one block + one JSON per station.

Add item name/description/hint keys to your pack's `Server/Languages/<locale>/items.lang`, and give `Identity.NameKey`/`DescKey` a `station.<id>.name`/`.desc` convention key in your `mmoskilltree.lang` (or reuse the mod's convention keys directly, as `Sawmill.json` does).

## Requires

MMO Skill Tree 1.5.2 or newer.
