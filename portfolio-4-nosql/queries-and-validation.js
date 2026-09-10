// MIT 8103 Advanced Database Systems
// Portfolio 4: MongoDB Queries and Validation Tests

db = db.getSiblingDB("retail_catalog");

print("TEST 1: PRODUCT COUNT");

printjson({
    productCount: db.products.countDocuments()
});

print("TEST 2: COMPUTERS WITH AT LEAST 16GB MEMORY");

db.products.find(
    {
        category: "Computers",
        "attributes.memoryGB": {
            $gte: 16
        }
    },
    {
        _id: 0,
        sku: 1,
        name: 1,
        price: 1,
        "attributes.memoryGB": 1
    }
).sort({
    price: 1
}).forEach(printjson);

print("TEST 3: PRODUCTS TAGGED AS BLUETOOTH");

db.products.find(
    {
        tags: "bluetooth"
    },
    {
        _id: 0,
        sku: 1,
        name: 1,
        tags: 1
    }
).forEach(printjson);

print("TEST 4: CATEGORY PRICE AGGREGATION");

db.products.aggregate([
    {
        $group: {
            _id: "$category",
            totalProducts: {
                $sum: 1
            },
            averagePrice: {
                $avg: "$price"
            },
            minimumPrice: {
                $min: "$price"
            },
            maximumPrice: {
                $max: "$price"
            }
        }
    },
    {
        $sort: {
            _id: 1
        }
    }
]).forEach(printjson);

print("TEST 5: SCHEMA VALIDATION");

try {
    db.products.insertOne({
        sku: "INVALID-PRICE",
        name: "Invalid Negative Price Product",
        category: "Accessories",
        price: -500,
        attributes: {},
        tags: ["invalid"],
        createdAt: new Date()
    });

    print("TEST FAILED: Negative price was accepted");
} catch (error) {
    print("TEST PASSED: Negative price was rejected");
}

print("TEST 6: UNIQUE SKU CONSTRAINT");

try {
    db.products.insertOne({
        sku: "LAP-1001",
        name: "Duplicate SKU Product",
        category: "Computers",
        price: 100000,
        attributes: {},
        tags: ["duplicate"],
        createdAt: new Date()
    });

    print("TEST FAILED: Duplicate SKU was accepted");
} catch (error) {
    print("TEST PASSED: Duplicate SKU was rejected");
}

print("TEST 7: FLEXIBLE DOCUMENT ATTRIBUTES");

db.products.find(
    {
        sku: {
            $in: [
                "LAP-1001",
                "PHN-2001",
                "NET-4001"
            ]
        }
    },
    {
        _id: 0,
        sku: 1,
        category: 1,
        attributes: 1
    }
).sort({
    sku: 1
}).forEach(printjson);

print("ALL NOSQL VALIDATION TESTS COMPLETED");