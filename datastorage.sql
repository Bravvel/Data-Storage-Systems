-- Создание схемы
CREATE SCHEMA IF NOT EXISTS student39;

-- =======================================================
-- 1. ХАБЫ (HUBS)
-- =======================================================

-- HUB_Customer: Сегмент
CREATE TABLE student39.HUB_Customer (
    HK_Customer CHAR(64) NOT NULL PRIMARY KEY,
    BK_Segment VARCHAR(50) NOT NULL,
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- HUB_Product: Категория и Подкатегория
CREATE TABLE student39.HUB_Product (
    HK_Product CHAR(64) NOT NULL PRIMARY KEY,
    BK_Category VARCHAR(50) NOT NULL,
    BK_Sub_Category VARCHAR(50) NOT NULL,
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- HUB_Location: Почтовый Индекс
CREATE TABLE student39.HUB_Location (
    HK_Location CHAR(64) NOT NULL PRIMARY KEY,
    BK_Postal_Code VARCHAR(10) NOT NULL,
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- HUB_Market: Регион
CREATE TABLE student39.HUB_Market (
    HK_Market CHAR(64) NOT NULL PRIMARY KEY,
    BK_Region VARCHAR(20) NOT NULL,
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- =======================================================
-- 2. СВЯЗИ (LINKS)
-- =======================================================

-- LINK_LocationToMarket: Связь Почтового Индекса и Региона
CREATE TABLE student39.LINK_LocationToMarket (
    HK_LocToMarket CHAR(64) NOT NULL PRIMARY KEY,
    HK_Location CHAR(64) NOT NULL REFERENCES student39.HUB_Location (HK_Location),
    HK_Market CHAR(64) NOT NULL REFERENCES student39.HUB_Market (HK_Market),
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- LINK_SaleTransaction: Продажа
CREATE TABLE student39.LINK_SaleTransaction (
    HK_SaleTransaction CHAR(64) NOT NULL PRIMARY KEY,
    HK_Customer CHAR(64) NOT NULL REFERENCES student39.HUB_Customer (HK_Customer),
    HK_Product CHAR(64) NOT NULL REFERENCES student39.HUB_Product (HK_Product),
    HK_Location CHAR(64) NOT NULL REFERENCES student39.HUB_Location (HK_Location),
    LoadDate TIMESTAMP NOT NULL,
    RecordSource VARCHAR(100) NOT NULL
);

-- =======================================================
-- 3. САТЕЛЛИТЫ (SATELLITES)
-- =======================================================

-- SAT_CustomerDetails (к HUB_Customer)
CREATE TABLE student39.SAT_CustomerDetails (
    HK_Customer CHAR(64) NOT NULL REFERENCES student39.HUB_Customer (HK_Customer),
    LoadDate TIMESTAMP NOT NULL,
    Segment VARCHAR(50),
    RecordSource VARCHAR(100) NOT NULL,
    PRIMARY KEY (HK_Customer, LoadDate)
);

-- SAT_MarketDetails (к HUB_Market)
CREATE TABLE student39.SAT_MarketDetails (
    HK_Market CHAR(64) NOT NULL REFERENCES student39.HUB_Market (HK_Market),
    LoadDate TIMESTAMP NOT NULL,
    Country VARCHAR(50),
    RecordSource VARCHAR(100) NOT NULL,
    PRIMARY KEY (HK_Market, LoadDate)
);

-- SAT_LocationDetails (к HUB_Location)
CREATE TABLE student39.SAT_LocationDetails (
    HK_Location CHAR(64) NOT NULL REFERENCES student39.HUB_Location (HK_Location),
    LoadDate TIMESTAMP NOT NULL,
    City VARCHAR(100),
    State VARCHAR(100),
    RecordSource VARCHAR(100) NOT NULL,
    PRIMARY KEY (HK_Location, LoadDate)
);

-- SAT_ShippingDetails (к LINK_SaleTransaction)
CREATE TABLE student39.SAT_ShippingDetails (
    HK_SaleTransaction CHAR(64) NOT NULL REFERENCES student39.LINK_SaleTransaction (HK_SaleTransaction),
    LoadDate TIMESTAMP NOT NULL,
    Ship_Mode VARCHAR(50),
    RecordSource VARCHAR(100) NOT NULL,
    PRIMARY KEY (HK_SaleTransaction, LoadDate)
);

-- SAT_OrderMetrics (к LINK_SaleTransaction)
CREATE TABLE student39.SAT_OrderMetrics (
    HK_SaleTransaction CHAR(64) NOT NULL REFERENCES student39.LINK_SaleTransaction (HK_SaleTransaction),
    LoadDate TIMESTAMP NOT NULL,
    Sales NUMERIC(10, 4) NOT NULL,
    Quantity INTEGER NOT NULL,
    Discount NUMERIC(5, 4) NOT NULL,
    Profit NUMERIC(10, 4) NOT NULL,
    RecordSource VARCHAR(100) NOT NULL,
    PRIMARY KEY (HK_SaleTransaction, LoadDate)

);
