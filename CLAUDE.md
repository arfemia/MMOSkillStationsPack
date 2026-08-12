# CLAUDE.md - MMOSkillStationsPack

**SHARED-LOOT RE-BASE (pre-release, current state - read before touching a Lootable here).** The
loot MODEL is `ziggfreed-common`'s now, not RPG Stations' own, so this pack's tables moved and their
shape changed:
- **Files live at `Server/ZiggfreedCommon/Lootables/*.json`** (and the anvil's roll pool at
  `Server/ZiggfreedCommon/RollPools/`), both registered by the shared library. Ids and fold
  semantics are unchanged: a table folds by id and a later layer replaces the whole FILE, which is
  still why `SawmillTrophy` can be overridden here in one small file.
- **A `Chance` is `{Base, Factors, Clamp:{Max}}`** - `BasePercent`/`CapPercent` are gone. Every
  `Factors` array is the shared weighted factor TERM (`{Factor, Param?, Weight?}`), unchanged in
  shape.
- **A floor or roll cue is `Cue`, a MOMENT ID string**, not an inline `Presentation`. The station
  decides what a cue sounds like, so this pack's find tiers name the jar Sawmill's published
  palette - `rare_find` for the everyday tiers, `cue:find_deep` for T3/T4, `cue:find_apex` for T5,
  `cue:trophy` for the hatchet win - and author no presentation of their own.
- **`Grants.OutputItems` is the `rpgstations:output_items` REWARD**:
  `{"Rewards": [{"Kind": "rpgstations:output_items", "Params": {"Count": "1.5"}}]}`. The number, its
  fractional meaning and the summed-once resolution are all unchanged.

