-- User
DROP TABLE Users CASCADE CONSTRAINTS;

CREATE TABLE Users (
    userID VARCHAR2(6) NOT NULL,
    firstName VARCHAR2(100) NOT NULL,
    lastName VARCHAR2(100) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    cellPhone VARCHAR2(15),
    CONSTRAINT users_pk PRIMARY KEY (userID)
);

-- Account
DROP TABLE Account CASCADE CONSTRAINTS;

CREATE TABLE Account (
    accountID VARCHAR2(6) NOT NULL,                    
    userID VARCHAR2(6) NOT NULL,                    
    loginID VARCHAR2(100) UNIQUE NOT NULL,             
    password VARCHAR2(255) NOT NULL,             
    creationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    CONSTRAINT account_pk PRIMARY KEY (accountID),   
    CONSTRAINT account_fk FOREIGN KEY (userID) REFERENCES Users(userID) 
);

-- Residential Account
DROP TABLE ResidentialAccount CASCADE CONSTRAINTS;

CREATE TABLE ResidentialAccount (
    resAccountID VARCHAR2(6) NOT NULL, 
    street VARCHAR2(255) NOT NULL, 
    city VARCHAR2(100) NOT NULL,  
    state CHAR(2) NOT NULL, 
    zipcode CHAR(5) NOT NULL,
    CONSTRAINT resAccount_pk PRIMARY KEY (resAccountID),  
    CONSTRAINT resAccount_fk FOREIGN KEY (resAccountID) REFERENCES Account(accountID)
);

-- Residential Property
DROP TABLE ResidentialProperty CASCADE CONSTRAINTS;

CREATE TABLE ResidentialProperty (
    resPropertyID VARCHAR2(6) NOT NULL, 
    householdSize NUMBER(2) NOT NULL, 
    totalArea NUMBER(4) NOT NULL, 
    resAccountID VARCHAR2(6) NOT NULL,
    CONSTRAINT resProperty_pk PRIMARY KEY (resPropertyID),  
    CONSTRAINT resProperty_fk FOREIGN KEY (resAccountID) REFERENCES ResidentialAccount(resAccountID),
    CONSTRAINT chk_resTotalArea CHECK (totalArea > 0),
    CONSTRAINT chk_resHouseholdSize CHECK (householdSize > 0)        
);

-- Residential Appliance
DROP TABLE ResidentialAppliance CASCADE CONSTRAINTS;

CREATE TABLE ResidentialAppliance (
    applianceID VARCHAR2(6) NOT NULL,        
    resPropertyID VARCHAR2(6) NOT NULL,       
    type VARCHAR2(50) NOT NULL,            
    brand VARCHAR2(50),                      
    CONSTRAINT resAppliance_pk PRIMARY KEY (applianceID, resPropertyID), 
    CONSTRAINT resAppliance_fk FOREIGN KEY (resPropertyID) REFERENCES ResidentialProperty(resPropertyID)
);

-- Residential Billing Tariff
DROP TABLE ResBillingTariff CASCADE CONSTRAINTS;

CREATE TABLE ResBillingTariff (
    tariffID VARCHAR2(6) NOT NULL,             
    state CHAR(2) NOT NULL,               
    costPerWatt NUMBER(6, 2) NOT NULL,        
    validFrom VARCHAR2(5) NOT NULL,                 
    validTo VARCHAR2(5) NOT NULL,                              
    CONSTRAINT resBillingTariff_pk PRIMARY KEY (tariffID),  
    CONSTRAINT chk_resCostPerWatt CHECK (costPerWatt >= 0)  
);


-- Residential Energy Usage
DROP TABLE ResEnergyUsage CASCADE CONSTRAINTS;

CREATE TABLE ResEnergyUsage (
    metricID VARCHAR2(6) NOT NULL,             
    applianceID VARCHAR2(6) NOT NULL,   
    resPropertyID VARCHAR2(6) NOT NULL,         
    fromTime TIMESTAMP NOT NULL,             
    toTime TIMESTAMP NOT NULL,                
    energyConsumedKWh NUMBER(10,2) NOT NULL,                 
    tariffID VARCHAR2(6) NOT NULL,             
    CONSTRAINT resEnergyUsage_pk PRIMARY KEY (metricID, applianceID, resPropertyID),  
    CONSTRAINT resEnergyUsage_fk_appliance FOREIGN KEY (applianceID, resPropertyID) REFERENCES ResidentialAppliance,  
    CONSTRAINT resEnergyUsage_fk_tariff FOREIGN KEY (tariffID) REFERENCES ResBillingTariff(tariffID)         
);



-- Commercial Account
DROP TABLE CommercialAccount CASCADE CONSTRAINTS;

CREATE TABLE CommercialAccount (
    comAccountID VARCHAR2(6) NOT NULL, 
    companyName VARCHAR2(255) NOT NULL,
    street VARCHAR2(255) NOT NULL, 
    city VARCHAR2(100) NOT NULL,  
    state CHAR(2) NOT NULL, 
    zipcode CHAR(5) NOT NULL,
    CONSTRAINT comAccount_pk PRIMARY KEY (comAccountID),  
    CONSTRAINT comAccount_fk FOREIGN KEY (comAccountID) REFERENCES Account(accountID)
);


-- Commercial Property
DROP TABLE CommercialProperty CASCADE CONSTRAINTS;

CREATE TABLE CommercialProperty (
    comPropertyID VARCHAR2(6) NOT NULL, 
    propType VARCHAR2(50) NOT NULL, 
    totalArea NUMBER(6) NOT NULL, 
    comAccountID VARCHAR2(6) NOT NULL,
    CONSTRAINT comProperty_pk PRIMARY KEY (comPropertyID),  
    CONSTRAINT comProperty_fk FOREIGN KEY (comAccountID) REFERENCES CommercialAccount(comAccountID),
    CONSTRAINT chk_comTotalArea CHECK (totalArea > 0)       
);

