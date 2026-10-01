# Changelog - MMO Skill Stations Pack

No em-dashes.

## [1.1.0] - unreleased

Held, not yet released. The second station, the Disenchanting Table, in both its tiers, and the
character who hands them out. RPG Stations 1.1.0 ships the tables themselves (the staged ritual
that unmakes one piece of gear, the vanilla salvage return, the Life Essence wage, the finds, the
disenchanter's kit and the Disenchanter's Grimoire) and runs them standalone with no skill XP;
this pack adds what Enchanting means at them, plus Enchanter Orrin and his work. The woodcutter's
kit also becomes a real gear set. Requires RPG Stations 1.1.0, ZiggfreedCommon 2.2.0 and MMO
Skill Tree 1.7.0, all declared in `manifest.json`.

- **Adds the Disenchanting Tables' MMO layer.** Every piece unmade at either table pays 30
  Enchanting XP and 15 Crafting XP (the station's own skill full, the neighbouring one half, the
  Sawmill's rule), multiplied by the piece itself: item level, quality, wear (a worn piece pays
  less) and stamped enhancement points (an enhanced piece pays more) feed one ladder, so a crude
  piece pays the base, an iron one 1.25 times it, the cobalt to adamantite band 1.5, a mithril
  piece 2 and an enhanced mithril piece 2.5. This is the first XP source the Enchanting skill has
  that needs no enchanting mod.
- **A trained enchanter works faster.** The Enchanting level shortens the ritual's paced beats on
  top of the table's own Disenchanting Proficiency, the two multiplying inside the table's own
  bounds, so a ritual still runs from 38 seconds untrained down to 15: level 100 alone brings one
  to about 26 seconds, the full disenchanter's kit on as well to about 19, and the Disenchanter's
  Grimoire in hand too to the 15-second floor.
- **Luck sizes the extra Life Essence.** On top of the table's own wage, Enchanting luck and
  global luck together pay up to 1 more essence for a crude piece, 2 for an iron one, 3 for the
  cobalt to adamantite band and 4 for mithril. The piece picks the band and luck decides how far
  up it you get; with no luck you draw exactly the table's wage. The Enchanting level stays out
  of this sum on purpose, since it already buys pace and salvage.
- **Now and then a little more of the salvage.** One extra unit of the return's main material,
  as a chance: a quarter of one at Enchanting 50, half at 100, and another quarter once luck
  reaches 45, on gear of item level 15 or more. Together they stay under one unit, so unmaking
  crafted gear always loses materials.
- **Luck makes the void finds likelier.** Void Essence on gear of item level 30 and up (1 percent,
  rising with luck to 6) and the Voidheart on item level 45 and up (a fifth of a percent, rising to
  0.8), on top of the table's own void rolls.
- **The disenchanter's kit and the trophy grimoire chase read luck.** The kit's four rolls start
  at 1.5 percent for the hood and the gloves, 1.25 for the leggings and 0.75 for the robe, and
  rise with luck to a ceiling each (the robe stays the rare one). The Disenchanter's Grimoire
  starts at the table's own 1 in 200 on gear of item level 20 and up, rising to 1.25 percent.
- **Adds Enchanting stats to the disenchanter's kit and the Disenchanter's Grimoire.** Each kit
  piece grants Enchanting luck and Enchanting XP while worn (8 luck and 4 percent XP on the hood,
  12 and 6 on the robe, 6 and 3 on the gloves, 10 and 5 on the leggings: 36 luck and 18 percent
  across the kit), so each piece found makes the next likelier. The grimoire grants 20
  Enchanting luck and 15 percent Enchanting XP while held. The kit's set bonus and its look stay
  RPG Stations' own.
- **The tables come from the questline.** With this pack installed neither table can be crafted:
  Enchanter Orrin hands over the lesser table, a second one on a side branch, and the greater
  table at the end of his unmaking chain.
