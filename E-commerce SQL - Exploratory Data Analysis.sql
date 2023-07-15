-- Commands
-- SELECT * FROM COMMAND
-- To query the address, starttime and endtime of the servicepoints in the same city as userid 5   
SELECT streetaddr,starttime,endtime
FROM ServicePoint
WHERE ServicePoint.city IN (SELECT Address.city FROM Address WHERE userid=5);


-- To query the information of laptops
SELECT *
FROM Product
WHERE type='laptop';

-- To query the total quantity of products from store with storeid 8 in the shopping cart
SELECT SUM(quantity) AS totalQuantity
FROM Save_to_Shopping_Cart
WHERE Save_to_Shopping_Cart.pid IN (SELECT Product.pid FROM Product WHERE sid=8);

-- To query the name and address of orders delivered on 2017-02-17
SELECT name, streetaddr, city
FROM Address
WHERE addrid IN (SELECT addrid FROM Deliver_To WHERE TimeDelivered = '2017-02-17');


 -- To query the comments of pid 2 
 SELECT *
 FROM Comments
 WHERE pid = 2; 

-- ------------------------------------------- --
-- Data Modification

-- Insert the user id of sellers whose name starts with A into buyer
INSERT INTO buyer
SELECT * FROM seller
WHERE userid IN (SELECT userid FROM users WHERE name LIKE 'A%');

select * from buyer;

-- Update the payment state of orders to unpaid which created after year 2017 and with total amount greater than 50.
UPDATE Orders
SET paymentState = 'Unpaid'
WHERE creationTime > '2017-01-01' AND totalAmount > 50;

-- Update the name and contact phone number of address where the provice is Quebec and city is montreal.
UPDATE address
SET name = 'Awesome Lady', contactPhoneNumber ='1234567'
WHERE province = 'Quebec' AND city = 'Montreal';

-- Delete the store which opened before year 2017
DELETE FROM save_to_shopping_cart
WHERE addTime < '2017-01-01';

select * from save_to_shopping_cart;

-- ------------------------------------------- --

-- Views 
-- Create view of all products whose price above average price.
CREATE VIEW Products_Above_Average_Price AS
SELECT pid, name, price 
FROM Product
WHERE price > (SELECT AVG(price) FROM Product);

select * from products_above_average_price;

-- Update the view
UPDATE Products
SET price = 1
WHERE name = 'GoPro HERO5';

-- Create view of all products sales in 2016.
CREATE VIEW Product_Sales_For_2016 AS
SELECT pid, name, price
FROM Product
WHERE pid IN (SELECT pid FROM OrderItem WHERE itemid IN 
              (SELECT itemid FROM Contain WHERE orderNumber IN
               (SELECT orderNumber FROM Payment WHERE payTime > '2016-01-01' AND payTime < '2016-12-31')
              )
             );


-- Update the view
UPDATE product_sales_for_2016
SET price = 2
WHERE name = 'GoPro HERO5';

-- ------------------------------------------- --

-- Check Constraints
-- Check whether the products saved to the shopping cart after the year 2017 has quantities of smaller than 10.
DROP TABLE Save_to_Shopping_Cart;
CREATE TABLE Save_to_Shopping_Cart
(
    userid INT NOT NULL
    ,pid INT NOT NULL
    ,addTime DATE
    ,quantity INT
    ,PRIMARY KEY (userid,pid)
    ,FOREIGN KEY(userid) REFERENCES Buyer(userid)
    ,FOREIGN KEY(pid) REFERENCES Product(pid)
    ,CHECK (quantity <= 10 OR addTime > '2017-01-01')
);

-------------------------------------END-------------------------------------