-- Unit
DROP TABLE Unit CASCADE CONSTRAINTS;

CREATE TABLE Unit (
    unitNum VARCHAR2(6) NOT NULL,          
    unitName VARCHAR2(100),                
    unitDesc VARCHAR2(255),                
    comPropertyID VARCHAR2(6) NOT NULL,    
    CONSTRAINT unit_pk PRIMARY KEY (unitNum, comPropertyID),  
    CONSTRAINT unit_fk FOREIGN KEY (comPropertyID) REFERENCES CommercialProperty(comPropertyID)
);

-- Commercial Unit
DROP TABLE CommercialUnit CASCADE CONSTRAINTS;

CREATE TABLE CommercialUnit (
    comUnitID VARCHAR2(6) NOT NULL,          
    unitType VARCHAR2(50) NOT NULL, 
    totalArea NUMBER(6) NOT NULL,                
    comAccountID VARCHAR2(6) NOT NULL,    
    CONSTRAINT comUnit_pk PRIMARY KEY (comUnitID),  
    CONSTRAINT comUnit_fk FOREIGN KEY (comAccountID) REFERENCES CommercialAccount(comAccountID),
    CONSTRAINT chk_unitTotalArea CHECK (totalArea > 0) 
);

-- Commercial Appliance
DROP TABLE CommercialAppliance CASCADE CONSTRAINTS;

CREATE TABLE CommercialAppliance (
    applianceID VARCHAR2(6) NOT NULL,          
    unitNum VARCHAR2(6) NOT NULL, 
    comPropertyID VARCHAR2(6) NOT NULL,            
    type VARCHAR2(50) NOT NULL,                
    brand VARCHAR2(50),                        
    CONSTRAINT comAppliance_pk PRIMARY KEY (applianceID, unitNum, comPropertyID),  
    CONSTRAINT comAppliance_fk FOREIGN KEY (unitNum, comPropertyID) REFERENCES Unit
);


-- Commercial Appliance - Alternative
DROP TABLE CommercialApplianceAlt CASCADE CONSTRAINTS;

CREATE TABLE CommercialApplianceAlt (
    applianceID VARCHAR2(6) NOT NULL,          
    comUnitID VARCHAR2(6) NOT NULL,             
    type VARCHAR2(50) NOT NULL,                
    brand VARCHAR2(50),                        
    CONSTRAINT comApplianceAlt_pk PRIMARY KEY (applianceID, comUnitID),  
    CONSTRAINT comApplianceAlt_fk FOREIGN KEY (comUnitID) REFERENCES CommercialUnit(comUnitID)
);


-- Commercial Billing Tariff
DROP TABLE ComBillingTariff CASCADE CONSTRAINTS;

CREATE TABLE ComBillingTariff (
    tariffID VARCHAR2(6) NOT NULL,             
    state CHAR(2) NOT NULL,               
    costPerWatt NUMBER(6, 2) NOT NULL,        
    validFrom VARCHAR2(5) NOT NULL,                 
    validTo VARCHAR2(5) NOT NULL,                              
    CONSTRAINT comBillingTariff_pk PRIMARY KEY (tariffID),  
    CONSTRAINT chk_cmCostPerWatt CHECK (costPerWatt >= 0)  
);

-- Commercial Energy Usage
DROP TABLE ComEnergyUsage CASCADE CONSTRAINTS;

CREATE TABLE ComEnergyUsage (
    metricID VARCHAR2(6) NOT NULL,             
    applianceID VARCHAR2(6) NOT NULL,  
    unitNum VARCHAR2(6) NOT NULL, 
    comPropertyID VARCHAR2(6) NOT NULL,         
    fromTime TIMESTAMP NOT NULL,             
    toTime TIMESTAMP NOT NULL,                
    energyConsumedKWh NUMBER(10,2) NOT NULL,                 
    tariffID VARCHAR2(6) NOT NULL,             
    CONSTRAINT comEnergyUsage_pk PRIMARY KEY (metricID, applianceID, unitNum, comPropertyID),  
    CONSTRAINT comEnergyUsage_fk_appliance FOREIGN KEY (applianceID, unitNum, comPropertyID) REFERENCES CommercialAppliance,  
    CONSTRAINT comEnergyUsage_fk_tariff FOREIGN KEY (tariffID) REFERENCES ComBillingTariff(tariffID)         
);

-- Commercial Energy Usage - Alternative
DROP TABLE ComEnergyUsageAlt CASCADE CONSTRAINTS;

CREATE TABLE ComEnergyUsageAlt (
    metricID VARCHAR2(6) NOT NULL,             
    applianceID VARCHAR2(6) NOT NULL,  
    comUnitID VARCHAR2(6) NOT NULL,         
    fromTime TIMESTAMP NOT NULL,             
    toTime TIMESTAMP NOT NULL,                
    energyConsumedKWh NUMBER(10,2) NOT NULL,                 
    tariffID VARCHAR2(6) NOT NULL,             
    CONSTRAINT comEnergyUsageAlt_pk PRIMARY KEY (metricID, applianceID, comUnitID),  
    CONSTRAINT comEnergyUsageAlt_fk_appliance FOREIGN KEY (applianceID, comUnitID) REFERENCES CommercialApplianceAlt,  
    CONSTRAINT comEnergyUsageAlt_fk_tariff FOREIGN KEY (tariffID) REFERENCES ComBillingTariff(tariffID)         
);
