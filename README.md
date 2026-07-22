# MMO Skill Stations Pack

A standalone Hytale content pack that ships the **interactive work stations** content: the
**Sawmill**, a diegetic third-person work loop (press use, a looping sawing emote plays, logs turn
into planks one cycle at a time) that grants passive Woodcutting + Crafting XP, scaled by the held
hatchet's power, with luck-tiered bonus loot.

The station **engine** (work loop, camera/hold/swing machinery, the conditional-lootable `Loot`
layer, the registered `rpg_station_use` interaction type) ships in the standalone
[RPG Stations](https://github.com/arfemia/hytale-rpg-stations) mod. This pack's Sawmill block
carries the SAME id (`RPG_Station_Sawmill`) as RPG Stations' own jar-default sawmill and overrides
it via pack load order, so its `StationAsset` (`Server/RpgStations/Stations/Sawmill.json`) becomes
the one that loads. The MMO Skill Tree bridge (a soft extension the MMO registers when it detects
RPG Stations, no hard coupling either direction) turns the work loop into skill XP, aggregated
luck (`mmoskilltree:station_luck`), and mastery bonuses. This pack is a **hard dependency** on
BOTH mods, declared in `manifest.json`; without RPG Stations installed, stations do not exist at
all, and without the MMO installed the Sawmill still works (loot proc + tier ladder) but grants no
skill XP.

## What is inside

| Path | What it is |
|------|------------|
| `Server/RpgStations/Stations/Sawmill.json` | The Sawmill's `StationAsset` (work loop, recipe, `Loot` proc + tier ladder, tool gate, camera, animation, presentation) |
| `Server/Item/Items/RPG_Station_Sawmill.json` | The placeable Sawmill block (reuses the vanilla Lumbermill bench model/texture/icon; SHARED id with RPG Stations' jar default) |
| `Server/Item/RootInteractions/RPG_Station_Sawmill_Use.json` | The block's interaction, `{ "Type": "rpg_station_use", "Station": "sawmill" }` |
| `Server/Drops/MMO_Station_Sawmill_T1/T2/T3.json` | The three luck-tier bonus-loot drop tables (native ids, unrenamed - no id collision with RPG Stations' own drop tables) |
| `Server/Emote/MMO_Emote_Saw.json` | The looping sawing work emote (native id, unrenamed) |
| `Server/Languages/<locale>/items.lang` | Block name, description, and interaction hint, keyed `RPG_Station_Sawmill.*` |
| `Server/Languages/<locale>/avatarCustomization.lang` | The emote's display name (Hytale's own `avatarCustomization` namespace) |

All 9 shipped locales carry the same two `.lang` files translated. The Sawmill's display name/desc
(`Identity.NameKey`/`DescKey`) point at `rpgstations.station.sawmill.name`/`.desc`, the keys RPG
Stations itself ships (`rpgstations.lang`) - this pack reuses them rather than duplicating the
translation.

## Build

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
```

Produces `MMOSkillStationsPack.zip` (forward-slash entries plus explicit directory entries, which
the bundled `.lang` files need). The script is cross-platform (`pwsh ./build.ps1` works on
macOS/Linux). To have it also copy the zip into your Hytale `Mods/` folder, set `HYTALE_MODS_DIR`
once to that folder (or pass `-ModsDir <path>`); without it the script just builds the zip. Start a
server with the RPG Stations mod jar, the MMO Skill Tree mod jar, and this zip all in `Mods/`, then
craft and place a Sawmill block in the world and press use.

## Author your own station

A station is pure JSON, no plugin code:

1. **The station itself**: `Server/RpgStations/Stations/<Name>.json`, decoded through RPG
   Stations' `StationAsset` Pattern A codec (the filename, lowercased, is the station id). See
   `Sawmill.json` for the full shape (`Identity`/`Work`/`Recipe`/`Hold`/`Tool`/`Camera`/
   `Animation`/`Loot`/`Presentation`).
2. **The block**: `Server/Item/Items/<Id>.json`, a native Hytale block item whose
   `BlockType.Interactions.Use` points at a `RootInteraction`.
3. **The interaction**: `Server/Item/RootInteractions/<Id>_Use.json`, a 3-line stub:
   `{ "Interactions": [ { "Type": "rpg_station_use", "Station": "<id>" } ] }`. The
   `rpg_station_use` type is Java-registered once in the RPG Stations jar; a single interaction
   type backs any number of stations, one block + one JSON per station.
4. **Loot (optional)**: author `Loot.Rolls` (inline) or reference `Loot.Tables` (a
   `Server/RpgStations/Lootables/<Name>.json` `LootableAsset`) for conditional bonus loot -
   `Chance`/`Ladder`/`Grants`, independently composable. See `Sawmill.json`'s `Loot` block for the
   parity shape (a proc roll + a tier ladder over `mmoskilltree:station_luck`, when the MMO bridge
   is present).

Add item name/description/hint keys to your pack's `Server/Languages/<locale>/items.lang`, and
give `Identity.NameKey`/`DescKey` a key in your own pack-authored `Server/Languages/<locale>/
rpgstations.lang` (per-key-additive over RPG Stations' own file, same namespace) or reuse RPG
Stations' `rpgstations.station.<id>.name`/`.desc` convention keys directly, as this pack's
`Sawmill.json` does, when your content matches the shipped default.

## Requires

RPG Stations 1.0.0 or newer, and MMO Skill Tree 1.6.0 or newer (for the skill-XP + luck bridge).