- **Adds Orrin's Grimoire**, the book Orrin hands over at the end of his own questline: a working
  Uncommon spellbook on the brown grimoire art, a notch under the Disenchanter's Grimoire, granting
  10 Disenchanting Proficiency, 15 Enchanting luck and 10 percent Enchanting XP while held. Neither
  table will take it as input, so a book earned is never unmade by accident.
- **Adds Enchanter Orrin**, an Outlander priest who left the cult, standing in the Forgotten Temple
  with a grimoire in hand and a conversation of 44 screens. Sawyer Marn's conversation gains a
  question about the priest in the corner, and Marn offers the introduction.
- **Adds eighteen quests.** A Word with Orrin, the introduction Marn offers and Orrin settles; the
  unmaking chain, eight rungs from The Lesser Table (which pays the table) through First
  Unmaking, Three Kinds of Gear, The Essence Draw, The Scrap Heap, Mithril Unmade and Steady Hands
  to The Greater Table (which pays the greater table); A Second Table, a side branch paying a
  second lesser table; Orrin's own chain, The Cult's Cloth, A Thread of Void, Outlander Steel and
  The Voidheart, whose last rung asks for forty pieces unmade at the greater table and a Voidheart
  from anywhere and pays Orrin's Grimoire; Iron for the Mill, a crossover that has you unmake iron
  hatchets and carry the ore to Marn; and three repeatables, Unmaking Rites (a calendar daily),
  Loose Threads (every three hours, with its own roll for the disenchanter's kit) and A Week's
  Unmaking (weekly).
- **Adds thirty-two achievements** in a new Disenchanting subcategory of the Stations category:
  four ladders (pieces unmade at nine rungs from five to ten thousand, Life Essence drawn, Void
  Essence found and Voidhearts found at three each), First Piece, a weapon of every family, every
  armor slot, tools, mithril, the greater table, the full kit, the hidden Disenchanter and the
  hidden server-first First Disenchanter for the trophy grimoire, a habit count for each of the
  three repeatables, Master Disenchanter for the unmaking chain and Orrin's Own for his.
- **Adds nine bounty contracts** for the tables on the shared boards (two on the two-hour board,
  five daily, two weekly), self-contained like the Sawmill's.
- **Adds the Disenchanter's Halo**, a flair the Disenchanter achievement pays: a gold crown over
  every find at either table and over both tables' unmaking beat, gem sparks and green motes as a
  piece comes apart, and the void's own burst at a void find.
- **Adds the Woodcutter's Kit as a gear set.** The four leather pieces plus any one of the three
  hatchets (the Sawmiller's, the Millwright's or Marn's). Two pieces on add a little Woodcutting
  luck and XP; all four worn add more, with Crafting XP and a drift of gold sparks; all four with
  a hatchet in hand add the most, with a point of stamina. The tiers stack, and the Novice Cap is
  not a member. The four piece descriptions name the set.
- **Ships all of it in nine languages**: quests, achievements, bounties, Orrin's every line,
  Marn's new lines, the flair, the set and its tiers, and Orrin's Grimoire.

### Technical: the disenchanting layer

- `Server/RpgStations/Extensions/DisenchantingProgression.json` targets the scoped
  `{Station: Disenchanting_Table, Action: Disenchant}`; `DisenchantingGreaterProgression.json` is
  its `Parent` child and authors only `Target` (`{Station: Disenchanting_Table_Greater, Action:
  Disenchant_Greater}`), since an extension's additions never flow down a `Parent` chain and the
  greater table runs its own action. Payload: `PerCycleContributions` (ENCHANTING 30, CRAFTING 15
  on `mmoskilltree:skill_xp`), a `ContributionScale` over `hytale:item_level`,
  `hytale:item_quality`, `hytale:item_durability_percent` and `ziggfreedcommon:item_stamp_points`
  (floors 30/50/70/90 to 1.25/1.5/2/2.5), a `Pace.Ladder` over `MMO_Level_ENCHANTING` (0.92 at 20
  down to 0.55 at 125, multiplying the jar action's proficiency ladder under the action's own
  `Clamp`), and `Bonus.Lootables` naming the three tables the pack adds.
- `Server/ZiggfreedCommon/Lootables/`: `Mmo_Disenchant_Essence_Pay` (four gear bands by
  `hytale:item_level` and `hytale:item_quality`, each a luck `Ladder`, every roll `Expected`),
  `Mmo_Disenchant_Salvage_Extras` (fractional `rpgstations:output_items`, one level ladder and one
  luck ladder), `Mmo_Disenchant_Void_Finds` (`Cue:Void_Find`, `Cue:Voidheart`). Every luck term
  reads whole points of `MMO_Luck_ENCHANTING` plus `MMO_Luck` through `hytale:stat`, never the
  `mmoskilltree:station_luck` fraction.
- `Disenchant_Kit` and `DisenchantTrophy` carry the ids of the jar's own tables, which both jar
  actions already list, so they replace the jar's versions in place and are never listed in an
  extension's `Bonus.Lootables` (that would roll them twice). `Disenchant_Kit` stays luck-only (no
  item, station or tool `Conditions`) because quest Claims name it; the pack's own claim tables are
  `Mmo_Enchanter_Rites` (the daily) and `Mmo_Enchanter_Threads` (the three-hourly order).
- Same-id copies of seven jar items, each restating the jar's file in the jar's order: the two
  table blocks `RPG_Station_Disenchanting_Table` and `RPG_Station_Disenchanting_Table_Greater` (no
  `Recipe`, `Tags.Family` `MMOSkillTree`), the four kit pieces
  `RPG_Armor_Disenchanter_{Head,Chest,Hands,Legs}` and the trophy
  `RPG_Weapon_Spellbook_Grimoire_Disenchanter` (each adding only its `MMO_Luck_ENCHANTING` and
  `MMO_BonusXp_ENCHANTING` lines). The pack ships no set file for the kit: the jar's
  `RPG_Disenchanters_Kit` keeps the tiers and the look.
- `Server/Item/Items/MMO_Weapon_Spellbook_Grimoire_Orrin.json` (Uncommon, `MaxStack` 1, its stats
  in `Weapon.StatModifiers`). `Server/RpgStations/ProtectLists/Mmo_Disenchanting_Tables_Earned.json`
  protects it at both tables, scoped by `Stations`, beside the jar's `Disenchanting_Tables.json`;
  the name stays distinct, since a same-name file would replace the jar's whole list.
- Orrin: `NPC/Roles/Passive/Mmo_Enchanter.json` (a `Variant` of `Template_Mmo_QuestGiver`,
  `Appearance Outlander_Priest`, nameplate `npcs.Mmo_Enchanter.name`), the placement
  `NpcPlacements/Mmo_Enchanter_Temple.json` (a `WorldSpawn` anchor in `GameplayConfig
  ForgottenTemple`, gated on the `stations` feature, `KeepAlive` / `Respawn` / `Fortify`), the
  dialogue `Dialogues/MMOSkillTree/Mmo_Enchanter.json`, and Marn's `Mmo_Sawyer.json` gaining the
  `enchanter_intro` and `enchanter_brief` screens.
- Quests under `Quests/MMOSkillTree/Stations/Disenchanting/` on chains `disenchanting` (tiers 1-8)
  and `orrins_vow` (1-4); every unmaking step is `STATION_INPUT` with `Qualifier
  Disenchanting_Table` and `QualifierMatchMode PREFIX`, so it counts both tables (`the_voidheart`'s
  step alone is `EXACT` on the greater table). `Meet_The_Enchanter` is offered at Marn and turned
  in at Orrin; `Iron_For_The_Mill` is offered at Orrin and turned in at Marn.
- Achievements under `Achievements/MMOSkillTree/Stations/Disenchanting/`, subcategory
  `disenchanting` added to `AchievementCategories/MMOSkillTree/Stations.json`; chains
  `disenchanting_unmade`, `_essence`, `_void`, `_voidheart`. Bounties under
  `Bounties/MMOSkillTree/Stations/Bounty_*`. The flair `Server/RpgStations/Flairs/Disenchanter.json`
  (id `disenchanter`) dresses `Cue:Kit_Find`, `Cue:Void_Find`, `Cue:Voidheart`, `Cue:Trophy`,
  `Step:Disenchant:Unmake` and `Step:Disenchant_Greater:Unmake`; its Unmake entries name the jar's
  `RPG_Disenchant_Flash` first, since a flair's `Particles` list replaces the base list.
- `manifest.json`: `Ziggfreed:RpgStations >=1.1.0`, `Ziggfreed:ZiggfreedCommon >=2.2.0`,
  `Ziggfreed:MMOSkillTree ^1.7.0`.

### Technical: the woodcutter's kit set

- `Server/ZiggfreedCommon/GearSets/Mmo_Woodcutters_Kit.json`: members
  `MMO_Armor_Woodcutter_{Head,Chest,Hands,Legs}` plus `RPG_Tool_Hatchet_Sawmiller`,
  `MMO_Tool_Hatchet_Millwright` and `MMO_Tool_Hatchet_Marn`; tiers `{Pieces 2}`, `{Armor 4,
  Effect}` and `{Armor 4, Held 1}`, every entry `Additive`. The look is
  `Server/Entity/Effects/MMOSkillStationsPack/Woodcutters_Kit_Set.json` (`Infinite`,
  `OverlapBehavior Ignore`, gold `Block_Gem_Sparks`), dedicated to the set. Text keys
  `gearset.woodcutters_kit.*` in `mmoskilltree.lang`. The set id matches the Lootable
  `Mmo_Woodcutters_Kit` in another store, with no collision.

## [1.0.0] - 2026-09-12 (first release)

First public release, the Sawmill. This pack layers MMO Skill Tree progression onto the standalone
RPG Stations sawmill through the engine's generic contribution channels; it ships no engine code of
its own. Requires RPG Stations `>=1.0.0` and MMO Skill Tree `^1.6.1`, both declared in
`manifest.json`.

- **`Meet_The_Sawyer` names `Mmo_Sawyer` as its `CompletionDialogue`.** The introduction is collected at Marn (`TurnInAt`), and collecting a quest at a character hands off to the conversation it names; without one, pressing Collect left the player on the quest list. His conversation then walks its own Start ladder, and with the introduction settled the first job he can offer is `timber_rights`, so the player lands on `rights_offer` with the accept line in front of them. Nothing else moved: the hand-off only plays when the player is at a character, so collecting from the book out in the world still just pays.
- **All twelve quests name a `Listing.Icon`**, so each is drawn with a picture beside it wherever it is listed and on the notice when it finishes: `Tool_Hatchet_Crude` for the introduction, `RPG_Station_Sawmill` for the quest that hands the mill over, the copper and iron hatchets for the two quests that pay them, life essence for the two that are about it, sap and bark for the deliveries, redwood planks and a cobalt bar for the two Marn's Edge milling/errand rungs, the hatchet itself for the rung that pays it, and a decorative plank for Trim Work. Needs MMO Skill Tree 1.6.1, which carries the quest picture onto a finished-quest notice.
- **The pack's `rpgstations.lang` files carry only the pack-exclusive `station.anvil.*` pair in every locale.** The station keys the RPG Stations jar ships itself (`station.cuttingboard.*`, `station.cookingfire.*`, `action.prepfish.label`) are gone from the de-DE, fr-FR and it-IT files, so a key is defined once on a server and the boot log loses the three `has multiple definitions` warnings the Italian copies raised.
- **Adds the Sawmill progression layer** (`Server/RpgStations/Extensions/SawmillProgression.json`,
  an additive `ExtensionAsset` targeting the RPG Stations jar's own Sawmill `Mill` action): every
  completed cycle posts 8 Woodcutting XP and 4 Crafting XP on the `mmoskilltree:skill_xp` channel,
  pre-scaled by the jar action's own tool ladder so a better hatchet pays more of both. The jar's
  `Sawmill.json` stays the live station; this pack composes onto it and owns only what progression
  means at the bench.
- **Adds four conditional-loot tables** (`Server/ZiggfreedCommon/Lootables/`, one concern each):
  `SawmillLuckFinds` (the five find tiers, scored on Woodcutting and Crafting luck plus levels,
  the top three gated behind Woodcutting 30), `SawmillOutputLadders` (the two bonus-plank ladders,
  one for Woodcutting level and one for luck alone), `SawmillMasterworkBonus` (the tool-gated roll
  only the Sawmiller's Hatchet reaches), and `SawmillTrophy` (an id OVERRIDE of the jar's own
  hatchet-chase table, retuned to improve with invested Woodcutting luck).
- **The trophy hatchet is an item grant.** `SawmillTrophy` pays `RPG_Tool_Hatchet_Sawmiller`
  through `Grants.Items` (hotbar, then backpack, then the ground at the block when the bag is
  full), so the win is countable station output: the Sawmiller achievements below watch for it,
  and the `cue:trophy` fanfare plays only when the hatchet actually landed.
- **Adds the find-tier drop tables** (`Server/Drops/MMO_Station_Sawmill_T1..T5.json` plus
  `MMO_Station_Sawmill_Masterwork.json`): offcuts at every tier, life essence from the second tier,
  concentrated essence at the top, and the masterwork roll's double offcuts plus the occasional
  Woodcutting XP boost token.
- **Adds two same-id item overrides of the RPG Stations jar defaults**:
  `RPG_Station_Sawmill` (the bench block; this copy authors NO crafting recipe, so installing the
  pack removes the jar's standalone craftability and acquisition goes through the quest below) and
  `RPG_Tool_Hatchet_Sawmiller` (the trophy hatchet, carrying an MMO stat payload while held:
  +10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck).
- **Adds Sawyer Marn**, the pack's quest giver: `Server/NPC/Roles/Passive/Mmo_Sawyer.json` (a
  `Variant` of the MMO jar's `Template_Mmo_QuestGiver`: an elder Kweebec treesinger with an iron
  hatchet in hand, nameplate from `npcs.lang`), `Server/ZiggfreedCommon/NpcPlacements/Mmo_Sawyer_Temple.json`
  (standing in the Forgotten Temple beside the merchant's marker, across from the Mastery Trainer;
  gated on the `stations` feature, kept alive, respawned, fortified) and
  `Server/ZiggfreedCommon/Dialogues/MMOSkillTree/Mmo_Sawyer.json` (29 screens: a first meeting, a
  hail for a player sent down to introduce themselves, a screen per quest state across all eleven
  quests, three steady beats, three help screens plus a fourth about the woodcutter's kit, and a
  separate greeting for a player holding the Sawmiller's Hatchet). The MMO jar's guide points a
  temple visitor at him.
- **Adds A Word with Marn**, the introduction: the Adventurer's Guide offers it in the Forgotten
  Temple once the meeting down there is claimed, and it asks for nothing but crossing the landing
  and saying hello. It is taken from the Guide and finished at Marn (`TurnInAt`, so the Woodcutting
  experience it pays is collected from his own quest list, and the quest sits on nobody else's),
  which is what makes the sawmill read as somewhere the player is sent rather than a chain that
  appears on its own. Marn's first-meeting line credits it, and so does the hail behind that line
  for a player who had already wandered down and said hello. It needs the `stations` feature, so a
  server without the station engine never sees it.
- **Adds the twelve Sawmill quests** (`Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/`), every
  one offered by and handed in to Marn, every reward collected from the quest log: **Timber
  Rights** (open once the introduction is claimed; chop timber, hand-cut planks, deliver a share;
  pays the Sawmill itself plus Woodcutting XP), then the `sawmill` chain **First Cut**, **Reading
  the Grain**, **Deep in the Wood** (Woodcutting 20, one step under the level the last rung asks
  for) and **A Finer Edge** (Woodcutting 25; claiming it pays XP, one concentrated essence and the
  Woodcutter's Novice Cap, and opens both Marn's Edge and Trim Work below), the side branch **A
  Second Bench** (a second mill), and **Standing Order**, a calendar daily (planks and bark,
  refreshing at the day boundary) paid from `Lootables/Mmo_Sawmill_Order.json`, a ladder over
  Woodcutting level and luck with three independent chance rolls on top. Everything the mill hands
  over is counted through the `STATION_OUTPUT` kind, qualified to the Sawmill, and cycles through
  `WORK_STATION`; both are RPG Stations' own.
- **Adds Marn's Edge**, a three-rung questline on its own chain id (`marns_edge`, tiers 1-3), open
  once A Finer Edge is claimed: **Straight Grain** (mill and deliver plain stock for a haft),
  **Cold Metal** (bring seven cobalt bars from a furnace while the mill keeps running), and **The
  Fitting** (a long shift for life essence, then heavy leather and concentrated essence to bind
  the head), which pays `MMO_Tool_Hatchet_Marn` and is what the new Marn's Own achievement counts.
- **Adds Trim Work**, a short-cycle repeatable open once A Finer Edge is claimed, alongside Standing
  Order rather than replacing it: five steps mill the decorative and ornate cuts plus the fibre
  byproduct and deliver decorative planks and bark, paid from four Lootables, one concern each
  (`Mmo_Sawmill_Trim_Pay` the order's wage, `Mmo_Sawmill_Trim_Supply` tool and repair-kit upkeep,
  `Mmo_Sawmill_Trim_Finds` the occasional extra, and `Mmo_Woodcutters_Kit`, the only table anywhere
  that pays the four-piece woodcutter's kit).
- **Adds the level-picks-the-floor, luck-decides-the-quality paradigm to every table Trim Work
  pays from.** `Mmo_Sawmill_Trim_Pay` is a router: a Ladder over `MMO_Level_WOODCUTTING` alone
  (floors 0/25/55/85) whose floors carry nothing but a nested `Lootable` grant naming one of
  `Mmo_Sawmill_Trim_Wage_{Green,Hand,Sawyer,Master}`, and each of those runs its own Ladder over
  luck (floors 0/30/70/110) paying a widening XP range, essence and offcut pulls. Nesting a table
  inside a floor's grants is composition the engine allows four deep with a cycle guard, and a
  nested roll folds into the receipt so a toast still lists what it produced. Where a payout is a
  yes or a no rather than a quantity, luck weights the `Chance` instead: `Mmo_Sawmill_Trim_Finds`
  and all four `Mmo_Woodcutters_Kit` rolls. Luck acting on both axes inside one table would pay the
  same investment twice, which is why the tool rolls in `Mmo_Sawmill_Trim_Supply` stay flat beside
  its own luck Ladder. Every luck term reads `MMO_Luck_WOODCUTTING` and the global `MMO_Luck` at
  equal weight and deliberately not `MMO_Luck_CRAFTING`, the same call `SawmillTrophy` makes.
- **Adds `Drops/MMO_Station_Trim_Offcuts_T1..T4` and `Drops/MMO_Station_Trim_Saplings`.** A tier
  COMPOSES rather than lists: N pulls of the RPG Stations jar's shared
  `RPG_Station_Sawmill_Byproducts`, M pulls of the shared sapling list, and one small Choice for
  that tier's own flavour, a widening handful of fibre plus a torch or lantern from T2 up. A
  retune of what milling yields therefore moves every tier in both mods at once. The fibre Single
  is load-bearing as well as generous: a container tree built purely from Droplist references
  fails validation with "Container must have something to drop!".
- **Adds twenty-six achievements and the Stations category**
  (`Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/`,
  `AchievementCategories/MMOSkillTree/Stations.json` with a `sawmill` subcategory): three ladders
  (cycles worked and life essence found at three rungs each, lumber milled at nine, from 500
  pieces to ten million; each ladder announces at its third rung and the lumber one announces
  again at its ninth), Nothing Wasted, Every Grain, Distilled, the hidden Lucky Shavings, the
  hidden Sawmiller, the hidden server-first First Sawmiller, Standing Account, Master Sawyer, Trim
  Account (the Trim Work habit tracker) and Marn's Own (the Marn's Edge capstone, announces).
  Every award that names a skill pays Woodcutting and Crafting together at 2:1, the same ratio the
  bench itself pays per cycle (`SawmillProgression.json`, Woodcutting 8.0 / Crafting 4.0), so the
  two move together when either is re-tuned; the four that pay `ALL` are unchanged by that rule.
- **Adds the woodcutter's kit and Marn's Hatchet**: `MMO_Tool_Hatchet_Marn` (The Fitting's claim
  reward, a standalone Cobalt-pattern hatchet a notch under the pack's two other 0.55-power
  hatchets), the four-piece `MMO_Armor_Woodcutter_{Head,Chest,Hands,Legs}` set (paid only by
  `Mmo_Woodcutters_Kit.json`, worn together +33% Woodcutting XP / +23% Crafting XP / +43
  Woodcutting luck), and `MMO_Armor_Woodcutter_Novice_Head` (A Finer Edge's claim reward, a smaller
  taste of the kit's bonuses on plain wooden-helm art, not part of the four-piece set itself). None
  carry a `Parent` or a `Recipe`, so none can be crafted or salvaged, only earned.
- **Adds seven bounty contracts** (`Server/ZiggfreedCommon/Bounties/MMOSkillTree/Stations/`, a
  content type this pack did not ship before), hanging on the shared bounty pack's boards by id
  (two Bihourly, four Daily, one Weekly): each spells out its own objective and payout rather than
  inheriting a shared skeleton, so it loads with nothing installed but this pack, RPG Stations and
  the MMO. They ship here rather than from the bounty pack itself because a board draws its posted
  slots without reading a contract's own `Requires`, so a stations contract authored there would
  still be posted with RPG Stations absent and would only ever refuse at Accept.
- **Adds the Millwright's Hatchet** (`Server/Item/Items/MMO_Tool_Hatchet_Millwright.json`), the
  claim reward on `Sawmill_Lumber_T9` and the only achievement in the pack that pays an item. It
  is the earned counterpart to the luck-dropped Sawmiller's Hatchet: identical `Tool` block and
  `MaxDurability`, Epic rather than Legendary, an Onyxium head so the two are never confused in a
  hotbar, and a `Utility.StatModifiers` payload a notch under the trophy's (`Stamina` +5,
  `MMO_BonusXp_WOODCUTTING` +22, `MMO_Luck_WOODCUTTING` +22) plus a `MMO_BonusXp_CRAFTING` +12 the
  trophy does not carry. No flair, no `Recipe`, and no tool-gated roll of its own.
- **Adds the `sawmiller` flair** (`Server/RpgStations/Flairs/Sawmiller.json`, "Sawmiller's
  Crown"): gold crown and spark particles over the Sawmill's `Rare_Find` and `Completion` moments,
  granted by the Sawmiller achievement through ziggfreed-common's `Flair` reward kind.
- **Ships key-complete localization in all 9 locales** (`items.lang`, `rpgstations.lang`,
  `mmoskilltree.lang`, `avatarCustomization.lang`, `npcs.lang`): every quest and bounty title and
  flavor line, the mill-lumber step line, every achievement title, description and announcement,
  the category title, the flair name, every line of Marn's conversation, and the name and
  description of every item this pack ships outright.

**Release scope: the Sawmill only.** The Anvil (a two-action Convert/Enhance station with the
weapon-enhancement Stamp ritual), the `AnvilWeaponPool` roll pool, the Smithing and Cooking custom
skills, and the `CookingProgression` extension are finished but held back under `unreleased/`
(restorable in one command; see `unreleased/README.md`). Their lang keys stay shipped in all 9
locales. `CookingProgression` targets a station held back on the RPG Stations jar side, so the two
repos restore together.
