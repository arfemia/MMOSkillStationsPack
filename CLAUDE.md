# CLAUDE.md - MMOSkillStationsPack

A standalone Hytale content pack shipping all **interactive work station** content: currently the
**Sawmill** (a diegetic third-person work loop station, see `.claude/research/raw/
rpg-stations-unified-design-2026-07-21.md` in the hyMMO monorepo). The station **engine**
(`StationService`, `StationCatalog`, `StationHoldController`, the `StationAsset`/`LootableAsset`
Pattern A codecs, the registered `rpg_station_use` interaction type, `StationValidator`, the
conditional-lootable `Loot`/`Roll` layer) ships in the standalone **RPG Stations** mod
(`additional-mods/rpg-stations`, package `com.ziggfreed.rpgstations`), not the MMO Skill Tree jar.
This pack has NO content without RPG Stations installed. The **MMO Skill Tree** mod is a SECOND
hard dependency: it registers a soft bridge (native events + typed registries, no coupling in the
other direction) that turns the work loop into skill XP, aggregated luck
(`mmoskilltree:station_luck`), and mastery bonuses - without it the Sawmill still runs (loot proc +
tier ladder) but grants no skill XP. Both dependencies are declared in `manifest.json`.

## Layout

```
skill-stations-pack/
├── manifest.json                                        Hytale plugin manifest (hard-deps Ziggfreed:RpgStations + Ziggfreed:MMOSkillTree)
├── build.ps1                                             zips with forward-slash entries, copies to Mods
└── Server/
    ├── Item/
    │   ├── Items/RPG_Station_Sawmill.json                the Sawmill block (reuses the vanilla Lumbermill bench model); SHARED id with RPG Stations' own jar default, overrides it via pack load order
    │   └── RootInteractions/RPG_Station_Sawmill_Use.json object form: {"Type":"rpg_station_use","Station":"sawmill"}
    ├── Drops/MMO_Station_Sawmill_T1/T2/T3.json           native ItemDropList luck-tier bonus loot (referenced by Sawmill.json's Loot.Rolls[1].Ladder.Floors[*].Grants.DropList); native ids, unrenamed - no collision with RPG Stations' own drop tables
    ├── Emote/MMO_Emote_Saw.json                          the looping sawing work emote (native id, unrenamed; server-authored EmoteAsset)
    ├── Languages/<bcp47>/
    │   ├── items.lang                                    RPG_Station_Sawmill.name/.description/.hint (native namespace)
    │   └── avatarCustomization.lang                       emotes.MMO_Emote_Saw.name (Hytale's own avatarCustomization namespace)
    └── RpgStations/
        └── Stations/Sawmill.json                         the StationAsset itself (Work/Recipe/Hold/Tool/Camera/Animation/Loot/Presentation), folds through RPG Stations' codec
```

`Server/Item/**`, `Server/Drops/**`, `Server/Emote/**`, and `Server/Languages/**` load via Hytale's
native asset pack mechanism (gated by `"IncludesAssetPack": true`), independent of RPG Stations'
own `Control` map (which only governs `Server/RpgStations/**`). `Server/RpgStations/Stations/*.json`
folds through RPG Stations' `StationAsset` codec (`AssetStoreRegistrar`); a station id here
OVERRIDES a same-id RPG Stations jar default (`defaults < pack` fold), which is exactly how the
Sawmill's engine-owned XP/luck-free jar default becomes the MMO-bridged, luck-tiered one this pack
ships.

## History (rename, RPG Stations extraction phase 1 leg 6)

