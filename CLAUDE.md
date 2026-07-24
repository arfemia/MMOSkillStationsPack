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

## History (round-7 fix wave: anvil rotation + SMITHING skill migration, leg F, 2026-07-23)

Two round-7 defects (design `raw/rpg-stations-round7-fix-design-2026-07-23.md`, D-1 and D-3) closed
in this pack:

- **D-1, the enhance weapon lying flat**: `Anvil.json`'s `enhance.Custody.Display` gains a
  `Rotation: {"X": 90.0}` leaf (the new nested `{X,Y,Z}` degrees group RPG Stations' `Custody`
  codec grew this round; X is pitch, so 90 tips the upright weapon mesh onto the horizontal). The
  full in-game tuning ladder (swap to `Z` for roll, tune `Y` last for horizontal alignment, and the
  explicit fallback if the client ignores pitch/roll entirely for a bare item prop) is written into
  the file's own `$Comment`. `convert.Custody.Display` and the sawmill's placed log stay
  deliberately UNROTATED (no defect reported for either).
- **D-3, SMITHING out of the jar roster**: this pack now ships the SMITHING skill itself, not just
  its bridge-fed XP. New `Server/MMOSkillTree/CustomSkills/Smithing.json` (Pattern A
  `CustomSkillAsset` - see `asset/type/CLAUDE.md` in the MMO repo) reproduces the removed MMO jar
  built-in verbatim (Name "Smithing", Category CRAFTING, InsertAfter ENCHANTING, Description "Forge
  weapons and armor to gain experience", Icon `Icons/ItemsGenerated/Ingredient_Bar_Iron.png`,
  Triggers `["CRAFT_ITEM"]`, RequiresFeatures `["stations"]`). Localization moved WITH the
  definition: every `Server/Languages/<locale>/mmoskilltree.lang` file (new family for this pack)
  carries `skill.smithing`, its value moved VERBATIM from that locale's own MMO jar translation
  (recovered from the jar's git history at the commit that removed it) - except it-IT, whose jar
  value was an untranslated English copy ("Smithing"), fixed here to "Forgiatura" while moving. A
  new key, `skill.smithing.desc`, is authored en-US only this leg ("Forge weapons and armor to gain
  experience"); the other 8 locales are filled by a follow-up lang-fanout leg. The MMO's
  `getMaxLevel`/registry pack-layer machinery (root repo's `skill/CLAUDE.md`) is what actually folds
  this asset into the live roster; nothing else in this pack changed for D-3 (the empty leftover
  `Server/MMOSkillTree/Stations/` directory from before this asset type existed was also deleted).

## History (round-8: facing-relative display + step-synced puppet swings, 2026-07-23)

Two round-8 authoring changes in `Anvil.json`, both riding RPG Stations engine changes of the same
round (no engine code lives here):

- **Facing-relative `Custody.Display` (engine commit `cc52fb4`)**: `Custody.Display` `Offset`/
  `Rotation` are now interpreted RELATIVE to the placed anvil block's own facing yaw, not absolute
  world axes - RPG Stations reads the block's `getBlockRotationIndex` yaw at spawn, rotates the
  horizontal `Offset` (X/Z) by it (authored `+Z` = toward the block's FRONT, `+X` = its right; `Y`
  stays vertical) and folds the block yaw into `Rotation.Y`. A DEFAULT-orientation placement (yaw 0)
  is the identity, so no blind re-tune was needed for existing values. `enhance.Custody.Display` was
  re-tuned for the maintainer's placed-weapon screenshot: `Offset.X: 0.3` (a facing-relative sideways
  pull toward the anvil-top center) and `Rotation.Z: 90.0` (roll, added to the existing `X: 90.0`
  pitch so the hilt lies flat). `convert.Custody.Display` (placed ingot, `Offset.Y 0.52`) and the
  sawmill's placed log (`Offset.Y -0.1`) author ONLY a vertical `Offset.Y` with no horizontal shift
  and no `Rotation`, so the facing-relative change leaves them byte-identical at any orientation -
  deliberately left unchanged. All the axis/sign/fallback tuning ladder lives in `Anvil.json`'s own
  `$Comment`; every value is a plain JSON leaf, maintainer-tunable without an engine rebuild.
- **Step-synced puppet swings (engine round-8)**: the enhance ritual's `strike1` and `strike2` steps
  now author a per-step `Puppet.Clip` of `MMO_Emote_Hammer` so the skinned puppet visibly HAMMERS on
  both strike beats (previously it played its engage loop once, then stood still through both
  strikes). `MMO_Emote_Hammer` is the exact clip RPG Stations' generic swing route already resolves
  for the held hammer here (the enhance action inherits `Animation.EmoteId` = `MMO_Emote_Hammer` from
  the station level), authored explicitly per step. RPG Stations plays the clip once at each step's
  ITERATION ENTRY and SUPPRESSES the generic engage/swing puppet clip for the whole ritual (the
  step-entry clips are the sole animation driver, no double-fire). The `settle` step authors NO clip
  on purpose (the puppet idles for the settling pause), and the `stamp` step keeps its existing
  `Puppet.Prop.Source: "None"` empty-hands override - it authors a Prop but no Clip, so no hammer
  swing fires on the enchant-flourish beat (composes cleanly). See RPG Stations' `station/CLAUDE.md`
  puppet-engine bullet for the engine mechanism.

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
  cancelled/failed ritual grants nothing). **Superseded by round-7 D-3 (see the History section
  above): SMITHING is no longer an MMO jar built-in.** It ships as this pack's own
  `Server/MMOSkillTree/CustomSkills/Smithing.json` (a Pattern A `CustomSkillAsset`,
  `requiresFeatures: ["stations"]` carried over unchanged from the built-in), folded into the
  MMO's `SkillRegistry` pack layer. Without this pack installed, SMITHING no longer exists at all
  (not even hidden - the prior "promoted built-in, TAMING precedent" framing and the m9 correction
  below are historical, kept for the fix-wave trail).

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
  **R7 CORRECTION (this leg's own fix round, 2026-07-22): the "that id equals this station's own
  item id" claim above was FALSE at engage time.** Both stations are custody stations
  (`Custody.States`), and a custody station ONLY engages after materials are placed - which has
  already flipped the block to a `Loaded`/`BarsPlaced`/`WeaponPlaced` state via
  `setBlockInteractionState`. A state variant is a DISTINCT, generated-key `BlockType` asset
  (`StateData#generateBlockKey`: `"*" + parentKey + "_" + stateName`), so at engage
  `blockType.getId()` actually returned e.g. `"*RPG_Station_Sawmill_Loaded"` - not a real item id
  - and `new ItemStack(id, 1)` resolved the UNKNOWN placeholder crest, not the station's own icon:
  the fallback defeated its own stated goal, regressing from the PRIOR valid-if-wrong material
  icon to a placeholder. Fixed engine-side, not by re-authoring `Identity.Icon` here:
  `StationService#blockItemIdAt` now resolves via `BlockType#getItem()` (the block's containing
  Item asset key, confirmed via the shared source to walk correctly through a state variant's
  `Data.containerData` chain back to the base Item) instead of the raw `BlockType#getId()` - the
  fallback's original zero-duplicated-id-to-drift intent now genuinely holds for state-bearing
  custody blocks too, so no pack authoring change was needed. See RPG Stations'
  `station/CLAUDE.md`'s R7 bullet for the full source trail.

## History (anvil work-start deny fix, R6, 2026-07-22)

The maintainer's fourth smoke boot found the anvil denying EVERY work-start attempt with
`ui.station.mount_unavailable` (the exact toast `StationService#toggle`'s Entity-mount engage path
sends whenever `spawnAnchor`/`attach` returns null/false), holding the correct hammer. Diagnosis
(RPG Stations `station/CLAUDE.md`'s R6 bullet has the full source-confirmed trail): the anvil's
`Hold.Mount.Surface:"Entity"` (design 9.2's standing work mount, a phase-2 spike never verified
in-game). Source reading of that same mechanism surfaced a SEPARATE, confirmed defect independent
of whichever condition triggered the observed deny - `StationEntityMountController`'s anchor
entity carried no `NetworkId` component, so the native mount broadcast/self-view systems silently
no-op'd against it, meaning even a mount that DID succeed would have rendered invisibly.
`Anvil.json`'s `Hold` moved OFF `Mount` onto the proven phase-1 effect-mode
default (`MovementLock: true`, `EffectId: "RPG_Station_Hold"`, `InterruptOnDamage: true`) - the
maintainer-recommended proven-hold swap while the Entity mount stays an unverified spike, NOT a
permanent reversal of the design-9.2 standing-worker intent (the engine-side `NetworkId` fix
landed alongside this, so a future pack revision can pick the Entity mount back up once it gets
its own in-game confirmation pass). `Camera.Recipe: "look_rot"` is unchanged. See the engine's own
`station/CLAUDE.md` R6 bullet for the graceful-degradation + orphan-anchor-leak + teardown
tick-safety hardening that landed in the SAME round, plus the new press-F custody RETRIEVAL
feature (no pack authoring needed - every `Custody.Display`-bearing action in this pack, both the
sawmill's logs and the anvil's `convert`/`enhance`, is now retrievable for free).

## History (the puppet route + final offset re-tune, RPG Stations round-4, 2026-07-22 late)

Both `Sawmill.json` and `Anvil.json` now author a station-level `Puppet` group (round-4 design,
"mount the player, hide their player model, and spawn/display a visual of their character model
performing the steps"; see RPG Stations' `asset/CLAUDE.md`'s `Puppet` bullet for the full schema
and `station/CLAUDE.md`'s puppet-engine bullet for `StationPuppetController`): `Hide.Route:"Scale"`
(the in-game-crowned self-hide mechanism), `Look.Source:"PlayerClone"` (the puppet wears a clone of
the working player's own skin), `Offset:{X:0.0,Y:-0.4,Z:0.4}` + a station-authored `Yaw`, and
`Prop.Source:"MirrorHeld"` (the puppet holds a live copy of whatever the player is holding). The
anvil's `enhance` action's `stamp` step adds ONE per-step override, `Puppet.Prop.Source:"None"`, so
the puppet's hands go empty specifically for the stamp beat instead of still gripping the hammer.
All puppet placement values are a first-pass guess, in-game-unverified as of this pass (the
consolidated next-session checklist section A covers the confirm).

**Display offsets were re-tuned AGAIN this same round, superseding the R5 section above**: the R5
values (`sawmill 0.05`, `anvil convert 0.35`) were themselves first-guess placeholders from the
PRIOR smoke round, not a final confirm. Current shipped values: `Sawmill.json`'s
`Custody.Display.Offset.Y = -0.1` (lowered from R5's `0.05`, now intentionally slightly below the
block-top anchor) and `Anvil.json`'s `convert.Custody.Display.Offset.Y = 0.52` (raised from R5's
`0.35`, was sitting too deep in the anvil model). `Anvil.json`'s `enhance.Custody.Display.Offset.Y`
stays UNCHANGED at `0.55` - the maintainer flagged only the ingot this round, so the placed-weapon
offset remains the one PENDING offset confirm (every other offset here has at least one in-game
re-tune behind it; this one never has). Every one of these is a plain JSON leaf, maintainer-tunable
without an engine rebuild.

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
