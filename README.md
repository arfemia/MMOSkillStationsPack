# MMO Skill Stations Pack

A standalone Hytale content pack that ships the **interactive work stations** content: the
**Sawmill**, a diegetic third-person work loop (press use, a looping sawing emote plays, logs turn
into planks one cycle at a time) that grants passive Woodcutting + Crafting XP, scaled by the held
hatchet's power.

The MMO progression layered on top comes in four parts:

- **Five find tiers**, scored on your Woodcutting and Crafting luck AND levels together (the top
  three additionally require Woodcutting 30). Every tier pays offcuts - fibre, bark, sap and
  sticks - and life essence joins from the second tier up, with concentrated essence at the top.
- **Two bonus-plank ladders**, one for Woodcutting level (at 25/50/75/100/125) and one for luck
  alone, so stacking luck is worth it at a bench that already rewards levels.
- **A luck-driven chase** for the sawmill's drop-only trophy tool, improving from 1 in 3000 to
  roughly 1 in 762 as you invest in Woodcutting luck.
- **A reward for wielding that trophy**, the **Sawmiller's Hatchet**: it carries an MMO stat
  payload while held (+10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck), and opens a
  tool-gated roll no other tool can, paying a double helping of offcuts plus the occasional
  Woodcutting XP boost token - its own luck bonus feeding the very roll it unlocks.

Also the **Anvil**, a two-action station that sharpens vanilla metal bars (Convert) or runs a
hammering ritual that rolls stats onto a placed weapon (Enhance), granting Smithing XP. The Anvil
and its Smithing/Cooking skills are held back from the shipped zip in this release and live under
`unreleased/` (see `unreleased/README.md`); the table below lists them for when they return.

