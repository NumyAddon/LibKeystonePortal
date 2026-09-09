-- @curseforge-project-slug: libkeystoneportal@
--- @diagnostic disable: duplicate-set-field

local MAJOR, MINOR = "LibKeystonePortal", 1;
--- @class LibKeystonePortal
local LibKeystonePortal = LibStub:NewLibrary(MAJOR, MINOR);

if not LibKeystonePortal then return end -- No upgrade needed

--- @private
--- @type table<any, fun(uniqueKey: any, playerName: string, destinationChallengeMapID: number, portalSpellID: number, source: "EVENT"|"COMMS")>
LibKeystonePortal.callbackMap = LibKeystonePortal.callbackMap or {};
--- @private
LibKeystonePortal.frame = LibKeystonePortal.frame or CreateFrame("Frame");
--- @private
LibKeystonePortal.dataVersion = LibKeystonePortal.dataVersion or 0;
--- @private
--- @type table<number, number[]> # [challengeMapID] = portalSpellIDs
LibKeystonePortal.data = LibKeystonePortal.data or {};
--- @private
--- @type table<number, number> # [portalSpellID] = challengeMapID
LibKeystonePortal.reverseLookup = LibKeystonePortal.reverseLookup or {};

--- @public
--- @param challengeMapID number # see [challengeMapID](https://wago.tools/db2/MapChallengeMode)
--- @return number[]|nil spellIDs # List of portal spellIDs, nil if none are found. Multiple spellIDs may be returned in case of Horde and Alliance having different portals.
function LibKeystonePortal.GetPortalSpellsByMapID(challengeMapID)
    assert(type(challengeMapID) == "number", "challengeMapID must be a number");
    local spells = LibKeystonePortal.data[challengeMapID];

    return spells and CopyTable(spells) or nil;
end

--- @public
--- @param spellID number
--- @return number? challengeMapID # nil if not a known portal spellID. If the spell targets multiple mapIDs (such as for mega dungeons) a random one is returned.
function LibKeystonePortal.GetChallengeMapIDBySpellID(spellID)
    assert(type(spellID) == "number", "spellID must be a number");

    return LibKeystonePortal.reverseLookup[spellID];
end

--- @public
--- @generic T: any
--- @param callback fun(uniqueKey: T, playerName: string, destinationChallengeMapID: number, portalSpellID: number, source: "EVENT"|"COMMS")
--- @param uniqueKey T|nil
--- @return T
function LibKeystonePortal.RegisterPortalCallback(callback, uniqueKey)
    assert(type(callback) == "function", "callback must be a function")
    if uniqueKey == nil then
        uniqueKey = {};
    end

    LibKeystonePortal.callbackMap[uniqueKey] = callback;

    return uniqueKey;
end

--- @public
--- @param uniqueKey any
function LibKeystonePortal.UnregisterPortalCallback(uniqueKey)
    assert(uniqueKey and LibKeystonePortal.callbackMap[uniqueKey], "uniqueKey must match a registered callback");
end

do
    local prefix = "LKeystonePortal";
    local broadcastMsgFormat = "BV1_%s\030%s"; -- broadcast version 1
    local broadcastMsgCapture = "^" .. broadcastMsgFormat:format("(.+)", "(.+)") .. "$";

	local result = C_ChatInfo.RegisterAddonMessagePrefix(prefix);
	if result ~= Enum.RegisterAddonMessagePrefixResult.Success and result ~= Enum.RegisterAddonMessagePrefixResult.DuplicatePrefix then
        wipe(LibKeystonePortal);
		error("LibKeystonePortal: Failed to register the addon prefix.");
	end

    local frame = LibKeystonePortal.frame;
    frame:UnregisterAllEvents(); -- unregister all events from unupgraded lib instances
    frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    frame:RegisterEvent("CHAT_MSG_ADDON");
    frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...); end);

    local playerRealm = GetRealmName();
    local playerFullName = UnitNameUnmodified("player") .. "-" .. playerRealm;
    local throttleTime = 3;
    local activeThrottles = {};

    --- @param fullName string
    --- @param mapID number
    --- @param spellID number
    --- @param source "EVENT"|"COMMS"
    local function tryTriggerCallbacks(fullName, mapID, spellID, source)
        if issecretvalue(fullName) or activeThrottles[fullName] then return; end
        activeThrottles[fullName] = true;
        C_Timer.After(throttleTime, function() activeThrottles[fullName] = nil; end);

        for uniqueKey, callback in pairs(LibKeystonePortal.callbackMap) do
            securecallfunction(callback, uniqueKey, fullName, mapID, spellID, source);
        end
    end

    local function broadcastToParty(fullName, spellID)
        C_ChatInfo.SendAddonMessage(prefix, broadcastMsgFormat:format(fullName, spellID), "PARTY");
    end

    --- @param unit string
    --- @param spellID number
    function frame:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
        if issecretvalue(unit) or issecretvalue(spellID) or not IsInGroup(LE_PARTY_CATEGORY_HOME) then return; end
        local mapID = LibKeystonePortal.GetChallengeMapIDBySpellID(spellID);
        if not mapID then return; end

        if unit == "player" then
            broadcastToParty(playerFullName, spellID);
        elseif UnitInParty(unit) then
            local name, realm = UnitNameUnmodified(unit);
            realm = realm or playerRealm;
            local fullName = name .. '-' .. realm;
            tryTriggerCallbacks(fullName, mapID, spellID, "EVENT");
            broadcastToParty(fullName, spellID);
        end
    end

    function frame:CHAT_MSG_ADDON(receivedPrefix, text, channel, sender)
        if receivedPrefix ~= prefix or sender == playerFullName then return; end

        local fullName, spellID = text:match(broadcastMsgCapture);
        if fullName and fullName ~= playerFullName and spellID then
            spellID = tonumber(spellID);
            local mapID = spellID and LibKeystonePortal.GetChallengeMapIDBySpellID(spellID);
            if not mapID then return; end
            tryTriggerCallbacks(fullName, mapID, spellID, "COMMS");
        end
    end
end

--- @private - do not use
--- @param dataVersion number
--- @param data table<number, number[]> # [challengeMapID] = portalSpellIDs
function LibKeystonePortal.RegisterData(dataVersion, data)
    if dataVersion <= LibKeystonePortal.dataVersion then return; end
    LibKeystonePortal.dataVersion = dataVersion;
    LibKeystonePortal.data = {};
    LibKeystonePortal.reverseLookup = {};
    for mapID, spellIDs in pairs(data) do
        LibKeystonePortal.data[mapID] = {};
        for i, spellID in pairs(spellIDs) do
            LibKeystonePortal.data[mapID][i] = spellID;
            LibKeystonePortal.reverseLookup[spellID] = mapID;
        end
    end
end
