db = db.getSiblingDB("retail_catalog");

const query = {
    category: "Mobile Devices",
    "attributes.colour": "Black"
};

const iterations = 200;

function runBenchmark(label) {
    // Warm-up query
    db.products.find(query).toArray();

    const start = Date.now();

    for (let run = 1; run <= iterations; run++) {
        db.products.find(query).toArray();
    }

    const finish = Date.now();
    const totalMilliseconds = finish - start;

    return {
        configuration: label,
        iterations: iterations,
        totalMilliseconds: totalMilliseconds,
        averageMilliseconds:
            Number((totalMilliseconds / iterations).toFixed(3))
    };
}

print("REPEATED MONGODB BENCHMARK BEFORE INDEX");

try {
    db.products.dropIndex("category_colour_index");
} catch (error) {
    print("Compound index was not present");
}

const beforeResult = runBenchmark("Before index");

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

print("REPEATED MONGODB BENCHMARK AFTER INDEX");

const afterResult = runBenchmark("After index");

const improvement =
    ((beforeResult.averageMilliseconds -
        afterResult.averageMilliseconds) /
        beforeResult.averageMilliseconds) * 100;

print("MONGODB BENCHMARK SUMMARY");

printjson({
    beforeIndex: beforeResult,
    afterIndex: afterResult,
    percentageImprovement:
        Number(improvement.toFixed(2)),
    documentsReturnedPerQuery:
        db.products.countDocuments(query)
});

print("REPEATED MONGODB BENCHMARK COMPLETED");

quit();