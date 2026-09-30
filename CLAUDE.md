# Skill Stations Pack

Progression content for RPG Stations. The family-wide rules apply here; this file adds only what is specific to this pack. Authoring reference: RPG Stations `SCHEMA.md` and `docs/`.

- The Sawmill station and its presentation ship in the RPG Stations jar. This pack only extends its Mill action through `RpgStations/Extensions/SawmillProgression.json` and must never re-ship a full `Stations/Sawmill.json`.
- Same-id native item overrides (`RPG_Station_Sawmill.json`, `RPG_Tool_Hatchet_Sawmiller.json`) replace the jar item wholesale: carry every field of the jar's file and change only the delta (the block copy omits `Recipe` on purpose).
- `SawmillTrophy.json` overrides the jar's trophy table by id (the jar's Sawmill already references it); never also list it in `SawmillProgression`'s `Bonus.Lootables`.
- Every `Drops` container needs at least one concrete `Single`: a tree of only `Droplist` references can fail "Container must have something to drop!" and take the pack down at load.
- A `DropLists` id repeated inside one `Grants` is deliberate: each entry rolls as an independent pull.
- Station bounties ship here, self-contained with no `Parent`, because a board posts contracts without reading their `Requires`. This pack's hard dependency on RPG Stations is what keeps them off a server without stations.
- `unreleased/` (Anvil, Smithing and Cooking skills, `CookingProgression`) is excluded from the zip by `build.ps1` and is not live content; its README documents it and its lang keys stay shipped.
