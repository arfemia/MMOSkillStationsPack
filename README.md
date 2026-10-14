# MMO Skill Stations Pack

A standalone Hytale content pack that ships the **interactive work stations** content: the
**Sawmill**, a diegetic third-person work loop (press use and your character visibly saws, logs
turning into planks one cycle at a time) that grants passive Woodcutting + Crafting XP, scaled by
the held hatchet's power, and **Sawyer Marn**, the character in the Forgotten Temple who hands the
mill out and has work for whoever can feed one. Since 1.1.0 it also carries the MMO layer of
the **Disenchanting Table** and the **Greater Disenchanting Table** (a long staged ritual unmakes
one piece of gear, three queued at the greater table, for Enchanting + Crafting XP, Essence of Life
and luck-weighted finds) and **Enchanter Orrin**, the turned Outlander priest who hands both tables
out.

The MMO progression layered on top comes in these parts:

- **Five find tiers**, scored on your Woodcutting and Crafting luck AND levels together (the top
  three additionally require Woodcutting 30). Every tier pays offcuts - Plant Fiber, Tree Bark, Tree Sap and
  sticks - and Essence of Life joins from the second tier up, with Greater Essence of Life at the top.
- **Two bonus-plank ladders**, one for Woodcutting level (at 25/50/75/100/125) and one for luck
  alone, so stacking luck is worth it at a bench that already rewards levels.
- **A luck-driven chase** for the sawmill's drop-only trophy tool, improving from 1 in 3000 to
  roughly 1 in 762 as you invest in Woodcutting luck.
- **A reward for wielding that trophy**, the **Sawmiller's Hatchet**: it carries an MMO stat
  payload while held (+10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck), and opens a
  tool-gated roll no other tool can, paying a double helping of offcuts plus the occasional
  Woodcutting XP boost token - its own luck bonus feeding the very roll it unlocks.
- **A hatchet for the ones the trophy never drops for**, the **Millwright's Hatchet**: the reward
  on the sixth rung of the lumber ladder, a hundred and fifty thousand pieces milled. It cuts and wears exactly like
  the trophy, and every stat sits a notch under it (+5 maximum stamina, +22% Woodcutting XP, +12%
  Crafting XP, +22 Woodcutting luck). No crown comes with it, and it opens no tool-gated roll.
- **Sawyer Marn's work.** Eleven quests, all offered and handed in at the temple: Timber Rights
  hands over the Sawmill; First Cut, Reading the Grain, Deep in the Wood and A Finer Edge each
  teach one thing the mill does and pay hatchets, boost tokens and XP; A Second Mill pays a
  second mill; Standing Order is a calendar daily paid from a ladder that grows with your
  Woodcutting level and luck. Once A Finer Edge is claimed, two more things open: **Trim Work**, a
  standing trim order that comes round several times a day and pays a wage, tool upkeep, occasional
  finds, and the only rolls anywhere for the four-piece **woodcutter's kit**; and **Marn's Edge**, a three-quest arc (Straight Grain, Cold
  Metal, The Fitting) that ends with a hatchet of Marn's own pattern. Twenty-six achievements sit
  under a Stations category of their own, and the capstone, Sawmiller, pays the **Sawmiller's
  Crown**: a cosmetic flair that dresses every rare find and every finished session at the bench in
  gold crown particles.
- **Seven bounty contracts** on the shared bounty board (two on the two-hour board, four daily, one
  weekly), self-contained so they load with nothing installed but this pack, RPG Stations and MMO
  Skill Tree, and posted only while the `stations` feature is on.
- **The woodcutter's kit is a gear set** (1.1.0): the four leather pieces plus any one of the three
  hatchets. Two pieces on add a little Woodcutting luck and XP, all four worn add more plus
  Crafting XP and a gold-spark look, and all four with a hatchet in hand add the most; the tiers
  stack, and the Novice Cap is not a member.

At the Disenchanting Tables (1.1.0):

