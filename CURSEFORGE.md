# MMO Skill Stations Pack

**Working the sawmill levels you up.**

RPG Stations gives you a sawmill you can place and work by hand. This pack wires it into [MMO Skill Tree](https://www.curseforge.com/hytale/mods/mmo-skill-tree), so every log you mill pays Woodcutting and Crafting XP, and what falls out of the bench depends on how far you have come. It also puts a sawyer in the Forgotten Temple with work for you.

You need both mods installed. This pack is just the content between them.

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/5NFdZsUxHZ) [![Ko-fi](https://img.shields.io/badge/Ko--fi-Support-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/ziggfreed) [![Documentation](https://img.shields.io/badge/Docs-Read%20More-0ea5e9?style=for-the-badge)](https://mmo-skill-tree-docs.ziggfreed.com)

---

[![Host your own Hytale server with Kinetic Hosting](https://i.imgur.com/UHn3FzW.png)](https://billing.kinetichosting.com/aff.php?aff=1262)

---

## What it adds

- **XP for milling.** Every completed cycle pays 8 Woodcutting XP and 4 Crafting XP, and a better hatchet multiplies both. Load a stack of logs, press F, and the XP comes in while your character works.
- Offcuts from every log: plant fibre, tree bark, tree sap, sticks. Life Essence starts turning up at the second find tier, and Concentrated Life Essence at the top.
- **Five find tiers**, opened by one score built from your Woodcutting and Crafting luck plus your levels in both. Your own skill counts full, the neighbouring one counts half. The top three tiers also want Woodcutting 30.
- Luck pays out in planks too, not just rare finds. Even a little is worth stacking: you start seeing an extra plank every few cycles, with no far-off threshold to wait on. It stacks with the plank ladder that pays for Woodcutting level at 25, 50, 75, 100 and 125.
- A real chase for the Sawmiller's Hatchet. Around 1 in 3000 cycles with nothing invested, down to about 1 in 762 once your Woodcutting tree is finished. Luck is what shortens it.
- Once you have that hatchet: +10 maximum stamina, +25% Woodcutting XP and +25 Woodcutting luck while held. It also opens a bonus roll nothing else in the game can reach, paying double offcuts and the occasional Woodcutting XP boost. Its own luck bonus feeds the roll it unlocks.
- Sawyer Marn, in the Forgotten Temple, with seven quests, a daily and eighteen achievements about the mill. Details below.
- Translated into 9 languages. Anything a translation misses falls back to English.

## Sawyer Marn

Marn saws timber. He stands in the Forgotten Temple with an iron hatchet in his hand, beside the merchant and across from the Mastery Trainer, and he is the one who hands out sawmills. Once you have made it to the temple, ask the guide about the one with the hatchet, then go and talk to him.

His first job is Timber Rights. Chop timber, cut planks on a hand bench, bring him a share, and the Sawmill is yours to collect from your quest log. The jobs after it each take one thing the mill does and make you do it properly: First Cut has you run it and bring planks back, Reading the Grain has you crouch at the bench and mill the decorative and ornate cuts, Deep in the Wood asks for the Life Essence old wood gives up (it wants Woodcutting 30, the level the deeper finds open at), and A Finer Edge is a long shift with nothing to hand in. A Second Bench branches off after Reading the Grain and pays a second mill.

Standing Order is his daily. Planks and bark, delivered to him, once a day on the calendar. What he pays out of the yard grows with your Woodcutting level and luck. Some days there is Life Essence on top, or a Woodcutting boost token; once in a while a Concentrated Life Essence.

Eighteen achievements sit under a Stations category of their own. Ladders for cycles worked, lumber milled and Life Essence found. One for every wood species put through the mill, one for keeping every offcut, one for a pouch of Concentrated Life Essence. A hidden one for finding a boost token in the shavings. Two for the Sawmiller's Hatchet itself, and one of those is a server first: the whole server hears who pulled the first one out of a mill.

Pull that hatchet out of a mill and the Sawmiller achievement pays the Sawmiller's Crown. Gold crown particles over every rare find and every finished session at the bench, for as long as you play there. Cosmetic only, and yours for good.

## How it works

1. Install RPG Stations, MMO Skill Tree, and this pack.
2. Reach the Forgotten Temple and find Sawyer Marn. Chop timber, cut planks on a hand bench, deliver him a share, and collect the Sawmill itself plus Woodcutting XP from your quest log. Or have an admin give you one. Place it. (With this pack installed the bench is quest-earned, not crafted: the pack's copy of the block removes the standalone crafting recipe on purpose.)
3. Hold logs, press F to load up to 100 into the bench.
4. Press F again holding a hatchet. Your character mills the pile one cycle at a time while you watch. Crouch as you press F to pick which cut you want from the log in the bench.
5. Walk off, take a hit, or run the pile dry and the session ends with a summary. Anything still in the bench comes back to you.
6. Go back to Marn. Every job hands in to him, and each one he settles opens the next.

## What decides your rewards

| Source | What it changes |
|---|---|
| Your hatchet | Planks per log (one on a starter hatchet, five with the trophy) and the XP each cycle pays |
| Woodcutting + Crafting luck | Which find tier you reach, extra planks per cycle, how fast the trophy chase resolves |
| Woodcutting + Crafting levels | Which find tier you reach, and extra planks per cycle |
| Woodcutting 30 | Opens the top three find tiers, and Deep in the Wood |
| Holding the Sawmiller's Hatchet | Opens a bonus roll only it can reach, plus luck and XP on top |
| Woodcutting level + luck together | What Marn's daily pays |

## For server owners

All of it is content in the zip. Nothing here needs a code change to retune:

- Find tiers, their thresholds, and which level opens the deep ones: `Server/ZiggfreedCommon/Lootables/SawmillLuckFinds.json`
- What a find hands over: `Server/Drops/`. The offcut mix is shared with RPG Stations' own tables, so one edit changes it across the whole bench.
- The two plank ladders, one for levels and one for luck: `Server/ZiggfreedCommon/Lootables/SawmillOutputLadders.json`
- Trophy chase odds: `Server/ZiggfreedCommon/Lootables/SawmillTrophy.json`
- XP per cycle: `Server/RpgStations/Extensions/SawmillProgression.json`
- Marn's quests and what they pay: `Server/ZiggfreedCommon/Quests/MMOSkillTree/Stations/`. The daily's whole payout is one table, `Server/ZiggfreedCommon/Lootables/Mmo_Sawmill_Order.json`.
- The achievements and their points: `Server/ZiggfreedCommon/Achievements/MMOSkillTree/Stations/`
- Take Marn out without editing the pack: set his placement to `"Enabled": false` in `mods/ziggfreedcommon/npc-placements.json`. His quests hide with the stations feature, so nothing dangles if RPG Stations is switched off.

Without MMO Skill Tree the sawmill still runs and still pays its own finds, it just grants no skill XP; this pack itself, Marn included, needs both mods installed to load at all. Without RPG Stations there are no stations at all.

## Links

- [MMO Skill Tree](https://www.curseforge.com/hytale/mods/mmo-skill-tree)
- [RPG Stations](https://www.curseforge.com/hytale/mods/rpg-stations)
- [Documentation](https://mmo-skill-tree-docs.ziggfreed.com)
- [Discord](https://discord.gg/5NFdZsUxHZ)
