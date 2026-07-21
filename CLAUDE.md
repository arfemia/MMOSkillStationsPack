# CLAUDE.md - MMOSkillStationsPack

A standalone Hytale content pack for the [MMOSkillTree mod](https://www.curseforge.com/hytale/mods/mmo-skill-tree) (1.5.2+). Ships all **interactive work station** content: currently the **Sawmill** (a diegetic third-person work loop station, see the mod's `.claude/plans/interactive-stations.md`). The mod jar ships only the station *engine* (`station/StationService`, `StationCatalog`, `StationHoldController`, the `StationAsset` Pattern A codec, the registered `mmo_station_use` interaction type, `StationValidator`) and no content, so this pack is what makes stations appear. It is a **hard dependency** on the mod (the block's interaction needs the jar-registered Java type), declared in `manifest.json`.

## Layout

```
skill-stations-pack/
├── manifest.json                                        Hytale plugin manifest (hard-deps Ziggfreed:MMOSkillTree)
├── build.ps1                                             zips with forward-slash entries, copies to Mods
└── Server/
    ├── Item/
    │   ├── Items/MMO_Station_Sawmill.json                the Sawmill block (reuses the vanilla Lumbermill bench model)
    │   └── RootInteractions/MMO_Station_Sawmill_Use.json object form: {"Type":"mmo_station_use","Station":"sawmill"}
    ├── Drops/MMO_Station_Sawmill_T1/T2/T3.json           native ItemDropList luck-tier bonus loot (StationAsset.Luck.Tiers)
    ├── Emote/MMO_Emote_Saw.json                          the looping sawing work emote (server-authored EmoteAsset)
    ├── Languages/<bcp47>/
    │   ├── items.lang                                    MMO_Station_Sawmill.name/.description/.hint (native namespace)
    │   └── avatarCustomization.lang                       emotes.MMO_Emote_Saw.name (Hytale's own avatarCustomization namespace)
    └── MMOSkillTree/
        └── Stations/Sawmill.json                         the StationAsset itself (Work/Recipe/Hold/Tool/Camera/Animation/Luck/Presentation)
```

`Server/Item/**`, `Server/Drops/**`, `Server/Emote/**`, and `Server/Languages/**` load via Hytale's native asset pack mechanism (gated by `"IncludesAssetPack": true`), independent of the MMOSkillTree `Control` map (which only governs `Server/MMOSkillTree/**`). `Server/MMOSkillTree/Stations/*.json` folds through the mod's own `StationAsset` codec (`AssetStoreRegistrar`); the pack is purely additive (add mode is the default - a station id here overrides a same-id jar default, but the jar ships none, so this pack is the whole catalog).

## How it fits together

- **A station is one `StationAsset` JSON + its block + its interaction.** `Server/MMOSkillTree/Stations/<Name>.json` (filename lowercased = the station id) is decoded through the mod's Pattern A codec: `Identity` (name/desc/icon), `Work` (cycle cadence, XP grants, optional `Idle` practice mode), `Recipe` (authored `Conversions` or a native-crafting-derived `FromCrafting`), `Hold` (the movement-lock effect), `Tool` (the held-tool gate: `Tags`/`Gather`/`Ids` routes, plus optional `XpScale`), `Camera` (third-person pull, optional `FaceBlock`), `Animation` (the looping work emote plus an optional per-swing `Swing` cadence), `Luck` (bonus-loot proc + tiered `ItemDropList` floors), `Presentation` (the per-cycle sound/particle moment), and `Flairs` (the achievement-unlock cosmetic override seam). See the mod's `station/CLAUDE.md` for the full engine-side behavior.
- **The Sawmill** derives its conversions from every native `WoodPlanks`-category crafting recipe (`Recipe.FromCrafting: {"Categories":["WoodPlanks"]}`) instead of hand-authoring all 11 wood families - zero hardcoded conversions, matching the native Builders bench yield (the station's value-add is passive XP + luck loot, not better yield). Its held-tool gate matches any hatchet via the native `Gather` (Woods, functional) and `Tags` (Family: Hatchet) routes; `XpScale` multiplies cycle XP by held-tool power (a better hatchet earns more). Luck tiers roll one of three native `ItemDropList`s (`MMO_Station_Sawmill_T1/T2/T3`, modest planks-only tables) at aggregated 50/100/150% luck floors.
- **In-world block.** The Sawmill block is a placeable furniture item reusing the vanilla `Bench_Lumbermill` model/texture/icon (no new art). Its `BlockType.Interactions.Use` names a `RootInteraction` whose single entry is the **object form** `{ "Type": "mmo_station_use", "Station": "sawmill" }`; the mod's `StationUseInteraction` reads the `Station` field and toggles that station's work loop for the pressing player. This is why N stations in a pack is N blocks + N RootInteractions, but still one Java interaction type - the mod-side pattern mirrors the bounty pack's `mmo_bounty_board_open` object-form param exactly.
- **Native-namespace lang stays with the block/emote.** `items.lang` (block name/description/interaction hint) and `avatarCustomization.lang` (the emote's display name in Hytale's own client-owned namespace) ship here, per locale, because they belong to the native asset the pack authors, mirroring how the bounty pack ships `items.lang`/`npcs.lang` for its blocks/NPCs. The mod's own `mmoskilltree.lang` convention keys (`station.sawmill.name`/`.desc`, all `ui.station.*` UI strings) stay in the JAR - they are the mod's generic per-station-id convention, not native-namespace content, and apply to any pack's stations equally.

## Authoring a new station

1. **The `StationAsset`**: drop `Server/MMOSkillTree/Stations/<Name>.json` (filename, lowercased, is the station id). Reuse `Sawmill.json` as the template; a variant station can `"Parent": "Sawmill"` and override only the leaves it needs (every leaf is `appendInherited`).
2. **The block**: copy `MMO_Station_Sawmill.json` → `MMO_Station_<Name>.json`, point `BlockType.Interactions.Use` at your new `RootInteraction` id, and give it its own model/texture/icon (or reuse a vanilla one, as the Sawmill does).
3. **The interaction**: `Server/Item/RootInteractions/MMO_Station_<Name>_Use.json`:
   ```json
   { "Cooldown": { "Id": "BlockInteraction", "Cooldown": 0.278, "ClickBypass": true },
     "Interactions": [ { "Type": "mmo_station_use", "Station": "<id>" } ] }
   ```
   The `mmo_station_use` type is Java-registered once in the mod jar; every station reuses it.
4. **Lang**: add `MMO_Station_<Name>.name`/`.description`/`.hint` to `Server/Languages/en-US/items.lang` (translate into the other locales you support), and give `Identity.NameKey`/`DescKey` on the `StationAsset` a `station.<id>.name`/`.desc` key - either author it in this pack's own `mmoskilltree.lang`, or ask the mod maintainer to add it to `EnglishDefaults.java` if it should ship as a mod-wide convention default.
5. **Loot tiers (optional)**: author `Luck.Tiers` (station-level) or `Luck.SkillTiers` (per luck-skill) floors naming a native `ItemDropList` id you ship under `Server/Drops/`. Keep tables modest (mostly `Empty`) - the mod's `StationValidator` flags a missing floor/droplist but frequency control is entirely the droplist's own weights.

## Build & deploy

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
.\build.ps1 -ModsDir <path>  # build + install into an explicit folder
```

`build.ps1` is self-locating (`$PSScriptRoot`) and cross-platform (Windows PowerShell, or `pwsh ./build.ps1` on macOS/Linux). It zips with forward-slash entries AND an explicit directory entry for every ancestor path (Java's `ZipFileSystem.isDirectory()` returns false without them, so Hytale's `I18nModule.loadMessagesFromPack` would skip the bundled `.lang` files). Never use `Compress-Archive` (it writes backslash separators Hytale drops). To auto-install on build, set `HYTALE_MODS_DIR` once to your Hytale `UserData/Mods` folder (or pass `-ModsDir`); without it the script just builds the zip.

Start the server with both the mod jar and this zip in `Mods/`. Confirm in the log: a Station asset layer fold line naming `sawmill`, plus no `Asset validation FAILED`. In-game: craft or `/give` the Sawmill block, place it, and press use.

## Conventions (shared with the bounty pack)

Filenames PascalCase (the asset key). Item + RootInteraction JSON keys start upper-case (Hytale codec requirement). `StationAsset` keys are PascalCase per the mod's Pattern A codec convention. See `bounty-contracts-pack/CLAUDE.md` for the shared native-asset-pack conventions this pack follows.
