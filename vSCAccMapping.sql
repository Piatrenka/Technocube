create or replace view vSCAccMapping as
/*
Синкевич С.Л.: создание дополнительной таблицы
для описания счетов учета денежных средств
*/
select level LevelID,
       case level
         when 1 then '8206E5F79D2D9E6B4A3902A4FDA09DF0'
         when 2 then 'AD44B67DDA59DCF445D989309D4666B7'
         when 3 then 'B15255EDA401994745EB5A92500F985C'  
         when 4 then '8ACD33C7CA3FC4CB471CAECC9DFAB451'                     
         when 5 then 'B011CA2D740C40E541C93A7D75D7A1A0'                     
         when 6 then '840C005056BD001311E0A6FC82BB1AC4'                     
         when 7 then '840C005056BD001311E0A6FC82BB1AC5'                     
         when 8 then '840C005056BD001311E0A6FC82BB1AC6'                     
         when 9 then '840C005056BD001311E0A6FC82BB1AC7'                     
       end AccRefID,
       
       case level
         when 1 then 'Касса организации'          -- 50.1
         when 2 then 'Операционная касса'         -- 50.2
         when 3 then 'Валютная касса'             -- 50.4
         when 4 then 'Касса филиала'              -- 50.5
         when 5 then 'Расчетные счета'            -- 51
         when 6 then 'Валютные расчетные счета'   -- 52.1  
         when 7 then 'Валютные специальные счета' -- 52.2  
         when 8 then 'Валютные транзитные счета'  -- 52.3  
         when 9 then 'Валютные ссудные счета'     -- 52.4  
       end AccDescription
       
  from dual
connect by level <= 9
