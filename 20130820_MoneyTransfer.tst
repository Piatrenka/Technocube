PL/SQL Developer Test script 3.0
94
--------------------------------------------------------------------------
-- Синкевич
-- Движения денежных средств за период. Формируется по всем счетам (касса, 
-- расчетные счета в валюте и в рублях). Учитываются все движения, в том числе и 
-- ручные проводки, если они имели место. 
--       Branch                 - наименование организации
--       AccountCode            - код счета из плана счетов
--       AccountName            - наименование счета из плана счетов
--       Period                 - дата осуществления операции
--       Currency               - наименование валюты в случае валютных движений
--       Client                 - наименование клиента
--       Contract               - наименование договора
--       BankAccount            - расчетный счет организации
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
      MTable.Period,
      MTable.Currency,
      ClientObject.Fdescription   as Client,
      ContractObject.Fdescription as Contract,
      BankAccObject.Fdescription  as BankAccount,
      MTable.TextDescription,
      MTable.OutPut_Amount,
      MTable.OutPut_CurrencyAmount,
      MTable.InPut_Amount,
      MTable.InPut_CurrencyAmount
   From(
     select 
        BranchObject.Fdescription Branch,
        AccObject.Fcode AccountCode,
        AccObject.Fdescription AccountName,
        to_char(MoneyTable.Period,'DD/MM/YYYY') as Period,
        CurrenceObject.Fdescription Currency,
        SD_Client.Fvalue_Rrref as Client,
        SD_Contract.Fvalue_Rrref as Contract,
        SD_BankAcc.Fvalue_Rrref as BankAccount,
        MoneyTable.TextDescription,
        MoneyTable.OutPut_Amount,
        MoneyTable.OutPut_CurrencyAmount,
        MoneyTable.InPut_Amount,
        MoneyTable.InPut_CurrencyAmount
     From   
       (SELECT 
          Accrg644.Frecorderrref as RecordID,                           
          Accrg644.Faccountdtrref as Account,
          AccRg644.Ffld645rref as Organisation,
          AccRg644.Frecordertref as Registrator,
          AccRg644.Fperiod as Period,
          AccRg644.Ffld646dtrref as Currency,
          AccRg644.Ffld650 as TextDescription,
          AccRg644.Ffld647 as OutPut_Amount,
          AccRg644.Ffld648dt as OutPut_CurrencyAmount,
          0 as InPut_Amount,
          0 as InPut_CurrencyAmount
       FROM AccRg644, vSCAccMapping 
       WHERE AccRg644.Faccountdtrref = vSCAccMapping.AccRefID 
             and AccRg644.Fperiod BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('03/01/2012', 'DD/MM/YYYY')
                 
       UNION ALL
                                
       Select
          Accrg644.Frecorderrref,   
          Accrg644.Faccountctrref,
          AccRg644.Ffld645rref,
          AccRg644.Frecordertref,
          AccRg644.Fperiod,
          AccRg644.Ffld646ctrref,
          AccRg644.Ffld650,
          0,
          0,
          AccRg644.Ffld647,
          AccRg644.Ffld648ct
       From AccRg644, vSCAccMapping
       WHERE AccRg644.Faccountctrref = vSCAccMapping.AccRefID
             and AccRg644.Fperiod BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('03/01/2012', 'DD/MM/YYYY')) MoneyTable  
       
     left join Reference23 CurrenceObject   on (MoneyTable.Currency = CurrenceObject.FIDRRef)
     left join Acc18 AccObject              on (MoneyTable.Account  = AccObject.Fidrref)
     left join AccRgED669 SD_Client         on (MoneyTable.RecordID = SD_Client.Frecorderrref) and (SD_Client.Fkindrref = '93E0BC525FC3DBE048D4A86FAC901067') 
     left join AccRgED669 SD_Contract       on (MoneyTable.RecordID = SD_Contract.Frecorderrref) and (SD_Contract.Fkindrref = '9EFEA4E4FE5213194AAACF4480D1631B')
     left join AccRgED669 SD_BankAcc        on (MoneyTable.RecordID = SD_BankAcc.Frecorderrref) and (SD_BankAcc.Fkindrref = '8096C8EFB7CA1E59427C88B9F3DE4F14')
     left join Reference60 BranchObject  on (MoneyTable.Organisation = BranchObject.FIDRRef)) MTable
 
 left join Reference48 ClientObject   on (MTable.Client 	    = ClientObject.FIDRRef)
 left join Reference36 ContractObject on (MTable.Contract     = ContractObject.FIDRRef)
 left join Reference21 BankAccObject  on (MTable.BankAccount  = BankAccObject.FIDRRef)
   
0
0
