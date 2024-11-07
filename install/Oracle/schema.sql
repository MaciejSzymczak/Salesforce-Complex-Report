  CREATE TABLE OPP_CONTINUITY 
   (	ID VARCHAR2(26 BYTE), 
	TK_LEGACY_ID__C VARCHAR2(100 BYTE), 
	STAGENAME VARCHAR2(50 BYTE), 
	SERVICE_START_DATE__C VARCHAR2(26 BYTE), 
	SERVICE_END_DATE__C VARCHAR2(26 BYTE), 
	RECORDTYPE_NAME VARCHAR2(200 BYTE), 
	ACCOUNT_NAME VARCHAR2(200 BYTE), 
	ACCOUNT_ID VARCHAR2(26 BYTE), 
	OWNER_NAME VARCHAR2(200 BYTE), 
	ACCOUNT_OWNER_NAME VARCHAR2(200 BYTE), 
	ACCOUNT_RECORDTYPE_NAME VARCHAR2(200 BYTE), 
	ISCLOSED VARCHAR2(26 BYTE), 
	ACCOUNT_ACTIVE_CLIENT__C VARCHAR2(26 BYTE), 
	ACCOUNT_LOST_DATE__C VARCHAR2(26 BYTE)
   );
   
create index opp_continuity1 on opp_continuity(stagename);
create index opp_continuity2 on opp_continuity(account_id);
create index opp_continuity3 on opp_continuity(service_start_date__c);
create index opp_continuity4 on opp_continuity(service_end_date__c);
create index opp_continuity5 on opp_continuity(recordtype_name);
create index opp_continuity6 on opp_continuity(account_recordtype_name);
create index opp_continuity7 on opp_continuity(isclosed);

create table opp_continuity_temp as select * from opp_continuity
create index opp_continuityt1 on opp_continuity_temp(stagename);
create index opp_continuityt2 on opp_continuity_temp(account_id);
create index opp_continuityt3 on opp_continuity_temp(service_start_date__c);
create index opp_continuityt4 on opp_continuity_temp(service_end_date__c);
create index opp_continuityt5 on opp_continuity_temp(recordtype_name);
create index opp_continuityt6 on opp_continuity_temp(account_recordtype_name);
create index opp_continuityt7 on opp_continuity_temp(isclosed);
