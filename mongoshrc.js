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


// Custom functions
myAC = 855211749;

// Print out a player's character
playerCharSearch = async function (ac, defId) {
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (db.getName() !== "swapi") return print("This can only be run inside the swapi db!");
    if (!defId) return print("Missing character to search for");
    defId = defId.toUpperCase();
    const char = await db.playerStats.aggregate([
        { $match: { allyCode: ac } },
        { $project: {roster: 1, _id: 0}},
        { $unwind: "$roster"},
        { $match: { 'roster.defId': defId}}
    ]).pretty();
    print(char)
}

// Print out the player's info, but without the roster
playerSearch = async function (ac) {
    if (typeof ac !== "number") return print("AC needs to be a number!");
    if (db.getName() !== "swapi") return print("This can only be run inside the swapi db!");
    const player = await db.playerStats.find({allyCode: ac}, {roster: 0});
    print(player);
}
