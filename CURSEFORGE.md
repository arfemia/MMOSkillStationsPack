# MMO Skill Stations Pack

**Turn the sawmill into a progression bench.**

A free content pack that layers [MMO Skill Tree](https://www.curseforge.com/hytale/mods/mmo-skill-tree) progression onto [RPG Stations](https://www.curseforge.com/hytale/mods/rpg-stations). RPG Stations gives you a sawmill you can place, load with logs, and work by hand. This pack makes working it level you up, and makes what you get out of it depend on who you have become.

Requires **both** mods. RPG Stations supplies the bench, MMO Skill Tree supplies the skills, and this pack is the wiring between them.

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/5NFdZsUxHZ) [![Ko-fi](https://img.shields.io/badge/Ko--fi-Support-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/ziggfreed) [![Documentation](https://img.shields.io/badge/Docs-Read%20More-0ea5e9?style=for-the-badge)](https://mmo-skill-tree-docs.ziggfreed.com)

---

[![Host your own Hytale server with Kinetic Hosting](https://i.imgur.com/UHn3FzW.png)](https://billing.kinetichosting.com/aff.php?aff=1262)

---

## What it adds

- **Milling trains your skills** - every completed cycle at the sawmill grants Woodcutting and Crafting XP, and a better hatchet grants more of it. Load a stack of logs, press the interact key, and your character works through them while the XP comes in.
- **Five find tiers** - the longer your progression, the more a milled log gives up beyond its planks. Every tier pays offcuts (plant fibre, tree bark, tree sap, sticks); life essence joins from the second tier, and concentrated life essence at the top. Which tier you reach is decided by a single score built from your Woodcutting and Crafting **luck** and your **levels** in both, so the bench reads your whole character rather than one number.
- **Luck buys planks, not just finds** - a second bonus-output ladder pays extra planks for luck alone, sitting beside the one that pays for Woodcutting level. Stacking luck is worth it at a bench that already rewards levels, and early luck arrives as an extra plank every few cycles rather than nothing until some distant threshold.
- **A chase worth chasing** - the sawmill's drop-only trophy tool, the **Sawmiller's Hatchet**, becomes luck-driven with this pack installed: roughly 1 in 3000 cycles with nothing invested, improving to about 1 in 762 once your Woodcutting tree is finished. Luck is what shortens the hunt.
- **The trophy pays off** - the hatchet carries +10 maximum stamina, +25% Woodcutting XP and +25 Woodcutting luck while held, and it opens a bonus roll no other tool in the game can reach: a double helping of offcuts, plus the occasional Woodcutting XP boost token. Its own luck bonus feeds the very roll it unlocks, and it is the only tool that reaches the top of the bench's yield curve.
- **Fully translated** - all display text ships in 9 languages (English, German, Spanish, French, Hungarian, Italian, Brazilian Portuguese, Russian, Turkish), with English as the fallback for anything a translation misses.

## How it works

1. Install RPG Stations, MMO Skill Tree, and this pack.
2. Craft the Sawmill at a tier 2 Workbench (one crude hatchet, any log, four planks) or have an admin give you one, and place it.
3. Hold logs and press the interact key to load them into the bench, up to 100 at a time.
4. Press it again holding a hatchet to start working. Your character mills the pile one cycle at a time while you watch; walk away, take damage, or run out of logs and the session ends with a summary.
5. Planks, offcuts, finds and XP all arrive as you work. Anything left in the bench comes back to you when you stop.

## What decides your rewards

| Source | What it changes |
|---|---|
| Your hatchet | Planks per log (one on a starter hatchet, up to five with the trophy) and how much XP each cycle grants |
| Woodcutting + Crafting **luck** | Which of the five find tiers you reach, extra planks per cycle, and how quickly the trophy chase resolves |
| Woodcutting + Crafting **levels** | Which find tier you reach, and extra planks per cycle |
| Woodcutting level 30 | Unlocks the top three find tiers |
| Holding the Sawmiller's Hatchet | Unlocks a bonus roll only it can open, and adds luck and XP on top |

Your own skill still counts for more than the neighbouring one at a woodcutting bench: Woodcutting counts full and Crafting counts half, matching how the sawmill splits its XP.

## For server owners

Everything above is ordinary content in the pack zip, so nothing here needs a code change to retune:

- **The find tiers** live in `Server/RpgStations/Lootables/SawmillLuckFinds.json`. Move a threshold, reweight what counts toward the score, or change which level unlocks the deep tiers.
- **What a find hands over** lives in `Server/Drops/`. The offcut mix is shared with RPG Stations' own tables through a single list, so retuning fibre and bark once changes it everywhere on the bench.
- **The bonus-plank ladders** live in `Server/RpgStations/Lootables/SawmillOutputLadders.json`, one for levels and one for luck.
- **The trophy chase odds** live in `Server/RpgStations/Lootables/SawmillTrophy.json`.
- **The XP per cycle** lives in `Server/RpgStations/Extensions/SawmillProgression.json` (Woodcutting 8, Crafting 4 by default).

Without MMO Skill Tree installed the sawmill still runs its work loop and its own finds, it just grants no skill XP. Without RPG Stations there are no stations at all.

## Links

- [MMO Skill Tree](https://www.curseforge.com/hytale/mods/mmo-skill-tree) - the progression mod this pack feeds
- [RPG Stations](https://www.curseforge.com/hytale/mods/rpg-stations) - the station engine this pack extends
- [Documentation](https://mmo-skill-tree-docs.ziggfreed.com)
- [Discord](https://discord.gg/5NFdZsUxHZ)
