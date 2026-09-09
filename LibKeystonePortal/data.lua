local dataVersion = 1;

--- @type LibKeystonePortal
local LibKP = LibStub("LibKeystonePortal");
if not LibKP then return; end

---@diagnostic disable: access-private
LibKP.RegisterData(
    dataVersion,
    {
        [2] = { 131204 }, -- Temple of the Jade Serpent
        [56] = { 131205 }, -- Stormstout Brewery
        [57] = { 131225 }, -- Gate of the Setting Sun
        [58] = { 131206 }, -- Shado-Pan Monastery
        [59] = { 131228 }, -- Siege of Niuzao Temple
        [60] = { 131222 }, -- Mogu'shan Palace
        [76] = { 131232 }, -- Scholomance
        [77] = { 131231 }, -- Scarlet Halls
        [78] = { 131229 }, -- Scarlet Monastery
        [161] = { 159898, 1254557 }, -- Skyreach
        [163] = { 159895 }, -- Bloodmaul Slag Mines
        [164] = { 159897 }, -- Auchindoun
        [165] = { 159899 }, -- Shadowmoon Burial Grounds
        [166] = { 159900 }, -- Grimrail Depot
        [167] = { 159902 }, -- Upper Blackrock Spire
        [168] = { 159901 }, -- The Everbloom
        [169] = { 159896 }, -- Iron Docks
        [198] = { 424163 }, -- Darkheart Thicket
        [199] = { 424153 }, -- Black Rook Hold
        [200] = { 393764 }, -- Halls of Valor
        [206] = { 410078 }, -- Neltharion's Lair
        [210] = { 393766 }, -- Court of Stars
        [227] = { 373262 }, -- Return to Karazhan: Lower
        [234] = { 373262 }, -- Return to Karazhan: Upper
        [239] = { 1254551 }, -- Seat of the Triumvirate
        [244] = { 424187 }, -- Atal'Dazar
        [245] = { 410071 }, -- Freehold
        [247] = { 467553, 467555 }, -- The MOTHERLODE!!
        [248] = { 424167 }, -- Waycrest Manor
        [249] = { 1286831 }, -- Kings' Rest
        [250] = { 1286828 }, -- Temple of Sethraliss
        [251] = { 410074 }, -- The Underrot
        [353] = { 445418, 464256 }, -- Siege of Boralus
        [369] = { 373274 }, -- Operation: Mechagon - Junkyard
        [370] = { 373274 }, -- Operation: Mechagon - Workshop
        [375] = { 354464 }, -- Mists of Tirna Scithe
        [376] = { 354462 }, -- The Necrotic Wake
        [377] = { 354468 }, -- De Other Side
        [378] = { 354465 }, -- Halls of Atonement
        [379] = { 354463 }, -- Plaguefall
        [380] = { 354469 }, -- Sanguine Depths
        [381] = { 354466 }, -- Spires of Ascension
        [382] = { 354467 }, -- Theater of Pain
        [391] = { 367416 }, -- Tazavesh: Streets of Wonder
        [392] = { 367416 }, -- Tazavesh: So'leah's Gambit
        [399] = { 393256 }, -- Ruby Life Pools
        [400] = { 393262 }, -- The Nokhud Offensive
        [401] = { 393279 }, -- The Azure Vault
        [402] = { 393273 }, -- Algeth'ar Academy
        [403] = { 393222 }, -- Uldaman: Legacy of Tyr
        [404] = { 393276 }, -- Neltharus
        [405] = { 393267 }, -- Brackenhide Hollow
        [406] = { 393283 }, -- Halls of Infusion
        [438] = { 410080 }, -- The Vortex Pinnacle
        [456] = { 424142 }, -- Throne of the Tides
        [463] = { 424197 }, -- Dawn of the Infinite: Galakrond's Fall
        [464] = { 424197 }, -- Dawn of the Infinite: Murozond's Rise
        [499] = { 445444 }, -- Priory of the Sacred Flame
        [500] = { 445443 }, -- The Rookery
        [501] = { 445269 }, -- The Stonevault
        [502] = { 445416 }, -- City of Threads
        [503] = { 445417 }, -- Ara-Kara, City of Echoes
        [504] = { 445441 }, -- Darkflame Cleft
        [505] = { 445414 }, -- The Dawnbreaker
        [506] = { 445440, 467546 }, -- Cinderbrew Meadery
        [507] = { 445424 }, -- Grim Batol
        [525] = { 1216786 }, -- Operation: Floodgate
        [542] = { 1237215 }, -- Eco-Dome Al'dani
        [556] = { 1254555 }, -- Pit of Saron
        [557] = { 1254400 }, -- Windrunner Spire
        [558] = { 1254572 }, -- Magisters' Terrace
        [559] = { 1254563 }, -- Nexus-Point Xenas
        [560] = { 1254559 }, -- Maisara Caverns
        [583] = { 1254551 }, -- Seat of the Triumvirate
        [584] = { 1286801 }, -- The Blinding Vale
        [585] = { 1286804 }, -- Voidscar Arena
        [586] = { 1286807 }, -- Den of Nalorakk
        [587] = { 1286809 }, -- Murder Row
        [588] = { 1286812 }, -- Altar of Fangs
    }
);