A standalone Hytale content pack shipping the MMO-side **interactive work station** content: the
**Sawmill progression layer** (the sawmill StationAsset itself, incl. its Puppet/log-display
presentation defaults, lives in the RPG Stations JAR - see the 2026-07-28 History section; this
pack extends it additively) and (phase 2 leg E) the **Anvil** - a
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
    │   ├── Items/RPG_Station_Sawmill.json + RPG_Station_Anvil.json  the two station blocks (vanilla Lumbermill / Anvil bench models); SHARED ids with RPG Stations' own jar defaults, override via pack load order
    │   ├── Items/RPG_Tool_Hatchet_Sawmiller.json                    the sawmill's drop-only trophy hatchet; SHARED id with the RPG Stations jar item, overridden wholesale to add the MMO stat payload (Utility.StatModifiers)
    │   ├── Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json (x10)    the anvil convert outputs (shared MMO_Sharpened_Bar family, the Stamp step's Reagents route)
    │   ├── ResourceTypes/MMO_Sharpened_Bar.json                     the native ResourceType those bars share
    │   └── (RootInteractions: none shipped - the sawmill block's Use resolves to the identically named
    │        RPG_Station_Sawmill_Use the RPG Stations jar ships; the anvil's own Use file is under unreleased/)
    ├── Drops/MMO_Station_Sawmill_T1..T5.json             native ItemDropList find loot, one per tier (referenced by Lootables/SawmillLuckFinds.json's Ladder floors). Each is a Multiple composing N Droplist pulls of the JAR's shared RPG_Station_Sawmill_Byproducts (1/1/2/2/3) with its own life-essence Choice; T1 pays offcuts ONLY (essence starts at T2) and T5's essence Choice is the only one with no Empty entry
    ├── Drops/MMO_Station_Sawmill_Masterwork.json         the Sawmiller's Hatchet's own reward table: 2 byproduct pulls + a 2% Woodcutting XP boost token, no essence and no planks
    ├── (Emote: none shipped - MMO_Emote_Saw was deleted as dead once station presentation moved into
    │    the jar and the work animation became the held tool's Action-slot clip; MMO_Emote_Hammer lives
    │    under unreleased/ with the anvil ritual that plays it)
    ├── Languages/<bcp47>/                                items.lang (anvil + sharpened-bar keys) + avatarCustomization.lang (hammer emote) + rpgstations.lang (station.anvil.*) + mmoskilltree.lang (skill.smithing/.cooking) - key-complete across all 9 locales; the held-back content's keys deliberately STAY shipped
    └── RpgStations/
        ├── Extensions/SawmillProgression.json            the additive ExtensionAsset targeting the JAR Sawmill's Mill action (station-scoped {Station, Action}): XP declarations + the three Lootable refs below
        └── (loot tables live under Server/ZiggfreedCommon/Lootables/ - the SHARED library's store)

    Server/ZiggfreedCommon/
        └── Lootables/                                    four tables, ONE CONCERN EACH
            ├── SawmillLuckFinds.json                     the find-tier ladder: 2 banded Rolls (T1-T2 ungated, T3-T5 behind WOODCUTTING 30) over one 5-factor luck+level score
            ├── SawmillOutputLadders.json                 the two bonus-PLANK ladders: one level-only, one luck-only (fractional extra output, an rpgstations:output_items reward)
            ├── SawmillMasterworkBonus.json               the single tool-gated Roll rewarding a worker for WIELDING the Sawmiller's Hatchet (does NOT grant it); pays the Masterwork drop table above
            └── SawmillTrophy.json                        an ID OVERRIDE of the RPG Stations jar table of the same name: the hatchet CHASE, 1-in-3000 rising with base+WOODCUTTING luck. NOT listed in SawmillProgression's Bonus.Lootables (the jar's Sawmill already references this id; folding by id replaces it in place). The other three ARE listed there.
```

Held back under `unreleased/` (NOT in the shipped zip; `unreleased/restore.ps1` brings each group
back): `Stations/Anvil.json` (the two-action Anvil, a full-file pack override) + its block/Use
files + `ZiggfreedCommon/RollPools/AnvilWeaponPool.json` + `Extensions/CookingProgression.json` (bare Action
target on the shared PrepFish ritual) + `MMOSkillTree/CustomSkills/Smithing.json + Cooking.json`
(Pattern A `CustomSkillAsset`s) + `Emote/MMO_Emote_Hammer.json` + the ten sharpened-bar items'
sources. Their lang keys stay shipped per the standing unreleased rule.

`Server/Item/**`, `Server/Drops/**`, `Server/Emote/**`, and `Server/Languages/**` load via Hytale's
native asset pack mechanism (gated by `"IncludesAssetPack": true`), independent of RPG Stations'
own `Control` map (which only governs `Server/RpgStations/**`). `Server/RpgStations/Stations/*.json`
folds through RPG Stations' `StationAsset` codec (`AssetStoreRegistrar`); a station id here
OVERRIDES a same-id RPG Stations jar default (`defaults < pack` fold) - the ANVIL ships that way.
The Sawmill does NOT (wave 2, scope-2 arc): the jar's own `Sawmill.json` stays live (it owns the
presentation defaults - Worker.Puppet, Custody.Display, the 4805ms cadence - per decision 59), and
`Server/RpgStations/Extensions/SawmillProgression.json` composes the MMO progression onto its
`Mill` action ADDITIVELY through the `ExtensionAsset` fold, targeting it by `Target: {Action}`
(the action-first schema restructure means an extension names the ACTION it adds to, not the whole
station): XP declarations plus the three `Bonus.Lootables` refs, all unioned onto the jar action's
own `Bonus` so its session-loyalty `SawmillFinds` table and tool-ladder rolls keep firing beside
them.

**Same-id ITEM overrides this pack ships.** A `Server/Item/Items/<Id>.json` whose id matches an RPG
Stations jar item replaces that item WHOLESALE (there is no per-leaf merge on the native item store,
unlike the `ExtensionAsset` fold above), so each of these files reproduces every field of the jar
copy verbatim and adds only its own delta. Two ship today:

- **`RPG_Station_Sawmill.json`** - the station block. Its delta is a deliberate SUBTRACTION: the copy
  authors no `Recipe`, so installing this pack removes the jar default's Furniture-bench craftability
  (acquisition of the MMO-bridged sawmill is this pack's concern, gated by load order alone). See the
  file's own `$Comment`.
- **`RPG_Tool_Hatchet_Sawmiller.json`** - the sawmill's drop-only trophy hatchet. Its delta is an
  ADDITION: a `Utility.StatModifiers` payload (`Stamina` +10, `MMO_BonusXp_WOODCUTTING` +25,
  `MMO_Luck_WOODCUTTING` +25, all `Additive`, the map-of-stat-id-to-modifier-list shape
  `ItemUtility.CODEC` decodes). The jar copy stays progression-free so the trophy is complete under
  RPG Stations alone; this copy is the MMO-flavored one. The stats apply only while the hatchet is
  HELD, and they are applied by the MMO's own equip stat bridge, NOT by the native stat manager - the
  native manager reads a `Utility` stat block off the separate utility accessory slot only, never off
  a held tool, which is exactly why the MMO's tool convention puts tool stats on `Utility` rather
  than `Weapon` (a `Weapon` block on a tool zeroes its block-gather power engine-side).
  `Utility.Compatible` stays `true` and `Usable` stays unauthored, as the jar authors them, so the
  hatchet can never occupy the utility slot itself and nothing applies the payload twice. The
  per-skill channels (`MMO_Luck_<SKILL>`, `MMO_BonusXp_<SKILL>`) are registered by the MMO at setup,
  before any pack loads, so a pack item may reference them by id; percent-family MMO channels take
  their PERCENT as the `Amount` and must be `Additive` (they carry a base of 0, and additive folds
  before multiplicative, so a Multiplicative-only entry computes 0 and is inert - the MMO's own
  startup item-stat audit warns on exactly that). No lang is re-declared: name and description reuse
  the jar's `items.RPG_Tool_Hatchet_Sawmiller.*` keys. NO `Recipe`, matching the jar copy - the
  hatchet stays the sawmill's chase find.

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
  stays vertical) and folds the block yaw into `Rotation.Yaw`. A DEFAULT-orientation placement (yaw 0)
  is the identity, so no blind re-tune was needed for existing values. `enhance.Custody.Display` was
  re-tuned for the maintainer's placed-weapon screenshot: `Offset.X: 0.3` (a facing-relative sideways
  pull toward the anvil-top center) and `Rotation.Roll: 90.0` (the flat-vs-edge twist, paired with
  `Rotation.Yaw: 0.0` so the hilt lies flat along the anvil). `convert.Custody.Display` (placed ingot, `Offset.Y 0.52`) and the
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
`mmoskilltree:station_luck` factor, the M3-critique-tightened `Roll` schema: `Factors` is an
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

**Schema note (action-first restructure):** `Anvil.json`'s top-level `Actions` is now an ORDERED
ARRAY of self-contained action objects (each carrying its own `Id`, e.g. `"Convert"`/`"Enhance"`),
not a keyed map, and every group that used to sit at STATION level (`Tool`, `Hold`, `Camera`,
`Animation`, `Puppet`, `Completion`) is DUPLICATED INLINE into both actions instead - a station now
supplies only `Identity`, `Block`, `Requires`, `Flairs`, and the `Actions` array itself, nothing
else is a per-action default. The four worker-presentation groups (`Hold`/`Camera`/`Animation`/
`Puppet`) nest under a `Worker` group per action, and `Cycle`/`Completion` nest under a `Moments`
group per action. The old per-action `Input` leaf (which action a held/placed item selects) is
renamed `Select`; `Custody.Input` (which item a placement ACCEPTS once selected) is unchanged and
stays distinct. `Recipe` is a single group per action (`Recipes[]` is gone) - one recipe per action,
two transforms mean two actions. The bullets below describe the shape as authored today; adjust the
lowercase `convert`/`enhance` map-key references below to the current `Id: "Convert"`/`Id: "Enhance"`
array-entry spelling.

`Server/RpgStations/Stations/Anvil.json` is the FIRST multi-action station this pack ships
(design 9.1): an ordered `Actions` array with `Convert` (a classic repeat-loop Recipe conversion,
sharpens a vanilla metal bar into `MMO_Sharpened_<Metal>_Bar`) and `Enhance` (`Work.Looping: false`
- one completed program run ends the session; a `Steps` ritual of two hammer-strike `Duration`
beats, a settling pause, then the `Stamp` step). Both actions gate on holding a hammer (each
action's own duplicated `Tool.Ids: ["Tool_Hammer_Crude","Tool_Hammer_Iron"]` - no
`Tags.Family:["Hammer"]` exists on the real vanilla hammer items, so this pack uses the `Ids`
fallback route, not the design doc's assumed `Tags` route). The block reuses the vanilla
`Blocks/Benches/Anvil.blockymodel` (no new art, same "reuse a vanilla bench" convention as the
Sawmill's Lumbermill) - its sibling texture path (`Blocks/Benches/Anvil_Texture.png`) follows the
SAME `<Model>_Texture.png` convention every other bench in this asset family uses, UNVERIFIED
against the live client (a phase-2 smoke item, same risk class as the standing-mount pose).

- **Convert**: `Select: {ResourceTypeId: "Metal_Bars"}` selects this action for any held vanilla
  bar in that family (10 of the 11 vanilla metal bars share it; `Ingredient_Bar_Bronze` uses the
  distinct `Copper_Iron_Bar` family and is NOT shipped as a Sharpened Bar this leg - a deliberate,
  documented scope cut, not an oversight). `Recipe.Conversions` is EXPLICIT per metal (2 vanilla
  bars -> 1 `MMO_Sharpened_<Metal>_Bar`, `Server/Item/Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json`
  x10, `ResourceTypes:[{"Id":"MMO_Sharpened_Bar"}]` - their OWN shared family, the Stamp step's
  `Reagents` route). **A conversion's `Input`/`Output` are Ingredient ARRAYS** (the native
  `CraftingRecipe` shape), so each entry here reads `"Input": [{...}], "Output": [{...}]`; a
  multi-material recipe simply lists more entries - explicit over a `FromCrafting` sweep so no phantom native recipe leaks into
  bench UIs, per design 9.5. **SMOKE-FIX S4 (2026-07-22): `Convert` now ALSO authors
  `Custody: {MaxQuantity: 100, States: {Empty: "Default", Loaded: "BarsPlaced"}}`** (no explicit
  `Custody.Input` - acceptance derives from `Recipe.Conversions`, the sawmill's zero-extra-
  authoring fallback) - leg E shipped `convert` WITHOUT a `Custody` group at all, so pressing F
  while holding a bar fell straight through to that action's own `Tool` gate (requires a hammer),
  denying placement entirely regardless of what was held; the fix mirrors `Enhance`'s own
  placement mechanism. `RPG_Station_Anvil.json` gained the matching `BarsPlaced` block state
  (reusing the existing generic `items.RPG_Station_Anvil.hint.loaded` key - no new lang key).
- **Enhance**: `Select: {Function: "Weapon"}` selects this action for any held weapon-shaped item;
  `Custody: {MaxQuantity: 1, Input: {Function: "Weapon"}, States: {Empty: "Default", Loaded:
  "WeaponPlaced"}}` places the weapon (a state-dependent F, design 9.4's mechanism, reused for a
  single metadata-preserving item this time - see RPG Stations' `station/CLAUDE.md`'s
  `StationCustodyClaim.uniqueStack` note for why that matters). **SMOKE-FIX S4 (2026-07-22):**
  `Custody.Input`'s `Function` route was never actually wired into the custody PLACEMENT matcher
  (`station.StationCustody#matchesInput` only tested ItemId/ResourceTypeId/Tags, despite
  `ActionInput.Function` being resolved for ACTION SELECTION since leg E - a stale-javadoc gap,
  not a design choice), so a held weapon always correctly SELECTED `enhance` but never actually
  PLACED into custody; fixed by adding the `Function` route to `matchesInput`. The ritual's `Steps`
  (`strike1`/`strike2`/`settle`/`stamp`) are ORTHOGONAL-PHASE steps: each pairs a base
  `Duration: {Ms}` hold with whatever phase groups it needs (`Puppet.Clip`, `Presentation`,
  `Stamp`), with no step `Type` and no `Wait` step - the scope-2 reshape retired both, and the
  never-implemented `Beats` leaf went with them. They reuse
  ONLY verified sound/particle ids (`SFX_Metal_Hit`, `Block_Gem_Sparks`,
  `SFX_Chest_Legendary_FirstOpen_Player` - all already load-bearing elsewhere in this repo); a
  `Presentation.Particles` entry is a `ModelParticle`-shaped group, so the minimal authoring the
  anvil uses is `"Particles": [ { "SystemId": "Block_Gem_Sparks" } ]` and the per-burst
  `Scale`/`DurationSeconds`/`RotationOffset`/`PositionOffset` knobs stay unauthored at their
  playback-preserving defaults. The
  `Stamp` step's `Reagents` (2x `MMO_Sharpened_Bar` family) come straight from the player's
  INVENTORY (never a second custody claim); its `Stats.Pool` references
  `Server/ZiggfreedCommon/RollPools/AnvilWeaponPool.json` (global weapon-adjacent stats -
  `MMO_CritChance`/`MMO_CritMultiplier`/`MMO_Lifesteal`/`MMO_CooldownReduction`/`MMO_Luck`/
  `MMO_BonusXp`, matching the MMO's OWN `item.ItemEnhanceRoll` weapon-pool ranges exactly - note
  the REAL stat id is `MMO_CritChance`, not the design doc's placeholder `MMO_Crit_Chance`) with
  the maintainer-approved balance numbers, re-authored onto the scope-2 `Caps` shape (`Picks: 1-2`,
  `Unique: true`, `Caps.Budgets: [{Points: 30}, {PointsPer: 0.5, Factors:[stat
  MMO_Level_SMITHING]}]` - the EFFECTIVE budget is the MIN over the entries, so the flat 30 and the
  SMITHING-scaled 0.5-per-level compose exactly as the retired `PerItemBudget`/`SkillScaledBudget`
  pair did; `Caps.PerStat.MMO_CritChance: 10`); its
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
  `FaceBlock` from `Camera`, keeping only `Recipe: "LookRot"`.
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
its own in-game confirmation pass). `Camera.Recipe: "LookRot"` is unchanged. See the engine's own
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

## History (post-arc smoke fix round 1, 2026-07-28)

The maintainer's first post-arc smoke caught two regressions this pack participates in, both
closed this round (decisions 59-60 in the monorepo's `rpg-stations-extraction-design.md`):

- **The wave-2 Sawmill migration silently dropped Puppet + Custody.Display**: retiring the
  full-file `Stations/Sawmill.json` override for `Extensions/SawmillProgression.json` carried
  Loot/Xp deliberately, but NOTHING carried the `Puppet` group or `Custody.Display`
  (`ExtensionAsset` had no such keys), so the live sawmill regressed to a visible seat-mount
  with invisible placed logs. Restored per decision 59: the JAR's own `Sawmill.json` owns those
  presentation defaults now (this pack authors NO sawmill presentation), and RPG Stations'
  `ExtensionAsset` gained nullable `Puppet`/`Custody` overlay keys (recursive per-leaf merge) so
  a pack CAN re-skin presentation when it wants to. Migration lesson, recorded in decision 59:
  retiring a full-file override demands diffing the UNION of groups the override authored.
- **`SawmillProgression.json` regained the MMO-luck bonus-copy roll** (decision 59d,
  BOTH-STACK): wave 2 dropped the pack's `mmoskilltree:station_luck` bonus-copy Chance roll to
  keep the roll count at one; the maintainer ruled both stack, so the extension adds it back
  beside the jar's own tool_power-scaled roll (`SawmillLuckTiers.json`'s `$Comment` recorded the
  supersession; that file has since been SPLIT into the three concern-scoped Lootables in the
  layout above, and the bonus-copy roll itself was deleted by the pre-0.1.0 schema sweep below).
- **The anvil completion SFX de-doubled** (decision 60): the same
  `SFX_Chest_Legendary_FirstOpen_Player` was authored on BOTH the enhance `stamp` step's
  `Presentation` and the station-level `Completion`; both fired at round 8c too, but in the same
  frame - wave 2's 800ms stamp flourish pulled them apart and made the pair audible. The stamp
  step's `Sound` leaf is deleted (its sparks stay); the single bang lands at true completion
  with the summary HUD, and the convert loop's own end cue is untouched.

## Pre-release schema sweep (RPG Stations 0.1.0, this pack's content re-authored onto it)

RPG Stations' authoring schema was swept before 0.1.0 shipped, while a rename or removal was still
free. Every one of this pack's own assets moved onto the new shape in lockstep; an unrecognized key
would only ever have produced a boot-log `WARNING: Unused key(s)` line, never a load failure, but a
warning is not content working. What changed here:

- **`Recipe` -> `Recipes[]`.** The anvil's `Convert` action authors a one-element `Recipes` array.
  A recipe entry may now carry its OWN `Tool`, which whole-group-replaces the inherited gate for that
  entry only; the anvil needs no override, so both actions still share the one station-level hammer
  gate. Selection is "the first entry whose `Tool` gate passes AND whose inputs are available".
- **`Recipes[].Yield` owns output quantity end to end** - so the pack's MMO-luck **bonus-copy roll is
  DELETED** rather than re-pointed. `Grants.BonusOutputCopies` granted N copies of the WHOLE produced
  stack, which silently multiplied the jar sawmill's own 1-to-4-plank yield ladder from a different
  file; the `ExtensionAsset` payload matrix carries no `Recipes`/`Yield` key, so there is no additive
  route to re-express it as a yield overlay and it is gone outright. The pack's find ladder (then
  `SawmillLuckTiers.json`, since split into the three Lootables above) was untouched by the sweep,
  and progression still flows through
  `PerCycleContributions`.
- **`Tool.PowerScale` deleted** (with `StationCycleCompletedEvent.toolMultiplier()`), so this pack's
  `mmoskilltree:skill_xp` amounts are awarded at their authored value: station XP no longer scales
  with the held tool. A better hatchet is felt in PLANKS (the yield ladder) rather than in XP.
- **Key renames**, applied to every asset here: `AddFactors`/`Values` -> `Factors` (one name for the
  one weighted factor-term concept), `Grants.DropList` -> `DropLists[]`, `Presentation.Sound` ->
  `Sounds[]`, the station/action `Presentation` group -> `Cycle` (pairing with its `Completion`
  sibling), `Tool.MinDurabilityPercent` -> `Tool.Durability.MinStartPercent`,
  `Puppet.Look.Model.FallbackModelId` -> `Puppet.Look.FallbackModelId`.
- **Own-asset references are authored PascalCase now**, matching the referenced file's own name
  (`"Station": "Sawmill"`, `"Action": "PrepFish"`, `"Pool": "AnvilWeaponPool"`, action map keys
  `Convert`/`Enhance`, step ids `Strike1`/`Strike2`/`Settle`/`Stamp`). Matching stays
  case-insensitive, so this is readability, not a functional requirement. `Camera.Recipe` respells to
  `"LookRot"` for the same one-convention reason.
- **Deleted, so do not author them:** `Picker`/`Picker.ShowLocked`, `Camera.FaceBlock` (authoring
  `Camera.Recipe` at all IS the fixed-look opt-in now), `Camera.Mode` (replaced by
  `Camera.Enabled`), and the four reserved `Presentation` leaves (`Animation`, `AnimationItem`,
  `AnimationSlot`, `CameraEffect`).

## Action-first schema restructure (supersedes the sweep above)

A second, larger restructure landed on top of the sweep above, before this cycle's release: a
station's top-level groups STOPPED being per-action defaults, and `Recipes[]` (the sweep's own
list-of-recipes shape) was itself replaced. The station now supplies only four things -
`Identity`, `Block` (`{Exclusive}`), `Requires` (the station-entry gate, ANDed with an action's own),
and `Flairs` (the cosmetic lookup table) - and `Actions` is an ORDERED ARRAY of fully
self-contained action objects, not a keyed map: authored order IS selection priority, and every
group that used to live at station level or in a shared `Recipes` list now lives inside the ONE
action that needs it, duplicated verbatim wherever two actions need the same gate (the anvil's
`Convert`/`Enhance` share an identical `Tool` this way; see The Anvil section above). An action's
eight concerns, read top to bottom: `Select` (which held/placed material picks this action - the
renamed `Input` leaf; `Custody.Input`, a separate placement-acceptance matcher, is unaffected),
`Requires`/`Tool` (when it applies), `Recipe` (a SINGLE group now, `{Conversions?, FromCrafting?,
Yield?}` - `Recipes[]` is gone, one recipe per action, two transforms mean two actions), `Work`/
`Custody` (how the loop runs), `Anchors`/`Steps` (where it runs), `Bonus` (a `LootRef`: what ELSE a
cycle hands over, renamed from `Loot`) plus `ContributionScale` (a factor ladder PRE-SCALING every
`Work.PerCycleContributions` amount before the engine forwards it, replacing the deleted
`Tool.PowerScale`), `Worker` (grouping `Hold`/`Camera`/`Animation`/`Puppet` - "how the person looks
doing this") and `Moments` (grouping `Cycle`/`Completion` - "what it sounds and looks like, at two
times"). An `ExtensionAsset` now names the ACTION it extends via `Target: {Action: "<id>"}` rather
than the whole station (`Target: {Station}` is still legal, but only for appending a brand NEW
action to a station's ordered list); its Action-target payload keys are `Steps`, `Anchors`,
`Bonus`, `Conversions`, `PerCycleContributions`, `ContributionScale`, `Puppet`, `Custody` - all
directly on the extension, not nested under a `Work` group. `Roll.Grants.OutputItems` (ADDITIVE
items of the cycle's own primary output) is the one surviving route for a conditional yield bonus;
the old `Grants.BonusOutputCopies` (which multiplied the WHOLE produced stack) stays deleted. The
amount is **fractional**: the whole part is granted every time and the leftover fraction is the
chance of one more, so `1.5` pays one item always plus a second half the time and averages exactly
1.5. A whole number still behaves exactly as it always did, so this pack's own integer floors need
no change; author a fraction when a tier is worth half a step more than the one below it.

## How it fits together

- **A station is one `StationAsset` JSON + its block + its interaction.**
  `Server/RpgStations/Stations/<Name>.json` (filename lowercased = the station id) is decoded
  through RPG Stations' Pattern A codec. At STATION level: `Identity` (name/desc/icon), `Block`
  (`{Exclusive}` - one worker per placed block), `Requires` (permission + factor-condition gate,
  ANDed with the engaged action's own), `Flairs` (per-flair-id cosmetic overrides), and `Actions`
  (an ORDERED ARRAY - authored order is selection priority). Everything about HOW a job runs lives
  inside its own action entry: `Select` (which held/placed material picks it), `Tool` (the
  held-tool gate: `Tags`/`Gather`/`Ids` routes, plus a `Durability` wear gate/drain), `Recipe`
  (`Conversions`, whose `Input`/`Output` are `Ingredient` ARRAYS in the native `CraftingRecipe`
  shape, or a native-crafting-derived `FromCrafting`, plus the deterministic `Yield`), `Work`
  (cycle cadence, `PerCycleContributions[]` - opaque `{Channel, Param, Amount}` posts RPG Stations
  forwards verbatim on every completed cycle without resolving them itself, this pack's own
  `mmoskilltree:skill_xp` entries being one listening mod's convention, never engine vocabulary;
  optional `Idle` practice mode; and `Looping` - `false` ends the whole session after one program
  run), `Custody` (session-scoped placed-input custody - a state-dependent F places materials then
  works them, optionally `SingleFamily`-locked and rendered as a placed prop via `Display`; see the
  History section above and RPG Stations' `asset/CLAUDE.md`), `Anchors`/`Steps` (the multi-station
  seam and the authored step program), `Bonus` (a `LootRef`: `Lootables` references and/or inline
  `Rolls` - what ELSE a cycle hands over), `ContributionScale` (the factor ladder that PRE-SCALES
  `Work.PerCycleContributions`), `Worker` (grouping `Hold` - the movement-lock effect plus the
  `Mount` knob family; `Camera` - third-person pull plus a `Recipe` preset id; `Animation` - the
  looping work emote plus an optional per-swing `Swing` cadence; `Puppet` - the "hide the player,
  spawn a double performing the work" presentation), and `Moments` (grouping the per-cycle `Cycle`
  presentation and the session-end `Completion` presentation). See the RPG Stations mod's
  `station/CLAUDE.md` for the full engine-side behavior, and the MMO's
  `integration/stations/CLAUDE.md` for the bridge that reads the `mmoskilltree:skill_xp`
  Contribution channel (Param = skill id) into skill XP and supplies the
  `mmoskilltree:station_luck`/`skill_level`/`combat_level` Factor read channels.
  **Authoring tip:** every leaf carries `.documentation` in the codec, so the generated schema
  reference in RPG Stations' `docs-site/` and the in-game Asset Editor both describe each field,
  and the Editor offers pick lists for this mod's live station/action/lootable/roll-pool/factor ids
  plus every closed union discriminator. The content validator (`/rpgstations validate`) stays the
  backstop for hand-written JSON and is never replaced by either.
- **The Sawmill** (its single action, `Mill`) derives its conversions from every native
  `WoodPlanks`-category crafting recipe (`Recipe.FromCrafting: {"Categories":["WoodPlanks"]}`)
  instead of hand-authoring all 11 wood families - zero hardcoded conversions. Its yield is
  TOOL-DRIVEN rather than the plain Builders-bench 1:1: the jar's own `Sawmill.json` authors a
  `Recipe.Yield: {Base: 1}` with the tool-quality curve moved into `Bonus.Rolls` (a whole-part
  `Ladder` plus a chance-gated Iron-half roll) and mirrored in `ContributionScale`, running from
  one plank per log on a starter hatchet up to five with the jar's own drop-only trophy hatchet
  (four on the best forgeable tool), so this pack's value-add sits on
  top of a bench that already rewards tool progression - retune it there, or overlay it from here
  through an `ExtensionAsset` targeting `Target: {Action: "Mill"}`. Its held-tool gate matches any
  hatchet via the native `Gather` (Woods, functional) and `Tags` (Family: Hatchet) routes, and its
  better-tool reward is its own `Bonus.Rolls` ladder - the engine holds no baked tool curve over
  contributions on its own, `ContributionScale` PRE-SCALES the amount before the event fires, so
  this pack's `mmoskilltree:skill_xp` amounts are the verbatim amount to grant and a better hatchet
  is felt in both PLANKS and XP. Its `Bonus.Lootables` names **three** of this pack's own
  tables, one concern each, so a file's own `$Comment`s explain ONE score rather than three at once:

  - **`SawmillLuckFinds`** - the find-tier ladder, two BANDED Rolls over one shared five-factor
    score: `stat/MMO_Luck` 1.0, `stat/MMO_Luck_WOODCUTTING` 1.0, `stat/MMO_Luck_CRAFTING` 0.5,
    `stat/MMO_Level_WOODCUTTING` 0.5, `stat/MMO_Level_CRAFTING` 0.25. Two families, and within each
    the station's own skill counts full while the adjacent one counts half, mirroring the action's
    own 8.0/4.0 XP split - **re-tuning those two Amounts and re-tuning these weights are the same
    decision expressed twice, so move them together.** Band A is ungated (floors 50 -> T1, 100 ->
    T2), band B carries the file's ONE surviving level gate, `MMO_Level_WOODCUTTING` >= 30 (floors
    150 -> T3, 200 -> T4, 250 -> T5). Banding exists because Rolls evaluate INDEPENDENTLY: five
    separate tier Rolls handed a maxed player every tier at once, five drop tables per cycle, while
    two Ladders cap that at two and keep highest-wins inside each band.
  - **`SawmillOutputLadders`** - the two bonus-PLANK ladders, deliberately sharing no factors. One
    reads `stat/MMO_Level_WOODCUTTING` alone (`OutputItems` 1/1/2/3/4 at 25/50/75/100/125,
    highest-wins, non-cumulative), the other reads the luck channels alone (WC 1.0, CR 0.5, no level
    term, `OutputItems` 0.25/0.5/1.0/1.5/2.0 at 30/60/90/120/160). The luck ladder is the one that
    makes luck worth stacking at a bench that already pays for levels; its floors are sized against
    the ~179-point LUCK-ONLY ceiling and use deliberately different Mins from the find ladder so no
    one reads one score's threshold as another's. Its grants are FRACTIONAL on purpose (whole part
    always, fraction = chance of one more), the schema feature that makes early luck felt.
  - **`SawmillMasterworkBonus`** - the only Roll gated on the TOOL rather than the player, and it
    pays for WIELDING the trophy, never grants it: three ANDed `Conditions` on the Sawmiller's
    Hatchet's own axes (`hytale:tool_quality` 5, `hytale:tool_item_level` 50, `hytale:tool_power`
    0.55 through the Param-less form that reads the station's own gather type), no Ladder, and one
    `Chance` leaf (`Base` 5 plus `Weight` 0.1 per point of `MMO_Luck`/`MMO_Luck_WOODCUTTING`
    and 0.05 per point of `MMO_Luck_CRAFTING`, `Clamp.Max` 20) paying `Grants.DropLists`
    `MMO_Station_Sawmill_Masterwork` - a double byproduct pull plus a 2 percent Woodcutting XP
    boost token, and deliberately no planks and no essence (those are the other two tables' jobs).
    Levels are deliberately absent: it rewards what is in the worker's hands. It closes the loop
    with this pack's own trophy item override, whose +25 `MMO_Luck_WOODCUTTING` lifts this very roll
    from 5 to 7.5 percent. **It is named for what it pays, not for the trophy**, so it can never be
    misread as the chase - which is `SawmillTrophy`, below.

  **The fourth table is an ID OVERRIDE, not a `Bonus.Lootables` entry.** `SawmillTrophy.json` carries
  the id of a table the RPG Stations JAR already references from its own Sawmill's `Bonus`, and
  the shared lootable store folds by id, so folding it REPLACES the jar's version in place - the pack's
  chase runs where the jar's did, only one of the two can ever fire, and naming it in
  `SawmillProgression` as well would reference the same table twice. The jar's copy is a flat 1-in-2500
  with no factors (it cannot read MMO channels); this one is **1-in-3000 at its floor** (`Base`
  0.0333) rising by `Weight` 0.001 per point of `MMO_Luck` and `MMO_Luck_WOODCUTTING`, `Clamp.Max`
  0.25. Deliberately NOT `MMO_Luck_CRAFTING` (every other table here folds it at half weight; this
  one rewards the woodcutter specifically), and the trophy's own +25 never counts, since nobody holds
  it while chasing it. Odds against ~124 cycles per session: 1 in 3000 at zero luck (~1 per 24
  sessions), 1 in 1200 at 50, 1 in 762 at 98 (a finished WOODCUTTING tree, ~1 per 6 sessions); the cap
  lands at 217 points, beyond the tree alone, so it only ever bounds a heavily geared or modded source.
  **The jar splits its own Sawmill lootables one roll per file precisely so this override costs one
  small file** rather than a verbatim copy of its loyalty ladder - keep that shape when overriding.

  **The units trap, written into `SawmillLuckFinds`' own `$Comment` and repeated here:**
  `hytale:stat` returns the folded native MAX and the MMO luck channels store WHOLE PERCENT POINTS,
  so a full WOODCUTTING tree reads as **98**, not 0.98. The `mmoskilltree:station_luck` convenience
  aggregate computes the same sum but returns a FRACTION, so swapping the stat leaves for that one
  id shifts every floor by 100x and the ladder silently never fires again. The per-source channels
  are also the only composable route (independent weights) and avoid the double-count the MMO
  bridge's own hook warns about when the aggregate is mixed with any `stat/MMO_Luck*` leaf.
  Reachable ceilings at the time of authoring: ~179 luck-only (98 WOODCUTTING tree + 55.5 CRAFTING
  tree after its 0.5 weight + 25 trophy hatchet + a point or two of mastery loot multiplier; global
  `MMO_Luck` ships empty), ~94 levels-only, ~273 combined - which is what puts the 250 floor at the
  genuine end of the ladder rather than beyond it.

  **No table here can multiply the jar's yield.** A loot `Roll` only ever grants
  `Grants.OutputItems` (ADDITIVE items of the cycle's own output, fractional) or a
  `DropLists`/`Commands`/`Effects` reward, never a multiplier on a produced stack. A fully invested
  worker at the cap mills about eleven planks from one log (1 `Recipe.Yield` + up to 4 from the jar
  tool ladder + up to 4 level + up to 2 luck); a newcomer mills one. See the Action-first schema
  restructure section above.
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
5. **Bonus (optional)**: on the action, author `Bonus.Rolls` (inline, this pack's convention for a
   station-specific proc/ladder) or `Bonus.Lootables` (reference a
   `Server/ZiggfreedCommon/Lootables/<Name>.json` `LootableAsset` for a reusable table). `Chance`/
   `Conditions`/`Ladder`/`Grants` are independently composable per `Roll` - see `Sawmill.json`'s
   `Mill` action's `Bonus` block, or the shared library's `loot/Roll.java` javadoc for the full schema
   (`Factors` is always an array, a `Ladder` floor's only reward path is its own `Grants`, never a
   sibling `DropList` leaf, and
   `Grants.OutputItems` grants additive items of the cycle's own output rather than multiplying the
   produced stack - fractionally, so `1.5` means one item always plus a second half the time).

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

**A shipped `$Comment` is a TIP or an EXPLANATION for the server owner / pack author reading the
file, never a record of how it came to look this way.** These ship inside the zip. Write what the
asset DOES, what each number means in game, how to tune it, what to watch out for. NEVER write
authoring history or the decision behind it: no "X was removed/retired/renamed", no "this used to
live in Y", no "supersedes Z", no "we chose A over B", no reason-we-split-this-file narration.
**If a sentence would make no sense to someone opening the file for the first time with no memory
of any prior version, cut it.** Rationale for a rejected alternative belongs in the commit message
or the mod's `CHANGELOG.md`. Forward-looking guidance the reader can act on is welcome ("override
this file by id to re-tune the chase", "author a fraction for a half-step tier") - phrase it as
advice, not as a decision already taken. The root repo's `CommentHygieneTest` scans this pack and
fails the build on the catchable phrasings.

Filenames PascalCase (the asset key). Item + RootInteraction JSON keys start upper-case (Hytale
codec requirement). `StationAsset`/`Roll`/`LootableAsset` keys are PascalCase per RPG Stations'
Pattern A codec convention. See `bounty-contracts-pack/CLAUDE.md` for the shared native-asset-pack
conventions this pack follows.