Before the RPG Stations extraction this pack's Sawmill content folded through the MMO Skill Tree
jar's own `StationAsset` codec at `Server/MMOSkillTree/Stations/Sawmill.json`, its block was
`MMO_Station_Sawmill` using interaction type `mmo_station_use`, and loot rolled through a `Luck`
group (`Tiers` ladder + an engine-fixed tier-0 bonus-copy proc). The extraction moved the station
ENGINE to the standalone RPG Stations mod; per maintainer decision, this pack's block RENAMED to
the id RPG Stations' own jar ships (`RPG_Station_Sawmill`) so the pack's copy overrides the jar
default via load order (placed dev-world `MMO_Station_Sawmill` blocks from before this rename no
longer resolve - accepted, stations were pre-release). The interaction JSON and its `Type` renamed
to match (`RPG_Station_Sawmill_Use` / `rpg_station_use`); the `items.lang` keys renamed
`MMO_Station_Sawmill.*` -> `RPG_Station_Sawmill.*` (mechanical rename, translations preserved
across all 9 locales). `Sawmill.json` moved to the RPG Stations fold path, its `Luck` group
became a `Loot` block (one `Chance`+`Grants` Roll reproducing the tier-0 bonus-copy proc, one
`Ladder` Roll reproducing the 50/100/150 tier floors - both over the MMO bridge's
`mmoskilltree:station_luck` factor, the M3-critique-tightened `Roll` schema: `AddFactors` is an
array, every floor reward routes through its own `Grants`, no direct floor `DropList` leaf), its
`Identity` keys became the full `rpgstations.station.sawmill.name`/`.desc` ids (reusing RPG
Stations' own shipped keys), its `Presentation.Feedback` leaf was dropped (the MMO's
`FeedbackService` indirection died with the extraction), and its `Hold.EffectId` was repointed at
`RPG_Station_Hold` (RPG Stations' own shipped hold effect; the MMO's `MMO_Station_Hold` effect was
deleted in the extraction). The native `Server/Drops/*`, `Server/Emote/*`, and
`avatarCustomization.lang` assets are untouched (their ids never collided with RPG Stations' own).

## How it fits together

- **A station is one `StationAsset` JSON + its block + its interaction.**
  `Server/RpgStations/Stations/<Name>.json` (filename lowercased = the station id) is decoded
  through RPG Stations' Pattern A codec: `Identity` (name/desc/icon), `Work` (cycle cadence, XP
  grants forwarded as progression declarations, optional `Idle` practice mode), `Recipe` (authored
  `Conversions` or a native-crafting-derived `FromCrafting`), `Hold` (the movement-lock effect),
  `Tool` (the held-tool gate: `Tags`/`Gather`/`Ids` routes, plus optional `XpScale`), `Camera`
  (third-person pull, optional `FaceBlock`), `Animation` (the looping work emote plus an optional
  per-swing `Swing` cadence), `Loot` (`Tables` references and/or inline `Rolls` - the conditional
  proc/ladder/command-reward layer), `Presentation` (the per-cycle sound/particle/shake moment),
  `Requires` (permission + factor-condition gate), and `Flairs` (the achievement-unlock cosmetic
  override seam). See the RPG Stations mod's `station/CLAUDE.md` for the full engine-side
  behavior, and the MMO's `integration/stations/CLAUDE.md` for the bridge that supplies
  `mmoskilltree:station_luck`/`skill_level`/`combat_level` and turns cycle events into skill XP.
- **The Sawmill** derives its conversions from every native `WoodPlanks`-category crafting recipe
  (`Recipe.FromCrafting: {"Categories":["WoodPlanks"]}`) instead of hand-authoring all 11 wood
  families - zero hardcoded conversions, matching the native Builders bench yield (the station's
  value-add is passive XP + luck loot, not better yield). Its held-tool gate matches any hatchet
  via the native `Gather` (Woods, functional) and `Tags` (Family: Hatchet) routes; `XpScale`
  multiplies cycle XP by held-tool power (a better hatchet earns more). Its `Loot` block reproduces
  the pre-extraction luck behavior exactly: one `Chance` Roll (`AddFactors: [{"Factor":
  "mmoskilltree:station_luck"}]`, `CapPercent: 90`) grants a bonus output copy, and one `Ladder`
  Roll over the same factor rolls one of three native `ItemDropList`s
  (`MMO_Station_Sawmill_T1/T2/T3`) at the 50/100/150 floors.
- **In-world block.** The Sawmill block is a placeable furniture item reusing the vanilla
  `Bench_Lumbermill` model/texture/icon (no new art). Its `BlockType.Interactions.Use` names a
  `RootInteraction` whose single entry is the **object form**
  `{ "Type": "rpg_station_use", "Station": "sawmill" }`; RPG Stations' `StationUseInteraction`
  reads the `Station` field and toggles that station's work loop for the pressing player. This is
  why N stations in a pack is N blocks + N RootInteractions, but still one Java interaction type -
  the mod-side pattern mirrors the bounty pack's `mmo_bounty_board_open` object-form param exactly.
