# CLAUDE.md - MMOSkillStationsPack

A standalone Hytale content pack shipping all **interactive work station** content: the
**Sawmill** (a diegetic third-person work loop station) and (phase 2 leg E) the **Anvil** - a
TWO-action station (Convert: sharpen a vanilla metal bar; Enhance: the flagship Stamp-step ritual
that rolls stats onto a placed weapon) - see `.claude/research/raw/
rpg-stations-unified-design-2026-07-21.md` section 9.5 in the hyMMO monorepo. The station **engine**
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
    │   ├── items.lang                                    RPG_Station_Sawmill.name/.description/.hint.empty/.hint.loaded (native namespace; key-complete across all 9 locales)
    │   └── avatarCustomization.lang                       emotes.MMO_Emote_Saw.name (Hytale's own avatarCustomization namespace)
    └── RpgStations/
        └── Stations/Sawmill.json                         the StationAsset itself (Work/Recipe/Custody/Hold/Tool/Camera/Animation/Loot/Presentation), folds through RPG Stations' codec
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

## History (placed-input custody migration, RPG Stations phase 2 leg C)

The Sawmill migrated to session-scoped placed-input custody (design section 9.4) in lockstep with
RPG Stations' own engine leg: `Sawmill.json` gained a `Custody: {"MaxQuantity":100,"States":
{"Empty":"Default","Loaded":"Loaded"}}` group (no explicit `Custody.Input` - acceptance derives
from the station's existing `Recipe.Conversions`, the "logs by ResourceTypeId family" fallback,
zero extra authoring); `RPG_Station_Sawmill.json`'s `BlockType` gained a `State.Definitions.
Default/Loaded` pair (hint-only this leg - per-state `InteractionHint` only, no visual flip yet,
mechanism-first per the maintainer's sequencing) and its base `InteractionHint` repointed from the
single `items.RPG_Station_Sawmill.hint` key to `items.RPG_Station_Sawmill.hint.empty` (the `Loaded`
state's own hint is `.hint.loaded`, the OLD "Press [{key}] to work" wording). Materials now load
INTO the station on the first F-press (whole held stack, repeat presses top up, capped at 100) and
the per-cycle backpack drain the pre-leg-C engine ran is RETIRED - the implicit convert loop's
`Consume` step reads from that placed pouch instead. `items.lang` gained the two new hint keys in
en-US only at first; a later leg (commit `18e25f5`) filled the other 8 locales.

## History (placed-input PLACED-AS-ENTITY visual, RPG Stations phase 2 leg G)

Every `Custody`-governed action this pack ships now authors a `Custody.Display` group (design
section 9, the maintainer-directed PLACED-AS-ENTITY route - a spawned prop entity, NOT a
Blockbench baked-node model swap): `Sawmill.json`'s `Custody.Display: {"Offset":{"Y":0.62},
"Scale":0.4}`, `Anvil.json`'s `enhance.Custody.Display: {"Offset":{"Y":0.55},"Scale":1.0}`, and
(R4 authoring fix, closing the gap the anvil's `convert` action shipped WITHOUT one)
`Anvil.json`'s `convert.Custody.Display: {"Offset":{"Y":0.55},"Scale":1.0}` (mirrors `enhance`'s
own values - a placed metal bar, like the placed weapon, is a non-block item, so both render via
the same item-route prop). Before this fix a placed bar never even attempted a display spawn
(`StationService#placeIntoCustody` guards the spawn on a non-null `Custody.Display`), the
definitive cause of "no ingot visible on the anvil top" independent of the sibling ENGINE fix
below. RPG Stations' `station.StationCustodyDisplay` spawns a static, network-replicated,
pickup-immune, physics-free entity rendering the placed item at the station's block-top anchor
(`blockX+0.5, blockY+0.5, blockZ+0.5`, shifted by `Offset`) - a real `BlockEntity` for the
sawmill's placed logs (block-shaped, renders the actual log model, `Scale` composes with the
engine's own block-entity base-scale doubling) and a bare dropped-item-style `ItemComponent` prop
for the anvil's placed weapon/bar (no native `BlockType`). **All numeric `Offset`/`Scale` values
here are PROVISIONAL, tuned from source reading only, not verified in-game** - the phase-2 smoke
round is the place to adjust them (see RPG Stations' `station/CLAUDE.md`'s `StationCustodyDisplay`
bullet for the full engine-side mechanism and the world-space-offset caveat: a rotated block
placement is not compensated for, so keep any horizontal `X`/`Z` offset here small).

