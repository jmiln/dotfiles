// .mongorc.js
// Config settings
config.set("displayBatchSize", 100)     // Set it to show more results per query
config.set("historyLength", 9999)       // Set it to save more command history


const swapiDBs = ["swapi", "testSwapi"];


// Change the prompt to show user and which db you're using
prompt = function() {
    let username = "";
    const user = db.runCommand({
        connectionStatus: 1
    }).authInfo.authenticatedUsers[0];

    username = !user ? "anon" : user.user;

    let database = db.getName();
    return `${username}:${database} > `;
}


// ### Custom functions

// Wipe out any player stats records older than 20 days
cleanOld = async function (table="playerStats") {
    if (!swapiDBs.includes(db.getName())) return print("This can only be run inside the swapi dbs!");
    const usableTables = ["playerStats", "guilds"]
    if (!usableTables.includes(table)) return print("Incorrect table, these are the only usable ones: " + usableTables.join(", "));
    return await db[table].deleteMany({updated: {"$lt": (new Date().setDate(new Date().getDate()-20))}})
}

// SWGoHBot stuff
myAC = 855211749;

// Print out a player's character
playerCharSearch = async function (ac, defId, table) {
    if (!swapiDBs.includes(db.getName())) return print("This can only be run inside the swapi dbs!");
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (!defId) return print("Missing character to search for");
    if (!table) table = "playerStats";
    defId = defId.toUpperCase();
    const charObj = await db[table].aggregate([
        { $match: { allyCode: ac } },
        { $project: {roster: 1, _id: 0}},
        { $unwind: "$roster"},
        { $match: { 'roster.defId': defId.toUpperCase()}}
    ]).pretty();
    return charObj;
}

// Print out the player's info, but without the roster
playerSearch = async function (ac) {
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (!swapiDBs.includes(db.getName())) return print("This can only be run inside the swapi dbs!");
    return await db.playerStats.find({allyCode: ac}, {roster: 0}).pretty();
}

// Get the list of a guild's events
guildEventSearch = async function(guildId) {
    if (db.getName() !== "swgohbot") return print("This can only be run inside the swgohbot db!");
    if (!guildId) return print("Missing guild ID");
    if (typeof guildId !== "string") guildId = guildId.toString();
    return await db.eventDBs.find({"eventID": new RegExp(`${guildId}-.*`)});
}

// Get a list of how many guilds use each language settings
guildSettingCount = async function(setting, limit=10) {
    if (!setting) return print("Missing setting to check for!");
    if (db.getName() !== "swgohbot") return print("This can only be run inside the swgohbot db!");
    return await db.guildSettings.aggregate([
        {
            $project: {
                langId: {
                    $substrCP: [`$${setting}`, 0, 18]
                }
            }
        },
        {
            $group: {
                _id: "$langId",
                count: { $count: { } }
            }
        },
        {
            $sort: {
                count: -1
            }
        },
        {
            $limit: limit
        }
    ])
}

// Get event counts for each guild
guildEventCount = async function(limit = 10) {
    if (db.getName() !== "swgohbot") return print("This can only be run inside the swgohbot db!");
    return await db.eventDBs.aggregate([
        {
            $project: {
                evId: {
                    $substrCP: ["$eventID", 0, 18]
                }
            }
        },
        {
            $group: {
                _id: "$evId",
                count: { $count: { } }
            }
        },
        {
            $sort: {
                count: -1
            }
        },
        {
            $limit: limit
        }
    ])
}
