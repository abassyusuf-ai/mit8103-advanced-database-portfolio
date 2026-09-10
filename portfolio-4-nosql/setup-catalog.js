// MIT 8103 Advanced Database Systems
// Portfolio 4: MongoDB Product Catalogue

db = db.getSiblingDB("retail_catalog");

print("Removing the previous products collection");

db.products.drop();

print("Creating products collection with schema validation");

db.createCollection("products", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            title: "Product Catalogue Validation",
            required: [
                "sku",
                "name",
                "category",
                "price",
                "attributes",
                "tags",
                "createdAt"
            ],
            properties: {
                sku: {
                    bsonType: "string",
                    description: "SKU must be a string"
                },
                name: {
                    bsonType: "string",
                    description: "Product name must be a string"
                },
                category: {
                    enum: [
                        "Computers",
                        "Mobile Devices",
                        "Accessories",
                        "Networking"
                    ]
                },
                price: {
                    bsonType: [
                        "int",
                        "long",
                        "double",
                        "decimal"
                    ],
                    minimum: 0
                },
                attributes: {
                    bsonType: "object"
                },
                tags: {
                    bsonType: "array",
                    items: {
                        bsonType: "string"
                    }
                },
                createdAt: {
                    bsonType: "date"
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});

print("Inserting product documents");

db.products.insertMany([
    {
        sku: "LAP-1001",
        name: "Business Laptop 14 Inch",
        category: "Computers",
        price: 685000,
        attributes: {
            processor: "Intel Core i5",
            memoryGB: 16,
            storageGB: 512,
            storageType: "SSD",
            screenSize: 14,
            operatingSystem: "Windows 11"
        },
        tags: ["business", "portable", "ssd"],
        createdAt: ISODate("2026-01-05T08:00:00Z")
    },
    {
        sku: "LAP-1002",
        name: "Performance Laptop 15 Inch",
        category: "Computers",
        price: 920000,
        attributes: {
            processor: "Intel Core i7",
            memoryGB: 32,
            storageGB: 1000,
            storageType: "SSD",
            graphics: "Dedicated",
            screenSize: 15.6
        },
        tags: ["performance", "graphics", "ssd"],
        createdAt: ISODate("2026-01-06T08:00:00Z")
    },
    {
        sku: "DES-1001",
        name: "Office Desktop Computer",
        category: "Computers",
        price: 550000,
        attributes: {
            processor: "AMD Ryzen 5",
            memoryGB: 16,
            storageGB: 1000,
            formFactor: "Tower"
        },
        tags: ["office", "desktop"],
        createdAt: ISODate("2026-01-07T08:00:00Z")
    },
    {
        sku: "PHN-2001",
        name: "Android Smartphone 128GB",
        category: "Mobile Devices",
        price: 285000,
        attributes: {
            operatingSystem: "Android",
            storageGB: 128,
            memoryGB: 8,
            cameraMP: 50,
            simSlots: 2,
            colour: "Black"
        },
        tags: ["android", "dual-sim", "mobile"],
        createdAt: ISODate("2026-01-08T08:00:00Z")
    },
    {
        sku: "TAB-2001",
        name: "Android Tablet 10 Inch",
        category: "Mobile Devices",
        price: 340000,
        attributes: {
            operatingSystem: "Android",
            storageGB: 256,
            memoryGB: 8,
            screenSize: 10.1,
            supportsStylus: true
        },
        tags: ["tablet", "stylus", "mobile"],
        createdAt: ISODate("2026-01-09T08:00:00Z")
    },
    {
        sku: "ACC-3001",
        name: "Wireless Keyboard",
        category: "Accessories",
        price: 35000,
        attributes: {
            connectionType: "Bluetooth",
            batteryType: "Rechargeable",
            layout: "QWERTY",
            colour: "Black"
        },
        tags: ["wireless", "keyboard", "bluetooth"],
        createdAt: ISODate("2026-01-10T08:00:00Z")
    },
    {
        sku: "ACC-3002",
        name: "Wireless Mouse",
        category: "Accessories",
        price: 18500,
        attributes: {
            connectionType: "Bluetooth",
            batteryType: "AA",
            buttons: 6,
            adjustableDPI: true
        },
        tags: ["wireless", "mouse", "bluetooth"],
        createdAt: ISODate("2026-01-11T08:00:00Z")
    },
    {
        sku: "ACC-3003",
        name: "USB-C Docking Station",
        category: "Accessories",
        price: 78000,
        attributes: {
            connectionType: "USB-C",
            hdmiPorts: 2,
            usbPorts: 4,
            supportsPowerDelivery: true
        },
        tags: ["usb-c", "docking", "business"],
        createdAt: ISODate("2026-01-12T08:00:00Z")
    },
    {
        sku: "NET-4001",
        name: "Dual Band Wireless Router",
        category: "Networking",
        price: 65000,
        attributes: {
            wirelessStandard: "Wi-Fi 6",
            frequencyBands: ["2.4GHz", "5GHz"],
            ethernetPorts: 4,
            maximumSpeedMbps: 1800
        },
        tags: ["router", "wifi-6", "networking"],
        createdAt: ISODate("2026-01-13T08:00:00Z")
    },
    {
        sku: "NET-4002",
        name: "Eight-Port Network Switch",
        category: "Networking",
        price: 48000,
        attributes: {
            ethernetPorts: 8,
            managed: false,
            maximumSpeedMbps: 1000,
            mountingType: "Desktop"
        },
        tags: ["switch", "ethernet", "networking"],
        createdAt: ISODate("2026-01-14T08:00:00Z")
    }
]);

db.products.createIndex(
    { sku: 1 },
    {
        unique: true,
        name: "unique_product_sku"
    }
);

print("Catalogue setup completed");

printjson({
    database: db.getName(),
    collection: "products",
    productCount: db.products.countDocuments()
});
