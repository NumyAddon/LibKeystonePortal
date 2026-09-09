# LibKeystonePortal

A library for getting the portal spell information for any given mythic plus dungeon. Also shares with your party whenever you use a portal.

Add this to your .pkgmeta to embed it into your addon.
```
externals:
    Libs/LibKeystonePortal: https://github.com/NumyAddon/LibKeystonePortal.git/LibKeystonePortal
```
Add this to your toc file: `Libs\LibKeystonePortal\LibKeystonePortal.xml`

## API

### `spellIDs = LibKeystonePortal.GetPortalSpellsByMapID(challengeMapID)`

Returns a list of spellIDs for the given challengeMapID. If no spellIDs are found, nil is returned instead.
Multiple spellIDs may be returned in case of Horde and Alliance having different portals.
It's up to you to check which (if any) the player actually knows.

- `challengeMapID` - `number` a [challengeMapID](https://wago.tools/db2/MapChallengeMode) previous seasons are also supported.

### `challengeMapID = LibKeystonePortal.GetChallengeMapIDBySpellID(spellID)`

Returns the challengeMapID for the given portal spellID. If no challengeMapID is found, nil is returned instead. If multiple challengeMapIDs match (e.g. for mega dungeons), a random one is returned.

- `spellID` - `number` a portal spellID

### `uniqueKey = LibKeystonePortal.RegisterPortalCallback(callback[, uniqueKey])`

Allows you to register a callback which will be called whenever someone in your party uses a portal. 
The `source` param will indicate whether this information came from `UNIT_SPELLCAST_SUCCEEDED` or from comms. 
The callback is throttled in case both the event and comms fire.
The callback is never fired for your own casts.

- `callback` - `function(uniqueKey: any, playerName: string, destinationChallengeMapID: number, portalSpellID: number, source: "EVENT"|"COMMS")`
- `uniqueKey` - optional, a unique key to allow unregistering the callback. If not provided, a unique key will be generated.

### `LibKeystonePortal.UnregisterPortalCallback(uniqueKey)`

- `uniqueKey` - the unique key provided or returned when registering the callback.

### Example

```
local LibKeystonePortal = LibStub("LibKeystonePortal")

local CoolStuff = {}

function CoolStuff:OnPortalUsed(playerName, destinationChallengeMapID, portalSpellID, source)
    local dungeonName = C_ChallengeMode.GetMapUIInfo(destinationChallengeMapID)
    print(string.format("%s used a portal to %s.", playerName, dungeonName))
end

LibKeystonePortal.RegisterPortalCallback(CoolStuff.OnPortalUsed, CoolStuff)
```