- **Enchanting XP for unmaking gear**: 30 Enchanting and 15 Crafting XP per piece, scaled by the
  piece (item level, quality, wear and stamped enhancement) from 1x for crude gear to 2x for
  mithril and 2.5x for enhanced mithril. The first Enchanting XP source that needs no enchanting
  mod.
- **A trained enchanter works faster**: the ritual runs 34 seconds untrained here, and the
  Enchanting level shortens it on top of the table's own Disenchanting Proficiency, down to a
  15-second floor (about 21 seconds at level 100 alone, about 19 with the full kit alone, the floor
  at level 100 with the full kit on).
- **Luck sizes the extra Essence of Life** (up to 1 more for crude gear, 2 for iron, 3 for cobalt to
  adamantite, 4 for mithril), and the Enchanting level and luck each pay a chance of a little
  more of the salvage, never a whole extra unit.
- **Luck makes the finds likelier**: Essence of the Void from item level 30, the Voidheart from 45, the
  four-piece disenchanter's kit and the Disenchanter's Grimoire. The kit pieces (36 Enchanting luck
  and 18% Enchanting XP across the four) and the grimoire (20 luck, 15% XP while held) grant
  Enchanting luck themselves.
- **Enchanter Orrin's work**: eighteen quests (an introduction the Adventurer's Guide offers in the
  temple, which Marn can also hand out, an eight-rung
  unmaking chain that hands over both tables, a side branch paying a second lesser table, Orrin's
  own four-rung chain ending in **Orrin's Grimoire**, a crossover carrying iron to Marn, a daily, a
  three-hourly order and a weekly), thirty-two achievements in a Disenchanting subcategory, nine
  bounty contracts, the **Disenchanter's Halo** flair, and **Orrin's Shelf**, which sells the
  Wooden Earth Wand and the Tribal Blowgun for Essence of Life: nothing else hands a player either
  one, and Every Blade wants both unmade. With this pack installed neither table can be crafted:
  the questline hands them out.

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
`Server/RpgStations/Extensions/SawmillProgression.json`. The Disenchanting Tables follow the same
split: the two table blocks are same-id copies with no recipe, the stations and their actions stay
the jar's, and `Extensions/DisenchantingProgression.json` (plus its greater-table child) adds the
progression. RPG Stations also fires the three station objective kinds the quests and achievements
here count (`WORK_STATION`, one per real cycle, `STATION_OUTPUT`, one per stack a station hands
you, and `STATION_INPUT`, one per piece a station consumes) into the shared progression runtime
itself. The
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
| `Server/NPC/Roles/Passive/Mmo_Sawyer.json` | Sawyer Marn: a `Variant` of the MMO jar's quest-giver template, an elder Kweebec treesinger with an iron hatchet in hand |
| `Server/ZiggfreedCommon/NpcPlacements/Mmo_Sawyer_Temple.json` | Where he stands: the Forgotten Temple, beside the merchant's marker across from the Mastery Trainer, gated on the stations feature, kept alive and respawned |
| `Server/ZiggfreedCommon/Dialogues/MMOSkillTree/Mmo_Sawyer.json` | His conversation (32 screens): the first meeting, a line sending you to the guide if you ask him for work before the guide has introduced you, a screen per quest across all eleven (offer, in progress, ready), what he says once you own a mill, once you have finished the sawmill chain and once you have finished Marn's Edge, three help screens plus a fourth about the woodcutter's kit, and a different greeting when you walk up holding the Sawmiller's Hatchet |
| `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/*.json` | The twelve quests: eleven Marn offers himself, plus `Meet_The_Sawyer`, the introduction the Adventurer's Guide hands out and Marn settles. `Meet_The_Sawyer` (the introduction), `Timber_Rights` (chop timber, hand-cut planks, deliver; collect the Sawmill itself plus Woodcutting XP from the quest log), `First_Cut`, `Reading_The_Grain`, `Deep_In_The_Wood` (Woodcutting 20), `A_Finer_Edge` (the sawmill chain's last rung, Woodcutting 25, opens Marn's Edge and Trim Work), `Second_Bench` (a side branch paying a second mill), `Standing_Order` (the daily); then `Straight_Grain`, `Cold_Metal`, `The_Fitting` (Marn's Edge, paying Marn's own hatchet), and `Trim_Work` (a short-cycle repeatable). Everything the mill hands over is counted as station output from the Sawmill only |
| `Server/ZiggfreedCommon/Bounties/MMOSkillTree/Stations/*.json` | Seven bounty contracts on the shared bounty board, self-contained (no Parent, since the skeleton a bounty pack contract would inherit may not be installed): two on the two-hour board, four daily, one weekly; the daily and weekly ones pay `bounty_token` plus Woodcutting XP, the two quick ones Woodcutting XP alone |
| `Server/ZiggfreedCommon/Lootables/Mmo_Sawmill_Order.json` | What Standing Order pays: a ladder over Woodcutting level and luck (XP plus tree sap, the highest floor reached wins) and three independent chance rolls for Essence of Life, a Woodcutting boost token and a Greater Essence of Life |
| `Server/ZiggfreedCommon/Lootables/Mmo_Sawmill_Trim_Pay.json`, `_Trim_Supply.json`, `_Trim_Finds.json`, `Mmo_Woodcutters_Kit.json` | What Trim Work pays, one concern per table: the order's wage (a ladder over Woodcutting level and luck), tool and repair-kit upkeep (level alone), the occasional extra find, and the only rolls anywhere for the four-piece woodcutter's kit |
| `Server/ZiggfreedCommon/AchievementCategories/MMOSkillTree/Stations.json` | The Stations achievement category (its Sawmill subcategory), sorted between Crafting and Leveling |
| `Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/*.json` | Twenty-six achievements: three ladders (cycles worked, Essence of Life found, and lumber milled, which runs nine rungs from five hundred pieces to six hundred thousand and pays the Millwright's Hatchet on the sixth), every offcut kept, every wood species milled, Greater Essence of Life, a hidden one for finding a boost token in the shavings, the hidden Sawmiller and the server-first First Sawmiller for the trophy hatchet (a feat: no points, and it pays the First Sawmiller title), Standing Account for keeping the daily up, Master Sawyer for finishing the sawmill chain, Trim Account for keeping the trim order filled, and Marn's Own for finishing Marn's Edge |
| `Server/RpgStations/Flairs/Sawmiller.json` | The Sawmiller's Crown: gold crown and spark particles on the Sawmill's rare finds and session ends, for a player who has claimed the Sawmiller achievement |
| `Server/Item/Items/MMO_Tool_Hatchet_Millwright.json` | The Millwright's Hatchet, the hatchet you earn rather than find: Onyxium head, Epic, the same cut and wear as the trophy with every stat a notch under it and no flair. Handed over by the sixth rung of the lumber ladder |
| `Server/Item/Items/MMO_Tool_Hatchet_Marn.json` | Marn's Hatchet, the reward for finishing Marn's Edge: a Cobalt-pattern hatchet, Rare, a notch under the trophy and the Millwright's hatchet on purpose |
| `Server/Item/Items/MMO_Armor_Woodcutter_{Head,Chest,Hands,Legs}.json` | The woodcutter's kit: four Uncommon leather pieces paid only by Trim Work's own table, nothing crafts or sells them |
| `Server/Item/Items/MMO_Armor_Woodcutter_Novice_Head.json` | The Woodcutter's Novice Cap, the graduation piece A Finer Edge hands over; a smaller taste of the kit's bonuses, not part of the kit itself |
| `Server/Item/Items/RPG_Station_Sawmill.json` | The placeable Sawmill block (reuses the vanilla Lumbermill bench model; SHARED id with RPG Stations' jar default, overridden wholesale - this copy authors no crafting recipe, so acquisition goes through Timber Rights) |
| `unreleased/Server/RpgStations/Stations/Anvil.json` | HELD BACK: the Anvil's `StationAsset`, an ordered `Actions` array of two fully self-contained actions, `Convert` (sharpen a vanilla metal bar) and `Enhance` (the weapon-enhancement ritual, a `Stamp`-step program) |
| `unreleased/Server/ZiggfreedCommon/RollPools/AnvilWeaponPool.json` | HELD BACK: the weighted stat pool the Enhance ritual's `Stamp` step rolls from |
| `unreleased/Server/Item/Items/RPG_Station_Anvil.json` + `RootInteractions/RPG_Station_Anvil_Use.json` | HELD BACK: the Anvil block and its `{ "Type": "rpg_station_use", "Station": "anvil" }` interaction |
| `unreleased/Server/Item/Items/Ingredient/MMO_Sharpened_<Metal>_Bar.json` (x10) | HELD BACK: the Anvil's Convert-action output, one per vanilla metal bar family, and the Enhance ritual's own `Stamp.Reagents` |
| `unreleased/Server/Item/ResourceTypes/MMO_Sharpened_Bar.json` | HELD BACK: the shared `ResourceType` family the ten Sharpened Bar items list themselves under (native pack-authorable asset, Icon-only) |
| `Server/Item/Items/RPG_Tool_Hatchet_Sawmiller.json` | The Sawmill's drop-only trophy hatchet (SHARED id with RPG Stations' own jar item, overridden wholesale) with this pack's MMO stat payload added: +10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck while held |
| `Server/Drops/MMO_Station_Sawmill_T1..T5.json` | The Sawmill's five find-tier drop tables. Each composes offcuts (Plant Fiber, Tree Bark, Tree Sap, sticks - pulled from RPG Stations' own shared byproduct list, more pulls as the tier rises) with its own Essence of Life; T1 pays offcuts only, and T5 always pays |
| `Server/Drops/MMO_Station_Sawmill_Masterwork.json` | What the Sawmiller's Hatchet shakes loose: a double helping of offcuts plus a rare Woodcutting XP boost token |
| `Server/ZiggfreedCommon/Lootables/SawmillLuckFinds.json` | The five find tiers, as two banded Rolls over one score: your Woodcutting and Crafting luck (the station's own skill counting full, the adjacent one half) plus your levels in both at a lighter weight. T1-T2 are ungated; T3-T5 additionally require Woodcutting 30 |
| `Server/ZiggfreedCommon/Lootables/SawmillOutputLadders.json` | The two bonus-plank ladders: one paying for Woodcutting level (1/1/2/3/4 extra planks at level 25/50/75/100/125), one paying for luck alone (a quarter plank rising to two, so early luck arrives as a plank every few cycles rather than nothing) |
| `Server/ZiggfreedCommon/Lootables/SawmillMasterworkBonus.json` | The tool-gated Roll only the Sawmiller's Hatchet can open, paying the Masterwork table above for wielding it; its chance rises with your luck, which that hatchet itself grants |
| `Server/ZiggfreedCommon/Lootables/SawmillTrophy.json` | Replaces RPG Stations' own flat hatchet chase with a luck-scaled one: 1 in 3000 with no luck invested, improving to roughly 1 in 762 on a finished Woodcutting tree (base and Woodcutting luck only). The win is an item grant, so it is counted as station output and the Sawmiller achievements see it |
| `unreleased/Server/Emote/MMO_Emote_Hammer.json` | HELD BACK: the Anvil ritual's hammering emote |
| `unreleased/Server/RpgStations/Extensions/CookingProgression.json` + `MMOSkillTree/CustomSkills/Cooking.json` | HELD BACK: the Cooking progression layer (targets a station held back on the RPG Stations jar side, so the two repos restore together) |
| `unreleased/Server/MMOSkillTree/CustomSkills/Smithing.json` | HELD BACK: the SMITHING skill itself (a Pattern A `CustomSkillAsset` - Name/Description/Icon/Category/InsertAfter/Triggers/RequiresFeatures) |
| `Server/RpgStations/Extensions/DisenchantingProgression.json`, `DisenchantingGreaterProgression.json` | The Disenchanting Tables' progression layer (1.1.0): Enchanting + Crafting XP per piece unmade, scaled by the piece, the ritual's length here (a 2.5 stretch on the paced beats and a 15-second floor) with a pace ladder over the Enchanting level, and the three add-on tables below. The greater file is a `Parent` child that changes only its target |
| `Server/RpgStations/Extensions/DisenchantingProficiency.json`, `DisenchantingGreaterProficiency.json` | A gentler ladder over the disenchanter's gear (the Disenchanting Proficiency stat) that multiplies RPG Stations' own, since the Enchanting level does much of the speeding up here. The greater file is a `Parent` child that changes only its target |
| `Server/ZiggfreedCommon/Lootables/Mmo_Disenchant_Essence_Pay.json`, `_Salvage_Extras.json`, `_Void_Finds.json` | Extra Essence of Life sized by luck within the piece's band, the occasional extra unit of salvage, and the luck-weighted Essence of the Void and Voidheart finds |
| `Server/ZiggfreedCommon/Lootables/Disenchant_Kit.json`, `DisenchantTrophy.json` | Same-id replacements of RPG Stations' own kit and grimoire tables, luck-weighted |
| `Server/ZiggfreedCommon/Lootables/Mmo_Enchanter_Rites.json`, `Mmo_Enchanter_Threads.json` | What Orrin's daily and three-hourly order pay when you collect them |
| `Server/Item/Items/RPG_Station_Disenchanting_Table.json`, `RPG_Station_Disenchanting_Table_Greater.json` | The two table blocks (SHARED ids with RPG Stations' own, overridden wholesale with no crafting recipe, so the questline hands them out) |
| `Server/Item/Items/RPG_Armor_Disenchanter_{Head,Chest,Hands,Legs}.json`, `RPG_Weapon_Spellbook_Grimoire_Disenchanter.json` | The disenchanter's kit and the Disenchanter's Grimoire (SHARED ids with RPG Stations' own), each adding Enchanting luck and Enchanting XP to the jar item |
| `Server/Item/Items/MMO_Weapon_Spellbook_Grimoire_Orrin.json` | Orrin's Grimoire, the Uncommon spellbook his own questline ends with |
| `Server/RpgStations/ProtectLists/Mmo_Disenchanting_Tables_Earned.json` | Keeps Orrin's Grimoire off both tables, beside RPG Stations' own list |
| `Server/NPC/Roles/Passive/Mmo_Enchanter.json`, `Server/ZiggfreedCommon/NpcPlacements/Mmo_Enchanter_Temple.json`, `Server/ZiggfreedCommon/Dialogues/MMOSkillTree/Mmo_Enchanter.json` | Enchanter Orrin: an Outlander priest with a grimoire in hand, where he stands in the Forgotten Temple (beside Sawyer Marn, on the merchant's marker), and his conversation (46 screens) |
| `Server/ZiggfreedCommon/Shops/MMOSkillTree/Mmo_Enchanter.json`, `Server/ZiggfreedCommon/ShopEntries/MMOSkillTree/Mmo_Enchanter_Offer_{Wand,Blowgun}.json` | Orrin's Shelf, the storefront his conversation opens once The Lesser Table is claimed (in the Forgotten Temple only, and gone with the stations feature), and its two offers: the game's Wooden Earth Wand and Tribal Blowgun for Essence of Life taken from the bag, the only player source of either |
| `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/Disenchanting/*.json` | Orrin's eighteen quests: seventeen he offers himself (Iron for the Mill hands in at Marn), plus `Meet_The_Enchanter`, the introduction the Adventurer's Guide hands out and Orrin settles |
| `Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/Disenchanting/*.json` | Thirty-two achievements in the Stations category's Disenchanting subcategory; Every Blade asks for a weapon of fifteen families (the tribal claws and the guns have no player source, so they are left out); the server-first First Disenchanter is a feat (no points) paying the First Disenchanter title |
| `Server/ZiggfreedCommon/Titles/MMOSkillTree/First_Sawmiller.json`, `First_Disenchanter.json` | The two titles the server-first feats pay, named by `title.first_sawmiller.*` and `title.first_disenchanter.*` |
| `Server/ZiggfreedCommon/Bounties/MMOSkillTree/Stations/Bounty_*.json` | Nine bounty contracts for the tables beside the seven for the mill (two on the two-hour board, five daily, two weekly) |
| `Server/RpgStations/Flairs/Disenchanter.json` | The Disenchanter's Halo, on every find and both tables' unmaking beat |
| `Server/ZiggfreedCommon/GearSets/Mmo_Woodcutters_Kit.json`, `Server/Entity/Effects/MMOSkillStationsPack/Woodcutters_Kit_Set.json` | The woodcutter's kit as a gear set (three stacking tiers) and its gold-spark look |
| `Server/Languages/<locale>/items.lang` | Block name/description/state-dependent interaction hints, the sharpened-bar item names (`RPG_Station_Anvil.*` / `MMO_Sharpened_<Metal>_Bar.*`, held-back content's keys deliberately stay shipped), and the name/description of every item this pack ships outright: the Millwright's Hatchet, Marn's Hatchet, the woodcutter's kit (each of the four descriptions names the Woodcutter's Kit set), its Novice Cap and Orrin's Grimoire |
| `Server/Languages/<locale>/npcs.lang` | Sawyer Marn's and Enchanter Orrin's nameplates (`Mmo_Sawyer.name`, `Mmo_Enchanter.name`, Hytale's own `npcs` namespace) |
| `Server/Languages/<locale>/avatarCustomization.lang` | The hammer emote's display name (Hytale's own `avatarCustomization` namespace) |
| `Server/Languages/<locale>/rpgstations.lang` | Per-key-additive overlay over RPG Stations' own file for pack-exclusive content (`station.anvil.name`/`.desc`; the Sawmill reuses RPG Stations' own shipped keys) |
| `Server/Languages/<locale>/mmoskilltree.lang` | Every quest and bounty title and flavor line (Orrin's questline included), the sawing, milling, essence and unmaking step lines, every achievement title, description and announcement, the two server-first titles, the Stations category and its Disenchanting subcategory titles, the Sawmiller's Crown and Disenchanter's Halo names, every line of Marn's and Orrin's conversations, the name and line of Orrin's Shelf (`shop.mmo_enchanter.*`), the Woodcutter's Kit set title and tier lines (`gearset.woodcutters_kit.*`), plus `skill.smithing`/`.desc` and `skill.cooking`/`.desc` for the held-back skills |

All 9 shipped locales are key-complete, held-back content included (an unreferenced lang key is
invisible at runtime, so the keys stay shipped rather than risking translation work). The
Sawmill's display name/desc (`Identity.NameKey`/`DescKey`) point at
`rpgstations.station.sawmill.name`/`.desc`, the keys RPG Stations itself ships (`rpgstations.lang`)
- this pack reuses them rather than duplicating the translation.

## For server owners

Everything the store page says an owner can retune is plain content in the zip, at these paths:

- Find tiers, their thresholds, and which level opens the deep ones:
  `Server/ZiggfreedCommon/Lootables/SawmillLuckFinds.json`
- What a find hands over: `Server/Drops/`. The offcut mix is shared with RPG Stations' own tables,
  so one edit changes it across the whole bench.
- The two plank ladders, one for levels and one for luck:
  `Server/ZiggfreedCommon/Lootables/SawmillOutputLadders.json`
- Trophy chase odds: `Server/ZiggfreedCommon/Lootables/SawmillTrophy.json`
- XP per cycle: `Server/RpgStations/Extensions/SawmillProgression.json`
- Marn's quests and what they pay: `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/`.
  Standing Order's whole payout is one table, `Server/ZiggfreedCommon/Lootables/Mmo_Sawmill_Order.json`;
  Trim Work's is four, one concern each, alongside it: `Mmo_Sawmill_Trim_Pay.json`,
  `_Trim_Supply.json`, `_Trim_Finds.json` and `Mmo_Woodcutters_Kit.json`.
- The achievements and their points: `Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/`
- The bounty contracts and their pay: `Server/ZiggfreedCommon/Bounties/MMOSkillTree/Stations/`
- The disenchanting tables' XP, how long a ritual runs and how much the Enchanting level speeds it:
  `Server/RpgStations/Extensions/DisenchantingProgression.json` (the greater table's file is a
  `Parent` child of it that changes only its target; author a leaf there to tune the two apart).
  How much the disenchanter's gear speeds it: `DisenchantingProficiency.json` beside it, with its
  own greater-table child.
  Their extra essence and salvage, the void finds and the kit and grimoire odds:
  `Server/ZiggfreedCommon/Lootables/` (`Mmo_Disenchant_Essence_Pay.json`, `_Salvage_Extras.json`,
  `_Void_Finds.json`, `Disenchant_Kit.json`, `DisenchantTrophy.json`)
- Orrin's quests: `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/Disenchanting/`, with his
  daily and three-hourly payouts in `Mmo_Enchanter_Rites.json` and `Mmo_Enchanter_Threads.json`
  beside the other lootables. The woodcutter's kit set and its tiers:
  `Server/ZiggfreedCommon/GearSets/Mmo_Woodcutters_Kit.json`
- Orrin's Shelf, what it sells and the price: one file per offer,
  `Server/ZiggfreedCommon/ShopEntries/MMOSkillTree/Mmo_Enchanter_Offer_*.json`; where the shelf
  opens and when it hides: `Server/ZiggfreedCommon/Shops/MMOSkillTree/Mmo_Enchanter.json`
- Take Marn or Orrin out without editing the pack: `/mmonpc disable --arg1=Mmo_Sawyer_Temple` (or
  `Mmo_Enchanter_Temple`), or the same switch by hand in `mods/ziggfreedcommon/npc-placements.json`:
  `{"Mmo_Sawyer_Temple": {"enabled": false}}`. Their quests hide with the stations feature, so
  nothing dangles if RPG Stations is switched off.

## Build

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
```

Produces `MMOSkillStationsPack-1.1.2.zip` (forward-slash entries plus explicit directory entries, which
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
   `SCHEMA.md` (every field of every type) and its `docs/your-first-station.md` walkthrough for the full authoring reference.
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
   station (target = the station id), a `STATION_OUTPUT` step counts what it hands over and a
   `STATION_INPUT` step what it consumes (target = the item id, `Qualifier` = the station id to
   count that station alone; `QualifierMatchMode PREFIX` with `Disenchanting_Table` counts both
   tables). All three kinds are RPG Stations' own, so a pack ships nothing to make them count; this pack's
   `Quests/MMOSkillTree/Stations/` and `Achievements/MMOSkillTree/Stations/` folders are the worked
   example.

Add item name/description/hint keys to your pack's `Server/Languages/<locale>/items.lang`, and
give `Identity.NameKey`/`DescKey` a key in your own pack-authored `Server/Languages/<locale>/
rpgstations.lang` (per-key-additive over RPG Stations' own file, same namespace) or reuse RPG
Stations' `rpgstations.station.<id>.name`/`.desc` convention keys directly, as this pack's
`Sawmill.json` does, when your content matches the shipped default.

## Requires

A Hytale Update 7 server, RPG Stations 1.1.1 or newer, ZiggfreedCommon 2.3.0 or newer (the gear-set
store), and MMO Skill Tree 1.7.1 or newer (for the skill-XP + luck bridge and the `STATION_INPUT`
quests).
