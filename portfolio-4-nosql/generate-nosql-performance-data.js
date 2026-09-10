// MIT 8103 Advanced Database Systems
// Portfolio 4: MongoDB Performance Dataset

db = db.getSiblingDB("retail_catalog");

print("Removing previous MongoDB performance-test documents");

db.products.deleteMany({
    sku: {
        $regex: "^PERF-"
    }
});

const categories = [
    "Computers",
    "Mobile Devices",
    "Accessories",
    "Networking"
];

const colours = [
    "Black",
    "Silver",
    "Blue",
    "White",
    "Grey"
];

let batch = [];

for (let number = 1; number <= 5000; number++) {
    const category = categories[number % categories.length];
    const colour = colours[number % colours.length];

    batch.push({
        sku: "PERF-" + number.toString().padStart(5, "0"),
        name: "Performance Test Product " + number,
        category: category,
        price: 10000 + ((number * 137) % 900000),
        attributes: {
            colour: colour,
            modelNumber: "MODEL-" + number,
            memoryGB: [4, 8, 16, 32][number % 4],
            storageGB: [64, 128, 256, 512][number % 4],
            warrantyMonths: 12 + (number % 3) * 6
        },
        tags: [
            category.toLowerCase().replace(" ", "-"),
            colour.toLowerCase(),
            "performance-test"
        ],
        createdAt: new Date(
            Date.UTC(
                2025 + (number % 2),
                number % 12,
                1 + (number % 28)
            )
        )
    });

    if (batch.length === 1000) {
        db.products.insertMany(batch);
        batch = [];
    }
}

if (batch.length > 0) {
    db.products.insertMany(batch);
}

print("MongoDB performance dataset generated");

printjson({
    originalProducts: db.products.countDocuments({
        sku: {
            $not: {
                $regex: "^PERF-"
            }
        }
    }),
    performanceProducts: db.products.countDocuments({
        sku: {
            $regex: "^PERF-"
        }
    }),
    totalProducts: db.products.countDocuments()
});