# Changelog - MMO Skill Stations Pack

No em-dashes.

## [0.1.0] (first release)

First public release, the Sawmill. This pack layers MMO Skill Tree progression onto the standalone
RPG Stations sawmill through the engine's generic contribution channels; it ships no engine code of
its own. Requires RPG Stations `>=0.1.0` and MMO Skill Tree `^1.6.0`, both declared in
`manifest.json`.

- **`Meet_The_Sawyer` names `Mmo_Sawyer` as its `CompletionDialogue`.** The introduction is collected at Marn (`TurnInAt`), and collecting a quest at a character hands off to the conversation it names; without one, pressing Collect left the player on the quest list. His conversation then walks its own Start ladder, and with the introduction settled the first job he can offer is `timber_rights`, so the player lands on `rights_offer` with the accept line in front of them. Nothing else moved: the hand-off only plays when the player is at a character, so collecting from the book out in the world still just pays.
- **All eight quests name a `Listing.Icon`**, so each is drawn with a picture beside it wherever it is listed and on the notice when it finishes: `Tool_Hatchet_Crude` for the introduction, `RPG_Station_Sawmill` for the quest that hands the mill over, the copper and iron hatchets for the two quests that pay them, life essence for the two that are about it, sap and bark for the deliveries. Needs MMO Skill Tree 1.6.1, which carries the quest picture onto a finished-quest notice.
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
  `Server/ZiggfreedCommon/Dialogues/MMOSkillTree/Mmo_Sawyer.json` (22 screens: a first meeting, a
  hail for a player sent down to introduce themselves, a screen per quest state, two steady beats,
  three help screens, and a separate greeting for a player holding the Sawmiller's Hatchet). The
  MMO jar's guide points a temple visitor at him.
- **Adds A Word with Marn**, the introduction: the Adventurer's Guide offers it in the Forgotten
  Temple once the meeting down there is claimed, and it asks for nothing but crossing the landing
  and saying hello. It is taken from the Guide and finished at Marn (`TurnInAt`, so the Woodcutting
  experience it pays is collected from his own quest list, and the quest sits on nobody else's),
  which is what makes the sawmill read as somewhere the player is sent rather than a chain that
  appears on its own. Marn's first-meeting line credits it, and so does the hail behind that line
  for a player who had already wandered down and said hello. It needs the `stations` feature, so a
  server without the station engine never sees it.
- **Adds the seven Sawmill quests** (`Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/`), every
  one offered by and handed in to Marn, every reward collected from the quest log: **Timber
  Rights** (open once the introduction is claimed; chop timber, hand-cut planks, deliver a share;
  pays the Sawmill itself plus Woodcutting XP), then the `sawmill` chain **First Cut**, **Reading
  the Grain**, **Deep in the Wood** (Woodcutting 30, the level the deeper finds open at) and **A
  Finer Edge**, the side branch **A Second Bench** (a second mill), and **Standing Order**, a
  calendar daily (planks and bark, refreshing at the day boundary) paid from
  `Lootables/Mmo_Sawmill_Order.json`, a ladder over Woodcutting level and luck with three
  independent chance rolls on top. Everything the mill hands over is counted through the
  `STATION_OUTPUT` kind, qualified to the Sawmill, and cycles through `WORK_STATION`; both are
  RPG Stations' own.
- **Adds eighteen achievements and the Stations category**
  (`Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/`,
  `AchievementCategories/MMOSkillTree/Stations.json` with a `sawmill` subcategory): three ladders
  (cycles worked, lumber milled, life essence found; the top rung of each announces), Nothing
  Wasted, Every Grain, Distilled, the hidden Lucky Shavings, the hidden Sawmiller, the hidden
  server-first First Sawmiller, Standing Account and Master Sawyer.
- **Adds the `sawmiller` flair** (`Server/RpgStations/Flairs/Sawmiller.json`, "Sawmiller's
  Crown"): gold crown and spark particles over the Sawmill's `Rare_Find` and `Completion` moments,
  granted by the Sawmiller achievement through ziggfreed-common's `Flair` reward kind.
- **Ships key-complete localization in all 9 locales** (`items.lang`, `rpgstations.lang`,
  `mmoskilltree.lang`, `avatarCustomization.lang`, `npcs.lang`): every quest title and flavor
  line, the mill-lumber step line, every achievement title, description and announcement, the
  category title, the flair name and every line of Marn's conversation.

**Release scope: the Sawmill only.** The Anvil (a two-action Convert/Enhance station with the
weapon-enhancement Stamp ritual), the `AnvilWeaponPool` roll pool, the Smithing and Cooking custom
skills, and the `CookingProgression` extension are finished but held back under `unreleased/`
(restorable in one command; see `unreleased/README.md`). Their lang keys stay shipped in all 9
locales. `CookingProgression` targets a station held back on the RPG Stations jar side, so the two
repos restore together.
