create or replace view vSCAccMapping as
/*
Синкевич С.Л.: создание дополнительной таблицы
для описания счетов учета денежных средств

22/03/2016
Петренко И.М.: корректировка для работы с бд технокуба v81c_tcacc@tacc
сделана на основании select * from Acc21

*/
select level LevelID,
       case level
         when 1 then '8206E5F79D2D9E6B4A3902A4FDA09DF0'
         when 2 then 'AD44B67DDA59DCF445D989309D4666B7'
         when 3 then 'B15255EDA401994745EB5A92500F985C'  
         when 4 then '8ACD33C7CA3FC4CB471CAECC9DFAB451'                     
         when 5 then 'B011CA2D740C40E541C93A7D75D7A1A0'                     
         when 6 then 'B40D87BDC723798F437E9DD910D2FF67'                     
         when 7 then 'AEA08F16BDAF1DE1456BB9784FF758BD'                     
         when 8 then '9BB21FEB8AFFAFB84234C0F57DE24DF3'                     
       end AccRefID,
       
       case level
         when 1 then 'Касса организации'          -- 50.1
         when 2 then 'Операционная касса'         -- 50.2
         when 3 then 'Валютная касса'             -- 50.4
         when 4 then 'Касса филиала'              -- 50.5
         when 5 then 'Расчетные счета'            -- 51
         when 6 then 'Валютные расчетные счета'   -- 52  
         when 7 then 'Депозитные счета'           -- 55.1  
         when 8 then 'Депозитные счета в валюте'  -- 55.11 
       end AccDescription
       
  from dual
connect by level <= 8

