# MMO Skill Stations Pack

A standalone Hytale content pack that ships the **interactive work stations** content: the
**Sawmill**, a diegetic third-person work loop (press use and your character visibly saws, logs
turning into planks one cycle at a time) that grants passive Woodcutting + Crafting XP, scaled by
the held hatchet's power, and **Sawyer Marn**, the character in the Forgotten Temple who hands the
mill out and has work for whoever can feed one.

The MMO progression layered on top comes in five parts:

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
- **Sawyer Marn's work.** Seven quests, all offered and handed in at the temple: Timber Rights
  hands over the Sawmill; First Cut, Reading the Grain, Deep in the Wood and A Finer Edge each
  teach one thing the mill does and pay hatchets, boost tokens and XP; A Second Bench pays a
  second mill; Standing Order is a calendar daily paid from a ladder that grows with your
  Woodcutting level and luck. Eighteen achievements sit under a Stations category of their own,
  and the capstone, Sawmiller, pays the **Sawmiller's Crown**: a cosmetic flair that dresses every
  rare find and every finished session at the bench in gold crown particles.

Also the **Anvil**, a two-action station that sharpens vanilla metal bars (Convert) or runs a
hammering ritual that rolls stats onto a placed weapon (Enhance), granting Smithing XP. The Anvil
and its Smithing/Cooking skills are held back from the shipped zip in this release and live under
`unreleased/` (see `unreleased/README.md`); the table below lists them for when they return.