- **Native-namespace lang stays with the block/emote.** `items.lang` (block name/description/
  interaction hint) and `avatarCustomization.lang` (the emote's display name in Hytale's own
  client-owned namespace) ship here, per locale, because they belong to the native asset the pack
  authors, mirroring how the bounty pack ships `items.lang`/`npcs.lang` for its blocks/NPCs. RPG
  Stations' own `rpgstations.lang` convention keys (`station.sawmill.name`/`.desc`, all
  `ui.station.*` UI strings) stay in ITS jar - they are RPG Stations' generic per-station-id
  convention, not native-namespace content, and apply to any pack's stations equally. This pack's
  `Sawmill.json` reuses those shipped keys directly (`rpgstations.station.sawmill.name`/`.desc`)
  rather than duplicating the translation.

## Authoring a new station

1. **The `StationAsset`**: drop `Server/RpgStations/Stations/<Name>.json` (filename, lowercased,
   is the station id). Reuse `Sawmill.json` as the template; a variant station can
   `"Parent": "Sawmill"` and override only the leaves it needs (every leaf is `appendInherited`).
2. **The block**: copy `RPG_Station_Sawmill.json` -> `<Id>.json`, point `BlockType.Interactions.Use`
   at your new `RootInteraction` id, and give it its own model/texture/icon (or reuse a vanilla
   one, as the Sawmill does).
3. **The interaction**: `Server/Item/RootInteractions/<Id>_Use.json`:
   ```json
   { "Cooldown": { "Id": "BlockInteraction", "Cooldown": 0.278, "ClickBypass": true },
     "Interactions": [ { "Type": "rpg_station_use", "Station": "<id>" } ] }
   ```
   The `rpg_station_use` type is Java-registered once in the RPG Stations jar; every station reuses
   it.
4. **Lang**: add `<Id>.name`/`.description`/`.hint` to `Server/Languages/en-US/items.lang`
   (translate into the other locales you support), and give `Identity.NameKey`/`DescKey` on the
   `StationAsset` a `rpgstations.station.<id>.name`/`.desc` key - either author it in this pack's
   own `Server/Languages/<locale>/rpgstations.lang` (per-key-additive over RPG Stations' file), or
   reuse an RPG Stations convention default if one already fits.
5. **Loot (optional)**: author `Loot.Rolls` (inline, this pack's convention for a station-specific
   proc/ladder) or `Loot.Tables` (reference a `Server/RpgStations/Lootables/<Name>.json`
   `LootableAsset` for a reusable table). `Chance`/`Conditions`/`Ladder`/`Grants` are independently
   composable per `Roll` - see `Sawmill.json`'s `Loot` block, or RPG Stations' `asset/Roll.java`
   javadoc for the full schema (M3-critique-tightened: `AddFactors` is always an array, a `Ladder`
   floor's only reward path is its own `Grants`, never a sibling `DropList` leaf).

## Build & deploy

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
.\build.ps1 -ModsDir <path>  # build + install into an explicit folder
```

`build.ps1` is self-locating (`$PSScriptRoot`) and cross-platform (Windows PowerShell, or
`pwsh ./build.ps1` on macOS/Linux). It zips with forward-slash entries AND an explicit directory
entry for every ancestor path (Java's `ZipFileSystem.isDirectory()` returns false without them, so
Hytale's `I18nModule.loadMessagesFromPack` would skip the bundled `.lang` files). Never use
`Compress-Archive` (it writes backslash separators Hytale drops). To auto-install on build, set
`HYTALE_MODS_DIR` once to your Hytale `UserData/Mods` folder (or pass `-ModsDir`); without it the
script just builds the zip.

Start the server with the RPG Stations mod jar, the MMO Skill Tree mod jar, and this zip all in
`Mods/`. Confirm in the log: a Station asset layer fold line naming `sawmill` (RPG Stations),
plus the bridge's one-line "RPG Stations detected" INFO log (MMO), plus no `Asset validation
FAILED`. In-game: craft or `/give` the Sawmill block, place it, and press use.

## Conventions (shared with the bounty pack)

Filenames PascalCase (the asset key). Item + RootInteraction JSON keys start upper-case (Hytale
codec requirement). `StationAsset`/`Roll`/`LootableAsset` keys are PascalCase per RPG Stations'
Pattern A codec convention. See `bounty-contracts-pack/CLAUDE.md` for the shared native-asset-pack
conventions this pack follows.
