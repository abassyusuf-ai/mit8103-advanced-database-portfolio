-- MIT 8103 Advanced Database Systems
-- Portfolio 1: Sample Data

INSERT INTO branches (branch_name, city, address) VALUES
('Abuja Central Branch', 'Abuja', '12 Aminu Kano Crescent, Wuse 2'),
('Lagos Mainland Branch', 'Lagos', '25 Herbert Macaulay Way, Yaba'),
('Kano Commercial Branch', 'Kano', '18 Murtala Mohammed Way, Kano');

INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Amina', 'Bello', 'amina.bello@example.com', '08030000001'),
('Chinedu', 'Okafor', 'chinedu.okafor@example.com', '08030000002'),
('Fatima', 'Abubakar', 'fatima.abubakar@example.com', '08030000003'),
('Tunde', 'Adebayo', 'tunde.adebayo@example.com', '08030000004'),
('Grace', 'Eze', 'grace.eze@example.com', '08030000005'),
('Ibrahim', 'Musa', 'ibrahim.musa@example.com', '08030000006'),
('Ngozi', 'Nwosu', 'ngozi.nwosu@example.com', '08030000007'),
('Samuel', 'James', 'samuel.james@example.com', '08030000008');

INSERT INTO categories (category_name, description) VALUES
('Computers', 'Laptop and desktop computer systems'),
('Mobile Devices', 'Smartphones and tablets'),
('Accessories', 'Computer and mobile accessories'),
('Networking', 'Network devices and equipment');

INSERT INTO products
(category_id, sku, product_name, current_price) VALUES
(1, 'LAP-1001', 'Business Laptop 14 Inch', 685000.00),
(1, 'LAP-1002', 'Performance Laptop 15 Inch', 920000.00),
(1, 'DES-1001', 'Office Desktop Computer', 550000.00),
(2, 'PHN-2001', 'Android Smartphone 128GB', 285000.00),
(2, 'TAB-2001', 'Android Tablet 10 Inch', 340000.00),
(3, 'ACC-3001', 'Wireless Keyboard', 35000.00),
(3, 'ACC-3002', 'Wireless Mouse', 18500.00),
(3, 'ACC-3003', 'USB-C Docking Station', 78000.00),
(4, 'NET-4001', 'Dual Band Wireless Router', 65000.00),
(4, 'NET-4002', 'Eight-Port Network Switch', 48000.00);

INSERT INTO inventory
(branch_id, product_id, quantity, reorder_level)
SELECT
    branch_id,
    product_id,
    20 + ((branch_id * product_id * 7) % 81),
    15
FROM branches
CROSS JOIN products;

INSERT INTO orders
(customer_id, branch_id, order_status, ordered_at) VALUES
(1, 1, 'COMPLETED', '2026-01-05 09:15:00+01'),
(2, 2, 'COMPLETED', '2026-01-08 11:30:00+01'),
(3, 1, 'PAID', '2026-01-11 14:10:00+01'),
(4, 3, 'PROCESSING', '2026-01-15 10:45:00+01'),
(5, 2, 'COMPLETED', '2026-01-19 16:20:00+01'),
(6, 3, 'PENDING', '2026-01-22 12:00:00+01'),
(7, 1, 'COMPLETED', '2026-02-03 08:50:00+01'),
(8, 2, 'PAID', '2026-02-07 13:35:00+01'),
(1, 3, 'CANCELLED', '2026-02-12 15:40:00+01'),
(3, 1, 'PROCESSING', '2026-02-18 09:25:00+01');

INSERT INTO order_items
(order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 685000.00),
(1, 6, 1, 35000.00),
(2, 4, 2, 285000.00),
(2, 7, 2, 18500.00),
(3, 2, 1, 920000.00),
(3, 8, 1, 78000.00),
(4, 9, 3, 65000.00),
(5, 3, 1, 550000.00),
(5, 6, 2, 35000.00),
(6, 5, 1, 340000.00),
(7, 10, 4, 48000.00),
(8, 4, 1, 285000.00),
(8, 7, 1, 18500.00),
(9, 8, 1, 78000.00),
(10, 1, 1, 685000.00),
(10, 9, 1, 65000.00);

INSERT INTO payments
(order_id, amount, payment_method, payment_status,
 transaction_reference, paid_at) VALUES
(1, 720000.00, 'TRANSFER', 'SUCCESSFUL', 'MIT8103-TXN-0001',
 '2026-01-05 09:30:00+01'),
(2, 607000.00, 'CARD', 'SUCCESSFUL', 'MIT8103-TXN-0002',
 '2026-01-08 11:45:00+01'),
(3, 998000.00, 'TRANSFER', 'SUCCESSFUL', 'MIT8103-TXN-0003',
 '2026-01-11 14:25:00+01'),
(4, 195000.00, 'MOBILE_MONEY', 'SUCCESSFUL',
 'MIT8103-TXN-0004', '2026-01-15 11:00:00+01'),
(5, 620000.00, 'CARD', 'SUCCESSFUL', 'MIT8103-TXN-0005',
 '2026-01-19 16:35:00+01'),
(7, 192000.00, 'CASH', 'SUCCESSFUL', 'MIT8103-TXN-0007',
 '2026-02-03 09:05:00+01'),
(8, 303500.00, 'TRANSFER', 'SUCCESSFUL', 'MIT8103-TXN-0008',
 '2026-02-07 13:50:00+01');