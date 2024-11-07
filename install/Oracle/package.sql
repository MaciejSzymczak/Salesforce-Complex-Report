create or replace NONEDITIONABLE package  opp_continuity_pkg is  

    /* opp_continuity_pkg 
       @author Maciej Szymczak
       @version 2022-10-04       
     */

    procedure prepare (pAccountFilter varchar2, pOppFilter varchar2);  
    function getList  return clob;  
end;
/

create or replace package body opp_continuity_pkg is  
     res clob;  
     currentDateTime varchar2(100);

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure prepare (pAccountFilter varchar2, pOppFilter varchar2) is
    begin
        execute immediate 'truncate table opp_continuity_temp'; 
        execute immediate 'insert into opp_continuity_temp select * from  opp_continuity where '||pAccountFilter||' and '||pOppFilter;        
    end prepare;

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function getList return clob is 

            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  

            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  

    --------------------------------------------------------------   
    begin
     select to_char(sysdate,'yyyy-mm-dd') into currentDateTime from dual;

        NewClob(res, '');   
        WriteToClob(res,     
'<!DOCTYPE html>
<html>
<head>
<title>Title of the document</title>

<style>
table {
  border-collapse: collapse;
  border: 1px solid #CCCCCC;
}

table td {
  border: 1px solid #CCCCCC;
}

.greenCell {
  background-color: #C6EFCE;
  color: #006100;
}

.redCell {
  background-color: #FFC7CE;
  color: #9C0006;
}


</style>

</head>

<body>
<br/>
<center><strong>MED Opportunities: Continuity Report</strong> as of ' || currentDateTime  || '</center>
<br/>
<table>
  <tr>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td colspan="12">2019</td>
    <td colspan="12">2020</td>
    <td colspan="12">2021</td>
    <td colspan="12">2022</td>
    <td>Lost Date</td>
  </tr>
  <tr>
    <td>Acount Owner</td>
    <td>Account</td>
    <td>Id</td>
    <td>Active?</td>
    <td>Sfdc Lost Date</td>
    <td>01</td>
    <td>02</td>
    <td>03</td>
    <td>04</td>
    <td>05</td>
    <td>06</td>
    <td>07</td>
    <td>08</td>
    <td>09</td>
    <td>10</td>
    <td>11</td>
    <td>12</td>
    <td>01</td>
    <td>02</td>
    <td>03</td>
    <td>04</td>
    <td>05</td>
    <td>06</td>
    <td>07</td>
    <td>08</td>
    <td>09</td>
    <td>10</td>
    <td>11</td>
    <td>12</td>
    <td>01</td>
    <td>02</td>
    <td>03</td>
    <td>04</td>
    <td>05</td>
    <td>06</td>
    <td>07</td>
    <td>08</td>
    <td>09</td>
    <td>10</td>
    <td>11</td>
    <td>12</td>
    <td>01</td>
    <td>02</td>
    <td>03</td>
    <td>04</td>
    <td>05</td>
    <td>06</td>
    <td>07</td>
    <td>08</td>
    <td>09</td>
    <td>10</td>
    <td>11</td>
    <td>12</td>
    <td></td>
  </tr>
');    

declare
      maxDate varchar2(10);
      lostDate varchar2(10);
begin
for rec in (select unique account_owner_name, account_name, account_id, account_active_client__c, account_lost_date__c from opp_continuity where account_recordtype_name in (select unique account_recordtype_name from opp_continuity_temp) order by account_owner_name,account_name,account_id) loop
maxDate := null;
lostDate := '2019-01-01';
WriteToClob(res,'
  <tr>
    <td>'|| rec.account_owner_name ||'</td>
    <td>'|| replace(rec.account_name,'&','&amp;') ||'</td>
    <td>'|| rec.account_id ||'</td>
    <td>'|| rec.account_active_client__c ||'</td>
    <td>'|| rec.account_lost_date__c ||'</td>'
    );
    
    declare
      prior_c number := 0;
    begin
    FOR year IN 2019 .. 2022
    LOOP 
        FOR month IN 1 .. 12
        LOOP             
            declare 
             c number;
             cmonth varchar2(10);
            begin
                cmonth := year || '-' || lpad(month,2, '0') || '-' || '15'; 
                select count(Id), max(service_end_date__c) into c, maxDate from opp_continuity_temp where account_id=rec.account_id and cmonth between service_start_date__c and service_end_date__c;
                if c = 0 and prior_c >0  then WriteToClob(res,'<td class="redCell"></td>'); end if;
                if c = 0 and prior_c = 0 then WriteToClob(res,'<td></td>'); end if;
                if c = 1 then WriteToClob(res,'<td class="greenCell"></td>'); end if;
                if c > 1 then WriteToClob(res,'<td class="greenCell">'||c||'</td>'); end if;
                prior_c := c;
                lostDate := nvl(maxDate,lostDate);
            end;
        END LOOP;    
    END LOOP;    
    end;

if lostDate >= '2022-12-01' then lostDate :=null; end if;
WriteToClob(res,'<td>'||lostDate||'</td>'); 
WriteToClob(res,'</tr>');
end loop;
end;

WriteToClob(res,'
</table>

</body>

</html>');  

       return res;  

   end getList;

end;
/
