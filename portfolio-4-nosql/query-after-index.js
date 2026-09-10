db = db.getSiblingDB("retail_catalog");

print("CREATING COMPOUND INDEX");

db.products.createIndex(
    {
        category: 1,
        "attributes.colour": 1
    },
    {
        name: "category_colour_index"
    }
);

const explanation = db.products
    .find({
        category: "Mobile Devices",
        "attributes.colour": "Black"
    })
    .explain("executionStats");

function findIndexScan(plan) {
    if (!plan || typeof plan !== "object") {
        return null;
    }

    if (plan.stage === "IXSCAN") {
        return plan;
    }

    return (
        findIndexScan(plan.inputStage) ||
        findIndexScan(plan.queryPlan) ||
        findIndexScan(plan.outerStage) ||
        findIndexScan(plan.innerStage)
    );
}

const winningPlan = explanation.queryPlanner.winningPlan;
const indexScan = findIndexScan(winningPlan);

print("QUERY AFTER INDEX");
printjson({
    stage: indexScan ? indexScan.stage : winningPlan.stage,
    indexName: indexScan ? indexScan.indexName : "Not detected",
    executionTimeMillis: explanation.executionStats.executionTimeMillis,
    totalDocsExamined: explanation.executionStats.totalDocsExamined,
    totalKeysExamined: explanation.executionStats.totalKeysExamined,
    nReturned: explanation.executionStats.nReturned
});

quit();