The station **engine** (work loop, camera/hold/mount/swing machinery, session-scoped placed-input
custody, the multi-action step engine, the conditional-lootable `Bonus` layer, the registered
`rpg_station_use` interaction type) ships in the standalone
[RPG Stations](https://github.com/arfemia/hytale-rpg-stations) mod. This pack's Sawmill block
carries the SAME id (`RPG_Station_Sawmill`) as RPG Stations' own jar-default sawmill and overrides
it via pack load order, so its `StationAsset` (`Server/RpgStations/Stations/Sawmill.json`) becomes
the one that loads. The MMO Skill Tree bridge (a soft extension the MMO registers when it detects
RPG Stations, no hard coupling either direction) turns the work loop into skill XP, aggregated
luck (`mmoskilltree:station_luck`), mastery bonuses, and (for the Anvil's Enhance ritual) rolled
item stats via a registered `EnhanceStamper`. This pack is a **hard dependency** on BOTH mods,
declared in `manifest.json`; without RPG Stations installed, stations do not exist at all, and
without the MMO installed the Sawmill and Anvil still work (loot proc + tier ladder / the ritual's
own durability bonus) but grant no skill XP and roll no item stats.

## What is inside

| Path | What it is |
|------|------------|
| `Server/RpgStations/Stations/Sawmill.json` | The Sawmill's `StationAsset` (work loop, placed-input custody, `Bonus` proc + tier ladder, tool gate, camera, animation, presentation, a placed-log display entity) |
| `Server/RpgStations/Stations/Anvil.json` | The Anvil's `StationAsset`: an ordered `Actions` array of two fully self-contained actions, `Convert` (sharpen a vanilla metal bar) and `Enhance` (the weapon-enhancement ritual, a `Stamp`-step program) |
| `Server/RpgStations/RollPools/AnvilWeaponPool.json` | The weighted stat pool the Enhance ritual's `Stamp` step rolls from |
| `Server/Item/Items/RPG_Station_Sawmill.json` / `RPG_Station_Anvil.json` | The two placeable station blocks (reuse the vanilla Lumbermill / Anvil bench models; the Sawmill id is SHARED with RPG Stations' jar default) |
| `Server/Item/RootInteractions/RPG_Station_Sawmill_Use.json` / `RPG_Station_Anvil_Use.json` | Each block's interaction, `{ "Type": "rpg_station_use", "Station": "<id>" }` |
| `Server/Item/Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json` (x10) | The Anvil's Convert-action output, one per vanilla metal bar family, and the Enhance ritual's own `Stamp.Reagents` |
| `Server/Item/ResourceTypes/MMO_Sharpened_Bar.json` | The shared `ResourceType` family the ten Sharpened Bar items list themselves under (native pack-authorable asset, Icon-only) |
| `Server/Item/Items/RPG_Tool_Hatchet_Sawmiller.json` | The Sawmill's drop-only trophy hatchet (SHARED id with RPG Stations' own jar item, overridden wholesale) with this pack's MMO stat payload added: +10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck while held |
| `Server/Drops/MMO_Station_Sawmill_T1..T5.json` | The Sawmill's five find-tier drop tables. Each composes offcuts (fibre, bark, sap, sticks - pulled from RPG Stations' own shared byproduct list, more pulls as the tier rises) with its own life essence; T1 pays offcuts only, and T5 always pays |
| `Server/Drops/MMO_Station_Sawmill_Masterwork.json` | What the Sawmiller's Hatchet shakes loose: a double helping of offcuts plus a rare Woodcutting XP boost token |
| `Server/RpgStations/Lootables/SawmillLuckFinds.json` | The five find tiers, as two banded Rolls over one score: your Woodcutting and Crafting luck (the station's own skill counting full, the adjacent one half) plus your levels in both at a lighter weight. T1-T2 are ungated; T3-T5 additionally require Woodcutting 30 |
| `Server/RpgStations/Lootables/SawmillOutputLadders.json` | The two bonus-plank ladders: one paying for Woodcutting level (1/1/2/3/4 extra planks at level 25/50/75/100/125), one paying for luck alone (a quarter plank rising to two, so early luck arrives as a plank every few cycles rather than nothing) |
| `Server/RpgStations/Lootables/SawmillMasterworkBonus.json` | The tool-gated Roll only the Sawmiller's Hatchet can open, paying the Masterwork table above for wielding it; its chance rises with your luck, which that hatchet itself grants |
| `Server/RpgStations/Lootables/SawmillTrophy.json` | Replaces RPG Stations' own flat hatchet chase with a luck-scaled one: 1 in 3000 with no luck invested, improving to roughly 1 in 762 on a finished Woodcutting tree (base and Woodcutting luck only) |
| `Server/Emote/MMO_Emote_Saw.json` | The looping sawing work emote (native id, unrenamed) |
| `Server/Languages/<locale>/items.lang` | Block name/description/state-dependent interaction hints, and the sharpened-bar item names, keyed `RPG_Station_Sawmill.*` / `RPG_Station_Anvil.*` / `MMO_Sharpened_<Metal>_Bar.*` |
| `Server/Languages/<locale>/avatarCustomization.lang` | The emote's display name (Hytale's own `avatarCustomization` namespace) |
| `Server/Languages/<locale>/rpgstations.lang` | Per-key-additive overlay over RPG Stations' own file for pack-exclusive content (`station.anvil.name`/`.desc`; the Sawmill reuses RPG Stations' own shipped keys) |
| `Server/MMOSkillTree/CustomSkills/Smithing.json` | The SMITHING skill itself (round-7 D-3 migration: a Pattern A `CustomSkillAsset` - Name/Description/Icon/Category/InsertAfter/Triggers/RequiresFeatures - reproducing the former MMO jar built-in verbatim; existing player SMITHING XP keeps working) |
| `Server/Languages/<locale>/mmoskilltree.lang` | `skill.smithing` (the roster display name, moved verbatim from the MMO jar's own translations) + `skill.smithing.desc` (en-US only so far; the other 8 locales are filled in a follow-up lang leg) |

All 9 shipped locales are key-complete for the Anvil-era content (the sharpened-bar items, the
split empty/loaded hints, and the `rpgstations.lang` overlay) and carry `skill.smithing`. The
Sawmill's display name/desc (`Identity.NameKey`/`DescKey`) point at
`rpgstations.station.sawmill.name`/`.desc`, the keys RPG Stations itself ships (`rpgstations.lang`)
- this pack reuses them rather than duplicating the translation.

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
   Stations' `StationAsset` Pattern A codec (the filename, lowercased, is the station id). A
   station supplies only `Identity`/`Block`/`Requires`/`Flairs` plus an ORDERED `Actions` array -
   every self-contained action carries its own `Select`/`Tool`/`Recipe`/`Work`/`Custody`/`Bonus`/
   `ContributionScale`/`Worker` (grouping `Hold`/`Camera`/`Animation`/`Puppet`)/`Moments` (grouping
   `Cycle`/`Completion`), nothing is inherited from the station or from another action. See
   `Sawmill.json` for a single-action station (its one action, `Mill`), or `Anvil.json` for a
   multi-action station whose two actions, `Convert` and `Enhance`, each duplicate the same `Tool`/
   `Worker` groups inline rather than sharing a station-level default - see RPG Stations' own
   `CLAUDE.md` for the full authoring reference.
2. **The block**: `Server/Item/Items/<Id>.json`, a native Hytale block item whose
   `BlockType.Interactions.Use` points at a `RootInteraction`.
3. **The interaction**: `Server/Item/RootInteractions/<Id>_Use.json`, a 3-line stub:
   `{ "Interactions": [ { "Type": "rpg_station_use", "Station": "<id>" } ] }`. The
   `rpg_station_use` type is Java-registered once in the RPG Stations jar; a single interaction
   type backs any number of stations, one block + one JSON per station.
4. **Bonus (optional)**: on the action, author `Bonus.Rolls` (inline) or reference
   `Bonus.Lootables` (a `Server/RpgStations/Lootables/<Name>.json` `LootableAsset`) for conditional
   bonus loot - `Chance`/`Ladder`/`Grants`, independently composable. See `Sawmill.json`'s `Mill`
   action's `Bonus` block for the shape (a tool-quality ladder, plus this pack's own
   `mmoskilltree`-luck ladders layered on top via an `ExtensionAsset` when the MMO bridge is
   present).

Add item name/description/hint keys to your pack's `Server/Languages/<locale>/items.lang`, and
give `Identity.NameKey`/`DescKey` a key in your own pack-authored `Server/Languages/<locale>/
rpgstations.lang` (per-key-additive over RPG Stations' own file, same namespace) or reuse RPG
Stations' `rpgstations.station.<id>.name`/`.desc` convention keys directly, as this pack's
`Sawmill.json` does, when your content matches the shipped default.

## Requires

RPG Stations 1.0.0 or newer, and MMO Skill Tree 1.6.0 or newer (for the skill-XP + luck bridge).
