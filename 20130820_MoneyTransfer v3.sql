--------------------------------------------------------------------------
-- Синкевич
-- Движения денежных средств за период. Формируется по всем счетам (касса, 
-- расчетные счета в валюте и в рублях). Учитываются все движения, в том числе и 
-- ручные проводки, если они имели место. 
--       Branch                 - наименование организации
--       AccountCode            - код счета из плана счетов
--       AccountName            - наименование счета из плана счетов
--       DocDate                - дата осуществления операции
--       DocNum                 - внутренний номер документа 1С
--       DocBankNumber          - номер документа в банке                    
--       Client                 - наименование клиента  
--       Contract               - наименование клиента
--       BankAccountBranch      - расчетный счет организации
--       BankAccountClient      - расчетный счет контрагента                                     
--       DocType                - тип документа
--       PaymentDescription     - текстовая расшифровка платежа как в банке
--       Currency               - наименование валюты в случае валютных движений
--       TextDescription        - текстовое описание платежа
--       OutPut_Amount          - сумма списания денежных средств в бел. руб.
--       OutPut_CurrencyAmount  - сумма списания денежных средств в валюте
--       InPut_Amount           - сумма поступления денежных средств в бел. руб.
--       InPut_CurrencyAmount   - сумма поступления денежных средств в валюте
--------------------------------------------------------------------------

     select 
          MTable.Branch,
          MTable.AccountCode,
          MTable.AccountName,
          trunc(MTable.Period)as DocDate,
          Doc.Fnumber as DocNum,
          Doc.DocBankNumber,                    
          Doc.Client,
          Doc.Contract,
          Doc.BankAccountBranch,
          Doc.BankAccountClient,                                     
          Doc.DocType,
          Doc.PaymentDescription,
          MTable.Currency,
          MTable.TextDescription,
          MTable.OutPut_Amount,
          MTable.OutPut_CurrencyAmount,
          MTable.InPut_Amount,
          MTable.InPut_CurrencyAmount
       From(
         select 
            MoneyTable.RecordID as Registrator,
            BranchObject.Fdescription Branch,
            AccObject.Fcode AccountCode,
            AccObject.Fdescription AccountName,
            MoneyTable.Period as Period,
            CurrenceObject.Fdescription Currency,
             MoneyTable.TextDescription,
            MoneyTable.OutPut_Amount,
            MoneyTable.OutPut_CurrencyAmount,
            MoneyTable.InPut_Amount,
            MoneyTable.InPut_CurrencyAmount
         From   
           (SELECT 
              AccRg588.Frecorderrref as RecordID,                           
              AccRg588.Faccountdtrref as Account,
              AccRg588.FFld589RRef as Organisation,
              AccRg588.Frecordertref as Registrator,
              AccRg588.Fperiod as Period,
              AccRg588.FFld590DtRRef as Currency,
              AccRg588.FFld594 as TextDescription,
              AccRg588.FFld591 as InPut_Amount,
              AccRg588.FFld592Dt as InPut_CurrencyAmount,
              0 as OutPut_Amount,
              0 as OutPut_CurrencyAmount
           FROM AccRg588, vSCAccMapping 
           WHERE AccRg588.Faccountdtrref = vSCAccMapping.AccRefID 
                 and trunc(AccRg588.Fperiod) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')
                     
           UNION ALL
                                    
           Select
              AccRg588.Frecorderrref,   
              AccRg588.Faccountctrref,
              AccRg588.FFld589RRef,
              AccRg588.Frecordertref,
              AccRg588.Fperiod,
              AccRg588.FFld590CtRRef,
              AccRg588.FFld594,
              0,
              0,
              AccRg588.FFld591,
              AccRg588.FFld592Ct
           From AccRg588, vSCAccMapping
           WHERE AccRg588.Faccountctrref = vSCAccMapping.AccRefID
                 and trunc(AccRg588.Fperiod) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')) MoneyTable  
           
         left join Reference26 CurrenceObject   on (MoneyTable.Currency = CurrenceObject.FIDRRef)
         left join Acc21 AccObject              on (MoneyTable.Account  = AccObject.Fidrref)
         left join Reference60 BranchObject  on (MoneyTable.Organisation = BranchObject.FIDRRef)) MTable
     
     left join (
               select
                    DocTable.Fnumber,
                    DocTable.Fidrref,
                    DocTable.DocBankNumber,                    
                    ClientObject.Fdescription as Client,
                    ContractObject.Fdescription as Contract,
                    BankAccBranch.Fdescription as BankAccountBranch,
                    BankAccClient.Fdescription as BankAccountClient,                                     
                    DocTable.DocType,
                    DocTable.PaymentDescription
               
               from
                   (
                    -- Платежный ордер на списание денежных средств           
                    select  
                        Document209.Fnumber,
                        Document209.Fidrref,
                        Document209.FFld6540 as DocBankNumber,                    
                        --Document209.Ffld6432rref as OperationType,
                        Document209.FFld6539RRef as BankAccountClient,
                        Document209.FFld6538RRef as Client,
                        Document209.FFld6542RRef as Contract,
                        Document209.FFld6537RRef as BankAccountBranch,
                       'Платежный ордер на списание денежных средств' as DocType,
                        DBMS_LOB.SUBSTR(Document209.FFld6543, 500) as PaymentDescription
                    from Document209
                    WHERE trunc(Document209.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')

                    UNION
                    -- Бухгалтерская операция           
                    select  
                        Document174.Fnumber,
                        Document174.Fidrref,
                        '',                    
                        --NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        'Бухгалтерская операция' as DocType,
                        ''
                    from Document174
                    WHERE trunc(Document174.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')

                    UNION
                    -- Платежный ордер на поступенине денежных средств
                    -- замена атрибутов на новые имена пока не делалась
                    select  
                        Document208.Fnumber,
                        Document208.Fidrref,
                        Document208.FFld6442,                    
                        --Document208.Ffld6326rref,
                        Document208.FFld6458RRef,
                        Document208.FFld6448RRef, 
                        Document208.FFld6444RRef, 
                        Document208.FFld6459RRef,
                        'Платежный ордер на поступление денежных средств' as DocType,
                        DBMS_LOB.SUBSTR(Document208.FFld6483, 500) as PaymentDescription
                    from Document208
                    WHERE trunc(Document208.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')
                                          
                    UNION
                    -- Платежное поручение входящее            
                    select  
                        Document205.Fnumber,
                        Document205.Fidrref,
                        Document205.FFld6170,                    
                        --Document205.Ffld6052rref,
                        Document205.FFld6181RRef,
                        Document205.FFld6169RRef,
                        Document205.FFld6166RRef, 
                        Document205.FFld6182RRef, 
                        'Платежное поручение входящее' as DocType,                    
                        DBMS_LOB.SUBSTR(Document205.FFld6205, 500)
                    from Document205
                    WHERE trunc(Document205.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                
                    
                    UNION
                    -- Платежное поручение исходящее            
                    select  
                        Document206.Fnumber,
                        Document206.Fidrref,
                        '',                    
                        --Document206.Ffld6155rref,
                        Document206.FFld6244RRef,
                        Document206.FFld6243RRef,
                        Document206.FFld6245RRef,
                        Document206.FFld6242RRef,
                        'Платежное поручение исходящее' as DocType,                    
                        DBMS_LOB.SUBSTR(Document206.FFld6248, 500)
                    from Document206
                    WHERE trunc(Document206.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                
                      
                    UNION
                    -- Платежное требование выставленное            
                    select  
                        Document207.Fnumber,
                        Document207.Fidrref,
                        '',                    
                        --Document207.Ffld6260rref,
                        Document207.FFld6372RRef,  
                        Document207.FFld6371RRef,
                        Document207.FFld6376RRef,
                        Document207.FFld6370RRef,
                        'Платежное требование выставленное' as DocType,                     
                        DBMS_LOB.SUBSTR(Document207.FFld6391, 500)
                    from Document207
                    WHERE trunc(Document207.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                

                    UNION
                    -- Приходный кассовый ордер           
                    select  
                        Document220.Fnumber,
                        Document220.Fidrref,
                        '',                    
                        --Document220.Ffld7117rref,
                        NULL,
                        Document220.FFld7243_RRRef,
                        Document220.FFld7244RRef,
                        NULL,
                        'Приходный кассовый ордер' as DocType,                     
                        DBMS_LOB.SUBSTR(Document220.FFld7248, 500)
                    from Document220
                    WHERE trunc(Document220.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                

                    UNION
                    -- Приходный кассовый ордер валютный           
                    select  
                        Document221.Fnumber,
                        Document221.Fidrref,
                        '',                    
                        --Document221.Ffld7203rref,
                        NULL,
                        Document221.FFld7329_RRRef,
                        Document221.FFld7330RRef,
                        NULL,
                        'Приходный кассовый ордер валютный' as DocType,                     
                        DBMS_LOB.SUBSTR(Document221.FFld7334, 500)
                    from Document221
                    WHERE trunc(Document221.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                

                    UNION
                    -- Расходный кассовый ордер           
                    select  
                        Document223.Fnumber,
                        Document223.Fidrref,
                        '',                    
                        --Document223.Ffld7357rref,
                        NULL,
                        Document223.FFld7485_RRRef, 
                        Document223.FFld7486RRef,
                        NULL,
                        'Расходный кассовый ордер' as DocType,                    
                        DBMS_LOB.SUBSTR(Document223.FFld7490, 500)
                    from Document223
                    WHERE trunc(Document223.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')                

                    UNION
                     -- Расходный кассовый ордер валютный           
                    select  
                        Document224.Fnumber,
                        Document224.Fidrref,
                        '',                    
                        --Document224.Ffld7438rref,
                        NULL,
                        Document224.FFld7566_RRRef,
                        Document224.FFld7567RRef,
                        NULL,
                        'Расходный кассовый ордер валютный' as DocType,                    
                        DBMS_LOB.SUBSTR(Document224.FFld7571, 500)
                    from Document224
                    WHERE trunc(Document224.Fdate_Time) BETWEEN to_date('01/01/2015', 'DD/MM/YYYY') And to_date('31/12/2015', 'DD/MM/YYYY')) DocTable
                    
           left join Reference51 ClientObject   on (DocTable.Client       = ClientObject.FIDRRef)
           left join Reference39 ContractObject on (DocTable.Contract     = ContractObject.FIDRRef)
           left join Reference27 BankAccBranch  on (DocTable.BankAccountBranch  = BankAccBranch.FIDRRef)
           left join Reference27 BankAccClient  on (DocTable.BankAccountClient  = BankAccClient.FIDRRef)                                      
               ) Doc on (Doc.Fidrref = MTable.Registrator)    