**R4 ENGINE fix (bugfix leg, alongside the authoring fix above):** the spawn/despawn call itself
was previously `store.addEntity`/`store.removeEntity` DIRECTLY from `StationCustodyDisplay`, which
throws `IllegalStateException("Store is currently processing!")` when called from inside an
interaction handler (the placement call site, `StationService#toggle` -> `#placeIntoCustody`, runs
INSIDE the store's processing lock) - the throw was caught by the method's own `catch (Throwable)`
and logged as a WARN, so the sawmill's placed-logs display (which DID author a `Custody.Display`
from the start) silently never appeared either. Fixed by switching both `spawn`/`despawn` to the
tick-safe `CommandBuffer<EntityStore>` primitive (`commandBuffer.addEntity`/`.removeEntity`, the
same one `StationEntityMountController#spawnAnchor` already used) - see RPG Stations'
`station/CLAUDE.md` for the file-by-file detail.

## The Anvil (RPG Stations phase 2 leg E, design section 9.5)

`Server/RpgStations/Stations/Anvil.json` is the FIRST multi-action station this pack ships
(design 9.1): an `Actions` map with `convert` (a classic repeat-loop Recipe conversion, sharpens a
vanilla metal bar into `MMO_Sharpened_<Metal>_Bar`) and `enhance` (`Work.Repeat: false` - one
completed program run ends the session; a `Steps` ritual of two hammer-strike `Wait` beats, a
settling pause, then the `Stamp` step). Both actions gate on holding a hammer (station-level
`Tool.Ids: ["Tool_Hammer_Crude","Tool_Hammer_Iron"]` - no `Tags.Family:["Hammer"]` exists on the
real vanilla hammer items, so this pack uses the `Ids` fallback route, not the design doc's
assumed `Tags` route). The block reuses the vanilla `Blocks/Benches/Anvil.blockymodel` (no new
art, same "reuse a vanilla bench" convention as the Sawmill's Lumbermill) - its sibling texture
path (`Blocks/Benches/Anvil_Texture.png`) follows the SAME `<Model>_Texture.png` convention every
other bench in this asset family uses, UNVERIFIED against the live client (a phase-2 smoke item,
same risk class as the standing-mount pose).

- **Convert**: `Input: {ResourceTypeId: "Metal_Bars"}` selects this action for any held vanilla
  bar in that family (10 of the 11 vanilla metal bars share it; `Ingredient_Bar_Bronze` uses the
  distinct `Copper_Iron_Bar` family and is NOT shipped as a Sharpened Bar this leg - a deliberate,
  documented scope cut, not an oversight). `Recipe.Conversions` is EXPLICIT per metal (2 vanilla
  bars -> 1 `MMO_Sharpened_<Metal>_Bar`, `Server/Item/Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json`
  x10, `ResourceTypes:[{"Id":"MMO_Sharpened_Bar"}]` - their OWN shared family, the Stamp step's
  `Reagents` route) - explicit over a `FromCrafting` sweep so no phantom native recipe leaks into
  bench UIs, per design 9.5. **SMOKE-FIX S4 (2026-07-22): `convert` now ALSO authors
  `Custody: {MaxQuantity: 100, States: {Empty: "Default", Loaded: "BarsPlaced"}}`** (no explicit
  `Custody.Input` - acceptance derives from `Recipe.Conversions`, the sawmill's zero-extra-
  authoring fallback) - leg E shipped `convert` WITHOUT a `Custody` group at all, so pressing F
  while holding a bar fell straight through to the station-level `Tool` gate (requires a hammer),
  denying placement entirely regardless of what was held; the fix mirrors `enhance`'s own
  placement mechanism. `RPG_Station_Anvil.json` gained the matching `BarsPlaced` block state
  (reusing the existing generic `items.RPG_Station_Anvil.hint.loaded` key - no new lang key).
- **Enhance**: `Input: {Function: "Weapon"}` selects this action for any held weapon-shaped item;
  `Custody: {MaxQuantity: 1, Input: {Function: "Weapon"}, States: {Empty: "Default", Loaded:
  "WeaponPlaced"}}` places the weapon (a state-dependent F, design 9.4's mechanism, reused for a
  single metadata-preserving item this time - see RPG Stations' `station/CLAUDE.md`'s
  `StationCustodyClaim.uniqueStack` note for why that matters). **SMOKE-FIX S4 (2026-07-22):**
  `Custody.Input`'s `Function` route was never actually wired into the custody PLACEMENT matcher
  (`station.StationCustody#matchesInput` only tested ItemId/ResourceTypeId/Tags, despite
  `ActionInput.Function` being resolved for ACTION SELECTION since leg E - a stale-javadoc gap,
  not a design choice), so a held weapon always correctly SELECTED `enhance` but never actually
  PLACED into custody; fixed by adding the `Function` route to `matchesInput`. The ritual's `Steps` (`strike1`/
  `strike2`/`settle`/`stamp`) use `Wait.DurationMs` (NOT `Beats` - `Beats` stays schema-reserved,
  unimplemented; authoring it would have hard-failed the ritual at its first step) and reuse
  ONLY verified sound/particle ids (`SFX_Metal_Hit`, `Block_Gem_Sparks`,
  `SFX_Chest_Legendary_FirstOpen_Player` - all already load-bearing elsewhere in this repo). The
  `Stamp` step's `Reagents` (2x `MMO_Sharpened_Bar` family) come straight from the player's
  INVENTORY (never a second custody claim); its `Stats.Pool` references
  `Server/RpgStations/RollPools/AnvilWeaponPool.json` (global weapon-adjacent stats -
  `MMO_CritChance`/`MMO_CritMultiplier`/`MMO_Lifesteal`/`MMO_CooldownReduction`/`MMO_Luck`/
  `MMO_BonusXp`, matching the MMO's OWN `item.ItemEnhanceRoll` weapon-pool ranges exactly - note
  the REAL stat id is `MMO_CritChance`, not the design doc's placeholder `MMO_Crit_Chance`) with
  the maintainer-approved balance numbers (`Picks: 1-2`, `Unique: true`, `Caps.PerItemBudget: 30`,
  `Caps.PerStat.MMO_CritChance: 10`, `Caps.SkillScaledBudget: 0.5/SMITHING level`); its
  `Durability.AddMax: 10` lands even without the MMO (RpgStations-native).
- **SMITHING XP**: `convert` grants 6/cycle, `enhance` grants 25 per COMPLETED ritual only (no
  free-XP fountain - the cycle event fires from inside the `Stamp` step's own success path, so a
  cancelled/failed ritual grants nothing). SMITHING itself is a promoted MMO built-in skill
  (`skill.SkillRegistry`, `requiresFeatures: ["stations"]`, the exact TAMING precedent) - **NOT**
  shipped via this pack's own content at all; see RPG Stations' mod-root `CLAUDE.md` Phase 2
  section for the m9 correction (the design doc's `custom-skills.json`-in-the-pack framing does
  not match how that file actually loads - a local server-owner config, not a pack-authorable
  asset).

## History (first-boot fix wave, 2026-07-22)

Two content bugs surfaced on the first real boot log after phase 2 landed, both fixed in place
(no design change, the Anvil's authored intent is unchanged):

- **D3 - redundant `Camera.FaceBlock`**: `Anvil.json`'s station-level `Camera` group authored
  `FaceBlock: true` ALONGSIDE `Hold.Mount` (the standing entity mount, leg D) - the validator's
  `MOUNT_FACE_BLOCK_CONFLICT` warning was correct (the mount already locks facing while keeping
  the camera free; the packet-level `FaceBlock` lock on top is redundant/conflicting). Removed
  `FaceBlock` from `Camera`, keeping only `Recipe: "look_rot"`.
- **D6 - the ten `MMO_Sharpened_<Metal>_Bar` items failed native validation (SEVERE, anvil
  unusable)**: each authors `ResourceTypes: [{"Id": "MMO_Sharpened_Bar"}]`, but no `ResourceType`
  asset with that id existed - vanilla `ResourceType` (`HytaleAssets/Schema/ResourceType.json`,
  path `Item/ResourceTypes`) is a genuinely pack-authorable native asset type (Name/Description/
  Icon/Tags only, membership lives entirely on the ITEM side per
  `HytaleServer/CoreServer/.../asset/type/item/config/ResourceType.java`) - every vanilla exemplar
  (`Wood_Trunk`, `Metal_Bars`, `Bricks`, `Charcoal`, ...) is just `{"Icon": "Icons/ResourceTypes/
  <Something>.png"}`. Fix: ship `Server/Item/ResourceTypes/MMO_Sharpened_Bar.json` (`{"Icon":
  "Icons/ResourceTypes/Rock.png"}`, mirroring `Metal_Bars`' own icon - every metal-adjacent
  vanilla `ResourceType` reuses `Rock.png`), no item JSON changes needed. `ResourceType` is a
  native `loadsAfter` dependency of `Item` (`AssetRegistryLoader`'s `Item` store registration), so
  same-pack-layer load order guarantees it resolves before the ten items validate.

## History (i18n fix round - the leg-H locale gap closed)

Commit `18e25f5` ("Anvil-era key fill, 8 non-English locales") filled `items.lang`/
`avatarCustomization.lang` across all 8 non-English locales, but its own `rpgstations.lang` overlay
(the 2 `station.anvil.*` keys) only landed for es-ES/fr-FR/hu-HU/tr-TR - its commit body was honest
about the residual de-DE/it-IT/pt-BR/ru-RU gap, but the terse title read as broader completeness
than the diff actually shipped, and this `CLAUDE.md`/the pack `README.md` were never updated after
that commit to reflect even the partial fill, so both kept describing the PRE-commit "en-US only"
state. A fix-round pass added `station.anvil.name`/`.desc` to the 4 missing locales' own
`rpgstations.lang` files and corrected both docs - all 9 shipped locales are now key-complete for
the Anvil content, matching what `items.lang`/`avatarCustomization.lang` already were.

## History (display-offset + icon tuning, smoke round R5, 2026-07-22)

Third in-game smoke round, after the R4 fix confirmed display entities RENDER at all:

- **Display offsets, maintainer-observed in-game**: the placed log floated well above the
  sawmill's bench surface, and the placed ingot sat a bit too high on the anvil. Both `Custody.
  Display.Offset.Y` values from R4 (0.62 sawmill, 0.55 anvil `convert`) were maintainer-directed
  FIRST-GUESS placeholders, never re-verified in-game (see the R4 leg's own PROVISIONAL caveat
  above). Lowered to `Sawmill.json`'s `Custody.Display.Offset.Y: 0.05` (resting on the bench
  surface) and `Anvil.json`'s `convert.Custody.Display.Offset.Y: 0.35` - both marked with a
  top-level `$Comment` as maintainer-tunable first-pass guesses from this round, still not
  re-verified in-game. The maintainer flagged only the placed INGOT (`convert`), not the placed
  weapon (`enhance`), so `enhance.Custody.Display.Offset.Y` stays at 0.55 pending separate
  confirmation - both actions share the same anchor surface, so if the weapon also reads too high
  a follow-up smoke round should true it up the same way.
- **Station icons**: the maintainer asked the anvil/sawmill icon to use "the item id of those
  stations (its file name)". Read RPG Stations `station/StationService.java` (`#toggle` ->
  `#blockItemIdAt`) and `ui/StationSummaryHud.java` (`#renderStationIcon`, the ONE render site for
  `Identity.Icon`): the summary-HUD crest is built directly from a raw item id string
  (`new ItemStack(stationIconItemId, 1)`), and when a station authors no `Identity.Icon` (null or
  blank) the engine falls back to the anchor block's own `BlockType.getId()` at ENGAGE time
  (`StationService#blockItemIdAt`). Since this pack's block item files are named (and therefore
  IDed, per the repo's filename-is-item-id convention) `RPG_Station_Sawmill.json` /
  `RPG_Station_Anvil.json` exactly, that fallback already resolves to precisely the station's own
  item id with zero extra authoring. Removed `Identity.Icon` from both `Sawmill.json` (was
  `"Wood_Hardwood_Planks"`, a raw material, not the station's own icon) and `Anvil.json` (was
  `"Ingredient_Bar_Iron"`, same issue) rather than re-authoring it to the item-id form
  (`"RPG_Station_Sawmill"`/`"RPG_Station_Anvil"`) - the fallback is the single source of truth, so
  no id can drift between the block file and the station asset if one is renamed later.

## History (anvil work-start deny fix, R6, 2026-07-22)

The maintainer's fourth smoke boot found the anvil denying EVERY work-start attempt with
`ui.station.mount_unavailable`, holding the correct hammer. Diagnosis (RPG Stations
`station/CLAUDE.md`'s R6 bullet has the full source-confirmed trail): the anvil's
`Hold.Mount.Surface:"Entity"` (design 9.2's standing work mount, a phase-2 spike never verified
in-game) engaged with zero throw but zero visible effect - `StationEntityMountController`'s anchor
entity carried no `NetworkId` component, so the native mount broadcast/self-view systems silently
no-op'd against it. `Anvil.json`'s `Hold` moved OFF `Mount` onto the proven phase-1 effect-mode
default (`MovementLock: true`, `EffectId: "RPG_Station_Hold"`, `InterruptOnDamage: true`) - the
maintainer-recommended proven-hold swap while the Entity mount stays an unverified spike, NOT a
permanent reversal of the design-9.2 standing-worker intent (the engine-side `NetworkId` fix
landed alongside this, so a future pack revision can pick the Entity mount back up once it gets
its own in-game confirmation pass). `Camera.Recipe: "look_rot"` is unchanged. See the engine's own
`station/CLAUDE.md` R6 bullet for the graceful-degradation + orphan-anchor-leak + teardown
tick-safety hardening that landed in the SAME round, plus the new press-F custody RETRIEVAL
feature (no pack authoring needed - every `Custody.Display`-bearing action in this pack, both the
sawmill's logs and the anvil's `convert`/`enhance`, is now retrievable for free).

## How it fits together

- **A station is one `StationAsset` JSON + its block + its interaction.**
  `Server/RpgStations/Stations/<Name>.json` (filename lowercased = the station id) is decoded
  through RPG Stations' Pattern A codec: `Identity` (name/desc/icon), `Work` (cycle cadence, XP
  grants forwarded as progression declarations, optional `Idle` practice mode), `Recipe` (authored
  `Conversions` or a native-crafting-derived `FromCrafting`), `Hold` (the movement-lock effect),
  `Tool` (the held-tool gate: `Tags`/`Gather`/`Ids` routes, plus optional `XpScale`), `Custody`
  (session-scoped placed-input custody - a state-dependent F places materials then works them,
  see the History section above and RPG Stations' `asset/CLAUDE.md`), `Camera`
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
   one, as the Sawmill does). A `Custody`-governed station (step 5 below) needs a matching
   `BlockType.State.Definitions.<Empty>/<Loaded>` pair (Sawmill's own `Default`/`Loaded` names are
   just a convention, not fixed strings - whatever `Custody.States.Empty`/`.Loaded` name) so
   `world.setBlockInteractionState` has a state to flip to; hint-only is fine (per-state
   `InteractionHint` only, no visual flip yet - see the History section above).
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
