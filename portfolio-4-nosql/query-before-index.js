db = db.getSiblingDB("retail_catalog");

try {
    db.products.dropIndex("category_colour_index");
} catch (error) {
    // Index does not exist
}

const explanation = db.products
    .find({
        category: "Mobile Devices",
        "attributes.colour": "Black"
    })
    .explain("executionStats");

const plan = explanation.queryPlanner.winningPlan;
const stage =
    plan.stage ||
    plan.queryPlan?.stage ||
    plan.inputStage?.stage ||
    "See plan summary";

print("QUERY BEFORE INDEX");
printjson({
    stage: stage,
    executionTimeMillis: explanation.executionStats.executionTimeMillis,
    totalDocsExamined: explanation.executionStats.totalDocsExamined,
    totalKeysExamined: explanation.executionStats.totalKeysExamined,
    nReturned: explanation.executionStats.nReturned
});

quit();