The station **engine** (work loop, camera/hold/mount/swing machinery, session-scoped placed-input
custody, the multi-action step engine, the conditional-lootable `Bonus` layer, the registered
`rpg_station_use` interaction type) ships in the standalone
[RPG Stations](https://github.com/arfemia/hytale-rpg-stations) mod. This pack's Sawmill BLOCK
carries the SAME id (`RPG_Station_Sawmill`) as RPG Stations' own jar-default block and overrides
it via pack load order (deliberately dropping the jar copy's crafting recipe - the bench is earned
through this pack's Timber Rights quest instead); the sawmill `StationAsset` itself stays the
jar's own, and this pack composes progression onto its `Mill` action additively through
`Server/RpgStations/Extensions/SawmillProgression.json`. RPG Stations also fires the two station
objective kinds the quests and achievements here count (`WORK_STATION`, one per real cycle, and
`STATION_OUTPUT`, one per stack the mill hands you) into the shared progression runtime itself. The
MMO Skill Tree bridge (a soft extension the MMO registers when it detects RPG Stations, no hard
coupling either direction) turns the work loop into skill XP, aggregated luck
(`mmoskilltree:station_luck`), mastery bonuses, and (for the Anvil's Enhance ritual) rolled item
stats via a registered `Stamper`. This pack is a **hard dependency** on BOTH mods, declared in
`manifest.json`; without RPG Stations installed, stations do not exist at all, and without the MMO
installed the Sawmill and Anvil still work (loot proc + tier ladder / the ritual's own durability
bonus) but grant no skill XP and roll no item stats.

## What is inside

| Path | What it is |
|------|------------|
| `Server/RpgStations/Extensions/SawmillProgression.json` | The Sawmill progression layer: an additive `ExtensionAsset` targeting the RPG Stations jar's own Sawmill `Mill` action - per-cycle Woodcutting/Crafting XP on the `mmoskilltree:skill_xp` channel plus the three add-on `Bonus.Lootables` references below |
| `Server/NPC/Roles/Passive/Mmo_Sawyer.json` | Sawyer Marn: a `Variant` of the MMO jar's quest-giver template, a Slothian villager with an iron hatchet in hand |
| `Server/ZiggfreedCommon/NpcPlacements/Mmo_Sawyer_Temple.json` | Where he stands: the Forgotten Temple, beside the merchant's marker across from the Mastery Trainer, gated on the stations feature, kept alive and respawned |
| `Server/ZiggfreedCommon/Dialogues/MMOSkillTree/Mmo_Sawyer.json` | His conversation: the first meeting, a screen per quest (offer, in progress, ready), what he says once you own a mill and once you have finished his chain, three help screens, and a different greeting when you walk up holding the Sawmiller's Hatchet |
| `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/*.json` | The seven quests, all his: `Timber_Rights` (chop timber, hand-cut planks, deliver; collect the Sawmill itself plus Woodcutting XP from the quest log), `First_Cut`, `Reading_The_Grain`, `Deep_In_The_Wood` (Woodcutting 30), `A_Finer_Edge` (the chain), `Second_Bench` (a side branch paying a second mill), `Standing_Order` (the daily). Everything the mill hands over is counted as station output from the Sawmill only |
| `Server/ZiggfreedCommon/Lootables/Mmo_Sawmill_Order.json` | What Standing Order pays: a ladder over Woodcutting level and luck (XP plus tree sap, the highest floor reached wins) and three independent chance rolls for life essence, a Woodcutting boost token and a concentrated essence |
| `Server/ZiggfreedCommon/AchievementCategories/MMOSkillTree/Stations.json` | The Stations achievement category (its Sawmill subcategory), sorted between Crafting and Leveling |
| `Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/*.json` | Eighteen achievements: three ladders (cycles worked, lumber milled, life essence found), every offcut kept, every wood species milled, concentrated essence, a hidden one for finding a boost token in the shavings, the hidden Sawmiller and the server-first First Sawmiller for the trophy hatchet, Standing Account for the daily, Master Sawyer for finishing the chain |
| `Server/RpgStations/Flairs/Sawmiller.json` | The Sawmiller's Crown: gold crown and spark particles on the Sawmill's rare finds and session ends, for a player who has claimed the Sawmiller achievement |
| `Server/Item/Items/RPG_Station_Sawmill.json` | The placeable Sawmill block (reuses the vanilla Lumbermill bench model; SHARED id with RPG Stations' jar default, overridden wholesale - this copy authors no crafting recipe, so acquisition goes through Timber Rights) |
| `unreleased/Server/RpgStations/Stations/Anvil.json` | HELD BACK: the Anvil's `StationAsset`, an ordered `Actions` array of two fully self-contained actions, `Convert` (sharpen a vanilla metal bar) and `Enhance` (the weapon-enhancement ritual, a `Stamp`-step program) |
| `unreleased/Server/ZiggfreedCommon/RollPools/AnvilWeaponPool.json` | HELD BACK: the weighted stat pool the Enhance ritual's `Stamp` step rolls from |
| `unreleased/Server/Item/Items/RPG_Station_Anvil.json` + `RootInteractions/RPG_Station_Anvil_Use.json` | HELD BACK: the Anvil block and its `{ "Type": "rpg_station_use", "Station": "anvil" }` interaction |
| `unreleased/Server/Item/Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json` (x10) | HELD BACK: the Anvil's Convert-action output, one per vanilla metal bar family, and the Enhance ritual's own `Stamp.Reagents` |
| `unreleased/Server/Item/ResourceTypes/MMO_Sharpened_Bar.json` | HELD BACK: the shared `ResourceType` family the ten Sharpened Bar items list themselves under (native pack-authorable asset, Icon-only) |
| `Server/Item/Items/RPG_Tool_Hatchet_Sawmiller.json` | The Sawmill's drop-only trophy hatchet (SHARED id with RPG Stations' own jar item, overridden wholesale) with this pack's MMO stat payload added: +10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck while held |
| `Server/Drops/MMO_Station_Sawmill_T1..T5.json` | The Sawmill's five find-tier drop tables. Each composes offcuts (fibre, bark, sap, sticks - pulled from RPG Stations' own shared byproduct list, more pulls as the tier rises) with its own life essence; T1 pays offcuts only, and T5 always pays |
| `Server/Drops/MMO_Station_Sawmill_Masterwork.json` | What the Sawmiller's Hatchet shakes loose: a double helping of offcuts plus a rare Woodcutting XP boost token |
| `Server/ZiggfreedCommon/Lootables/SawmillLuckFinds.json` | The five find tiers, as two banded Rolls over one score: your Woodcutting and Crafting luck (the station's own skill counting full, the adjacent one half) plus your levels in both at a lighter weight. T1-T2 are ungated; T3-T5 additionally require Woodcutting 30 |
| `Server/ZiggfreedCommon/Lootables/SawmillOutputLadders.json` | The two bonus-plank ladders: one paying for Woodcutting level (1/1/2/3/4 extra planks at level 25/50/75/100/125), one paying for luck alone (a quarter plank rising to two, so early luck arrives as a plank every few cycles rather than nothing) |
| `Server/ZiggfreedCommon/Lootables/SawmillMasterworkBonus.json` | The tool-gated Roll only the Sawmiller's Hatchet can open, paying the Masterwork table above for wielding it; its chance rises with your luck, which that hatchet itself grants |
| `Server/ZiggfreedCommon/Lootables/SawmillTrophy.json` | Replaces RPG Stations' own flat hatchet chase with a luck-scaled one: 1 in 3000 with no luck invested, improving to roughly 1 in 762 on a finished Woodcutting tree (base and Woodcutting luck only). The win is an item grant, so it is counted as station output and the Sawmiller achievements see it |
| `unreleased/Server/Emote/MMO_Emote_Hammer.json` | HELD BACK: the Anvil ritual's hammering emote |
| `unreleased/Server/RpgStations/Extensions/CookingProgression.json` + `MMOSkillTree/CustomSkills/Cooking.json` | HELD BACK: the Cooking progression layer (targets a station held back on the RPG Stations jar side, so the two repos restore together) |
| `unreleased/Server/MMOSkillTree/CustomSkills/Smithing.json` | HELD BACK: the SMITHING skill itself (a Pattern A `CustomSkillAsset` - Name/Description/Icon/Category/InsertAfter/Triggers/RequiresFeatures) |
| `Server/Languages/<locale>/items.lang` | Block name/description/state-dependent interaction hints, and the sharpened-bar item names, keyed `RPG_Station_Sawmill.*` / `RPG_Station_Anvil.*` / `MMO_Sharpened_<Metal>_Bar.*` (held-back content's keys deliberately stay shipped) |
| `Server/Languages/<locale>/npcs.lang` | Sawyer Marn's nameplate (`Mmo_Sawyer.name`, Hytale's own `npcs` namespace) |
| `Server/Languages/<locale>/avatarCustomization.lang` | The hammer emote's display name (Hytale's own `avatarCustomization` namespace) |
| `Server/Languages/<locale>/rpgstations.lang` | Per-key-additive overlay over RPG Stations' own file for pack-exclusive content (`station.anvil.name`/`.desc`; the Sawmill reuses RPG Stations' own shipped keys) |
| `Server/Languages/<locale>/mmoskilltree.lang` | Every quest title and flavor line, the "Mill N pieces of lumber" step line, every achievement title, description and announcement, the Stations category title, the Sawmiller's Crown name and every line of Marn's conversation, plus `skill.smithing`/`.desc` and `skill.cooking`/`.desc` for the held-back skills |

All 9 shipped locales are key-complete, held-back content included (an unreferenced lang key is
invisible at runtime, so the keys stay shipped rather than risking translation work). The
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
earn the Sawmill from Sawyer Marn in the Forgotten Temple through the Timber Rights quest (or
`/give` it as an admin), place it, and press use.

## Author your own station

A station is pure JSON, no plugin code:

1. **The station itself**: `Server/RpgStations/Stations/<Name>.json`, decoded through RPG
   Stations' `StationAsset` Pattern A codec (the filename, lowercased, is the station id). A
   station supplies only `Identity`/`Block`/`Requires`/`Flairs` plus an ORDERED `Actions` array -
   every self-contained action carries its own `Select`/`Tool`/`Recipe`/`Work`/`Custody`/`Bonus`/
   `ContributionScale`/`Worker` (grouping `Hold`/`Camera`/`Animation`/`Puppet`)/`Moments` (grouping
   `Cycle`/`Completion`), nothing is inherited from the station or from another action. See the
   RPG Stations jar's own `Sawmill.json` for a single-action station (its one action, `Mill`), or
   this repo's held-back `unreleased/Server/RpgStations/Stations/Anvil.json` for a
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
   `Bonus.Lootables` (a `Server/ZiggfreedCommon/Lootables/<Name>.json` `LootableAsset`) for conditional
   bonus loot - `Chance`/`Ladder`/`Grants`, independently composable. See the RPG Stations jar's
   own `Sawmill.json` `Mill` action's `Bonus` block for the shape (a tool-quality ladder, plus this
   pack's own `mmoskilltree`-luck ladders layered on top via `Extensions/SawmillProgression.json`).
5. **Quests and achievements for it (optional)**: a `WORK_STATION` step counts real cycles at a
   station (target = the station id), a `STATION_OUTPUT` step counts what it hands over (target =
   the item id, `Qualifier` = the station id to count that station alone). Both kinds are RPG
   Stations' own, so a pack ships nothing to make them count; this pack's
   `Quests/MMOSkillTree/Stations/` and `Achievements/MMOSkillTree/Stations/` folders are the worked
   example.

Add item name/description/hint keys to your pack's `Server/Languages/<locale>/items.lang`, and
give `Identity.NameKey`/`DescKey` a key in your own pack-authored `Server/Languages/<locale>/
rpgstations.lang` (per-key-additive over RPG Stations' own file, same namespace) or reuse RPG
Stations' `rpgstations.station.<id>.name`/`.desc` convention keys directly, as this pack's
`Sawmill.json` does, when your content matches the shipped default.

## Requires

RPG Stations 0.1.0 or newer, and MMO Skill Tree 1.6.0 or newer (for the skill-XP + luck bridge).
