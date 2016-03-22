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
              AccRg588.Ffld645rref as Organisation,
              AccRg588.Frecordertref as Registrator,
              AccRg588.Fperiod as Period,
              AccRg588.Ffld646dtrref as Currency,
              AccRg588.Ffld650 as TextDescription,
              AccRg588.Ffld647 as InPut_Amount,
              AccRg588.Ffld648dt as InPut_CurrencyAmount,
              0 as OutPut_Amount,
              0 as OutPut_CurrencyAmount
           FROM AccRg588, vSCAccMapping 
           WHERE AccRg588.Faccountdtrref = vSCAccMapping.AccRefID 
                 and trunc(AccRg588.Fperiod) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')
                     
           UNION ALL
                                    
           Select
              AccRg588.Frecorderrref,   
              AccRg588.Faccountctrref,
              AccRg588.Ffld645rref,
              AccRg588.Frecordertref,
              AccRg588.Fperiod,
              AccRg588.Ffld646ctrref,
              AccRg588.Ffld650,
              0,
              0,
              AccRg588.Ffld647,
              AccRg588.Ffld648ct
           From AccRg588, vSCAccMapping
           WHERE AccRg588.Faccountctrref = vSCAccMapping.AccRefID
                 and trunc(AccRg588.Fperiod) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')) MoneyTable  
           
         left join Reference23 CurrenceObject   on (MoneyTable.Currency = CurrenceObject.FIDRRef)
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
                        Document202.Fnumber,
                        Document202.Fidrref,
                        Document202.Ffld6423 as DocBankNumber,                    
                        --Document202.Ffld6432rref as OperationType,
                        Document202.Ffld6422rref as BankAccountClient,
                        Document202.Ffld6421rref as Client,
                        Document202.Ffld6425rref as Contract,
                        Document202.Ffld6420rref as BankAccountBranch,
                       'Платежный ордер на списание денежных средств' as DocType,
                        DBMS_LOB.SUBSTR(Document202.Ffld6426, 500) as PaymentDescription
                    from Document202
                    WHERE trunc(Document202.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')

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
                    WHERE trunc(Document174.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')

                    UNION
                    -- Платежный ордер на поступенине денежных средств           
                    select  
                        Document201.Fnumber,
                        Document201.Fidrref,
                        Document201.Ffld6327,                    
                        --Document201.Ffld6326rref,
                        Document201.Ffld6343rref,
                        Document201.Ffld6333rref, 
                        Document201.Ffld6329rref, 
                        Document201.Ffld6344rref,
                        'Платежный ордер на поступление денежных средств' as DocType,
                        DBMS_LOB.SUBSTR(Document201.Ffld6368, 500) as PaymentDescription
                    from Document201
                    WHERE trunc(Document201.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')
                                          
                    UNION
                    -- Платежное поручение входящее            
                    select  
                        Document198.Fnumber,
                        Document198.Fidrref,
                        Document198.Ffld6057,                    
                        --Document198.Ffld6052rref,
                        Document198.Ffld6068rref,
                        Document198.fFld6056RRef,
                        Document198.fFld6053RRef, 
                        Document198.fFld6069RRef, 
                        'Платежное поручение входящее' as DocType,                    
                        DBMS_LOB.SUBSTR(Document198.Ffld6092, 500)
                    from Document198
                    WHERE trunc(Document198.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                
                    
                    UNION
                    -- Платежное поручение исходящее            
                    select  
                        Document199.Fnumber,
                        Document199.Fidrref,
                        '',                    
                        --Document199.Ffld6155rref,
                        Document199.Ffld6131rref,
                        Document199.Ffld6130rref,
                        Document199.fFld6132RRef,
                        Document199.fFld6129RRef,
                        'Платежное поручение исходящее' as DocType,                    
                        DBMS_LOB.SUBSTR(Document199.Ffld6135, 500)
                    from Document199
                    WHERE trunc(Document199.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                
                      
                    UNION
                    -- Платежное требование выставленное            
                    select  
                        Document200.Fnumber,
                        Document200.Fidrref,
                        '',                    
                        --Document200.Ffld6260rref,
                        Document200.Ffld6257rref,  
                        Document200.fFld6256RRef,
                        Document200.fFld6261RRef,
                        Document200.fFld6255RRef,
                        'Платежное требование выставленное' as DocType,                     
                        DBMS_LOB.SUBSTR(Document200.Ffld6276, 500)
                    from Document200
                    WHERE trunc(Document200.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- Приходный кассовый ордер           
                    select  
                        Document213.Fnumber,
                        Document213.Fidrref,
                        '',                    
                        --Document213.Ffld7117rref,
                        NULL,
                        Document213.fFld7118_RRRef,
                        Document213.fFld7119RRef,
                        NULL,
                        'Приходный кассовый ордер' as DocType,                     
                        DBMS_LOB.SUBSTR(Document213.Ffld7123, 500)
                    from Document213
                    WHERE trunc(Document213.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- Приходный кассовый ордер валютный           
                    select  
                        Document214.Fnumber,
                        Document214.Fidrref,
                        '',                    
                        --Document214.Ffld7203rref,
                        NULL,
                        Document214.fFld7204_RRRef,
                        Document214.fFld7205RRef,
                        NULL,
                        'Приходный кассовый ордер валютный' as DocType,                     
                        DBMS_LOB.SUBSTR(Document214.Ffld7209, 500)
                    from Document214
                    WHERE trunc(Document214.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- Расходный кассовый ордер           
                    select  
                        Document216.Fnumber,
                        Document216.Fidrref,
                        '',                    
                        --Document216.Ffld7357rref,
                        NULL,
                        Document216.fFld7360_RRRef, 
                        Document216.fFld7361RRef,
                        NULL,
                        'Расходный кассовый ордер' as DocType,                    
                        DBMS_LOB.SUBSTR(Document216.Ffld7365, 500)
                    from Document216
                    WHERE trunc(Document216.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                     -- Расходный кассовый ордер валютный           
                    select  
                        Document217.Fnumber,
                        Document217.Fidrref,
                        '',                    
                        --Document217.Ffld7438rref,
                        NULL,
                        Document217.fFld7441_RRRef,
                        Document217.fFld7442RRef,
                        NULL,
                        'Расходный кассовый ордер валютный' as DocType,                    
                        DBMS_LOB.SUBSTR(Document217.Ffld7446, 500)
                    from Document217
                    WHERE trunc(Document217.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')) DocTable
                    
           left join Reference48 ClientObject   on (DocTable.Client       = ClientObject.FIDRRef)
           left join Reference36 ContractObject on (DocTable.Contract     = ContractObject.FIDRRef)
           left join Reference24 BankAccBranch  on (DocTable.BankAccountBranch  = BankAccBranch.FIDRRef)
           left join Reference24 BankAccClient  on (DocTable.BankAccountClient  = BankAccClient.FIDRRef)                                      
               ) Doc on (Doc.Fidrref = MTable.Registrator)    


