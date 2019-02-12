


# option_value column length should be increased in list_value table.

DELETE FROM carrier_account;
DELETE FROM service_level;

INSERT INTO carrier_account(account_id, type, description, readable) VALUE ('ca_c9f110e4c7ae4258912db23fcea1cefb', 'UpsAccount' , 'USPS', 'USPS-EasyPost');
INSERT INTO carrier_account(account_id, type, description, readable) VALUE ('ca_8a4df66928a847e397a6484d6db7cb2f', 'UpsAccount' , 'UPS', 'UPS-EasyPost');
INSERT INTO carrier_account(account_id, type, description, readable) VALUE ('ca_455b380a245143ca87916e644c7ea484', 'UpsAccount' , 'FedEx', 'FedEx-EasyPost');
INSERT INTO carrier_account(account_id, type, description, readable) VALUE ('ca_73b97dfc8d134ddc800ca0d7687dd70b', 'UpsAccount' , 'DHLExpress', 'DHL Express-EasyPost');



INSERT INTO service_level(id, carrier_account_id, description) VALUE ('1', 'USPS-EasyPost', 'FirstClass');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('2', 'USPS-EasyPost', 'Priority');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('3', 'USPS-EasyPost', 'Express');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('4', 'USPS-EasyPost', 'ParcelSelect');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('5', 'USPS-EasyPost', 'LibraryMail');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('6', 'USPS-EasyPost', 'MediaMail');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('7', 'USPS-EasyPost', 'StandardPost');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('8', 'USPS-EasyPost', 'CriticalMail');

INSERT INTO service_level(id, carrier_account_id, description) VALUE ('12', 'UPS-EasyPost', 'Ground');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('13', 'UPS-EasyPost', 'UPSStandard');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('14', 'UPS-EasyPost', 'UPSSaver');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('15', 'UPS-EasyPost', 'Express');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('16', 'UPS-EasyPost', 'ExpressPlus');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('17', 'UPS-EasyPost', 'Expedited');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('18', 'UPS-EasyPost', 'NextDayAir');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('19', 'UPS-EasyPost', 'NextDayAirSaver');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('20', 'UPS-EasyPost', 'NextDayAirEarlyAM');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('21', 'UPS-EasyPost', '2ndDayAir');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('22', 'UPS-EasyPost', '2ndDayAirAM');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('23', 'UPS-EasyPost', '3DaySelect ');

INSERT INTO service_level(id, carrier_account_id, description) VALUE ('24', 'FedEx-EasyPost', 'FEDEX_GROUND');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('25', 'FedEx-EasyPost', 'FEDEX_2_DAY');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('26', 'FedEx-EasyPost', 'FEDEX_2_DAY_AM');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('27', 'FedEx-EasyPost', 'FEDEX_EXPRESS_SAVER');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('28', 'FedEx-EasyPost', 'STANDARD_OVERNIGHT');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('29', 'FedEx-EasyPost', 'FIRST_OVERNIGHT');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('30', 'FedEx-EasyPost', 'PRIORITY_OVERNIGHT');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('34', 'FedEx-EasyPost', 'GROUND_HOME_DELIVERY');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('35', 'FedEx-EasyPost', 'SMART_POST');

INSERT INTO service_level(id, carrier_account_id, description) VALUE ('36', 'DHL Express-EasyPost', 'DomesticEconomySelect');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('37', 'DHL Express-EasyPost', 'DomesticExpress');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('38', 'DHL Express-EasyPost', 'EconomySelectNonDoc');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('39', 'DHL Express-EasyPost', 'ExpressEasyNonDoc');
INSERT INTO service_level(id, carrier_account_id, description) VALUE ('40', 'DHL Express-EasyPost', 'ExpressWorldwide');
