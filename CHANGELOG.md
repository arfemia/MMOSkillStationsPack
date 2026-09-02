# Changelog - MMO Skill Stations Pack

No em-dashes.

## [0.1.0] (first release)

First public release, the Sawmill. This pack layers MMO Skill Tree progression onto the standalone
RPG Stations sawmill through the engine's generic contribution channels; it ships no engine code of
its own. Requires RPG Stations `>=0.1.0` and MMO Skill Tree `^1.6.0`, both declared in
`manifest.json`.

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
- **Adds the find-tier drop tables** (`Server/Drops/MMO_Station_Sawmill_T1..T5.json` plus
  `MMO_Station_Sawmill_Masterwork.json`): offcuts at every tier, life essence from the second tier,
  concentrated essence at the top, and the masterwork roll's double offcuts plus the occasional
  Woodcutting XP boost token.
- **Adds two same-id item overrides of the RPG Stations jar defaults**:
  `RPG_Station_Sawmill` (the bench block; this copy authors NO crafting recipe, so installing the
  pack removes the jar's standalone craftability and acquisition goes through the quest below) and
  `RPG_Tool_Hatchet_Sawmiller` (the trophy hatchet, carrying an MMO stat payload while held:
  +10 maximum stamina, +25% Woodcutting XP, +25 Woodcutting luck).
- **Adds the Timber Rights quest**
  (`Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/Timber_Rights.json`): offered at the hub
  once the starter gathering quest is done; deliver milled planks and collect the Sawmill itself
  plus 500 Woodcutting XP from the quest log.
- **Ships key-complete localization in all 9 locales** (`items.lang`, `rpgstations.lang`,
  `mmoskilltree.lang`, `avatarCustomization.lang`).

**Release scope: the Sawmill only.** The Anvil (a two-action Convert/Enhance station with the
weapon-enhancement Stamp ritual), the `AnvilWeaponPool` roll pool, the Smithing and Cooking custom
skills, and the `CookingProgression` extension are finished but held back under `unreleased/`
(restorable in one command; see `unreleased/README.md`). Their lang keys stay shipped in all 9
locales. `CookingProgression` targets a station held back on the RPG Stations jar side, so the two
repos restore together.
