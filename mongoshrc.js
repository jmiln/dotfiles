// .mongorc.js
// Config settings
config.set("displayBatchSize", 100)     // Set it to show more results per query
config.set("historyLength", 9999)       // Set it to save more command history



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
cleanOld = async function () {
    if (db.getName() !== "swapi") return print("This can only be run inside the swapi db!");
    const res = await db.playerStats.deleteMany({updated: {"$lt": (new Date(new Date().setDate(new Date().getDate()-20)).getTime())}})
    return res;
}


// SWGoHBot stuff
myAC = 855211749;

// Print out a player's character
playerCharSearch = async function (ac, defId) {
    if (db.getName() !== "swapi") return print("This can only be run inside the swapi db!");
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (!defId) return print("Missing character to search for");
    defId = defId.toUpperCase();
    const charObj = await db.playerStats.aggregate([
        { $match: { allyCode: ac } },
        { $project: {roster: 1, _id: 0}},
        { $unwind: "$roster"},
        { $match: { 'roster.defId': defId}}
    ]).pretty();
    return charObj;
}

// Print out the player's info, but without the roster
playerSearch = async function (ac) {
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (db.getName() !== "swapi") return print("This can only be run inside the swapi db!");
    return await db.playerStats.find({allyCode: ac}, {roster: 0}).pretty();
}

// Get the list of a guild's events
guildEventSearch = async function(guildId) {
    if (db.getName() !== "swgohbot") return print("This can only be run inside the swgohbot db!");
    if (!guildId) return print("Missing guild ID");
    if (typeof guildId !== "string") guildId = guildId.toString();
    return await db.eventDBs.find({"eventID": new RegExp(`${guildId}-.*`)});
}

// Get event counts for each guild
guildEventCount = async function(limit = 10) {
    if (db.getName() !== "swgohbot") return print("This can only be run inside the swgohbot db!");
    return await db.eventDBs.aggregate([
        {
            $project: {
                evId: {
                    $substr: ["$eventID", 0, 18]
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
