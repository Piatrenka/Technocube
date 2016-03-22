--------------------------------------------------------------------------
-- ��������
-- �������� �������� ������� �� ������. ����������� �� ���� ������ (�����, 
-- ��������� ����� � ������ � � ������). ����������� ��� ��������, � ��� ����� � 
-- ������ ��������, ���� ��� ����� �����. 
--       Branch                 - ������������ �����������
--       AccountCode            - ��� ����� �� ����� ������
--       AccountName            - ������������ ����� �� ����� ������
--       DocDate                - ���� ������������� ��������
--       DocNum                 - ���������� ����� ��������� 1�
--       DocBankNumber          - ����� ��������� � �����                    
--       Client                 - ������������ �������  
--       Contract               - ������������ �������
--       BankAccountBranch      - ��������� ���� �����������
--       BankAccountClient      - ��������� ���� �����������                                     
--       DocType                - ��� ���������
--       PaymentDescription     - ��������� ����������� ������� ��� � �����
--       Currency               - ������������ ������ � ������ �������� ��������
--       TextDescription        - ��������� �������� �������
--       OutPut_Amount          - ����� �������� �������� ������� � ���. ���.
--       OutPut_CurrencyAmount  - ����� �������� �������� ������� � ������
--       InPut_Amount           - ����� ����������� �������� ������� � ���. ���.
--       InPut_CurrencyAmount   - ����� ����������� �������� ������� � ������
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
              Accrg644.Frecorderrref as RecordID,                           
              Accrg644.Faccountdtrref as Account,
              AccRg644.Ffld645rref as Organisation,
              AccRg644.Frecordertref as Registrator,
              AccRg644.Fperiod as Period,
              AccRg644.Ffld646dtrref as Currency,
              AccRg644.Ffld650 as TextDescription,
              AccRg644.Ffld647 as InPut_Amount,
              AccRg644.Ffld648dt as InPut_CurrencyAmount,
              0 as OutPut_Amount,
              0 as OutPut_CurrencyAmount
           FROM AccRg644, vSCAccMapping 
           WHERE AccRg644.Faccountdtrref = vSCAccMapping.AccRefID 
                 and trunc(AccRg644.Fperiod) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')
                     
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
                 and trunc(AccRg644.Fperiod) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')) MoneyTable  
           
         left join Reference23 CurrenceObject   on (MoneyTable.Currency = CurrenceObject.FIDRRef)
         left join Acc18 AccObject              on (MoneyTable.Account  = AccObject.Fidrref)
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
                    -- ��������� ����� �� �������� �������� �������           
                    select  
                        Document202.Fnumber,
                        Document202.Fidrref,
                        Document202.Ffld6423 as DocBankNumber,                    
                        --Document202.Ffld6432rref as OperationType,
                        Document202.Ffld6422rref as BankAccountClient,
                        Document202.Ffld6421rref as Client,
                        Document202.Ffld6425rref as Contract,
                        Document202.Ffld6420rref as BankAccountBranch,
                       '��������� ����� �� �������� �������� �������' as DocType,
                        DBMS_LOB.SUBSTR(Document202.Ffld6426, 500) as PaymentDescription
                    from Document202
                    WHERE trunc(Document202.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')

                    UNION
                    -- ������������� ��������           
                    select  
                        Document174.Fnumber,
                        Document174.Fidrref,
                        '',                    
                        --NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        '������������� ��������' as DocType,
                        ''
                    from Document174
                    WHERE trunc(Document174.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')

                    UNION
                    -- ��������� ����� �� ����������� �������� �������           
                    select  
                        Document201.Fnumber,
                        Document201.Fidrref,
                        Document201.Ffld6327,                    
                        --Document201.Ffld6326rref,
                        Document201.Ffld6343rref,
                        Document201.Ffld6333rref, 
                        Document201.Ffld6329rref, 
                        Document201.Ffld6344rref,
                        '��������� ����� �� ����������� �������� �������' as DocType,
                        DBMS_LOB.SUBSTR(Document201.Ffld6368, 500) as PaymentDescription
                    from Document201
                    WHERE trunc(Document201.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')
                                          
                    UNION
                    -- ��������� ��������� ��������            
                    select  
                        Document198.Fnumber,
                        Document198.Fidrref,
                        Document198.Ffld6057,                    
                        --Document198.Ffld6052rref,
                        Document198.Ffld6068rref,
                        Document198.fFld6056RRef,
                        Document198.fFld6053RRef, 
                        Document198.fFld6069RRef, 
                        '��������� ��������� ��������' as DocType,                    
                        DBMS_LOB.SUBSTR(Document198.Ffld6092, 500)
                    from Document198
                    WHERE trunc(Document198.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                
                    
                    UNION
                    -- ��������� ��������� ���������            
                    select  
                        Document199.Fnumber,
                        Document199.Fidrref,
                        '',                    
                        --Document199.Ffld6155rref,
                        Document199.Ffld6131rref,
                        Document199.Ffld6130rref,
                        Document199.fFld6132RRef,
                        Document199.fFld6129RRef,
                        '��������� ��������� ���������' as DocType,                    
                        DBMS_LOB.SUBSTR(Document199.Ffld6135, 500)
                    from Document199
                    WHERE trunc(Document199.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                
                      
                    UNION
                    -- ��������� ���������� ������������            
                    select  
                        Document200.Fnumber,
                        Document200.Fidrref,
                        '',                    
                        --Document200.Ffld6260rref,
                        Document200.Ffld6257rref,  
                        Document200.fFld6256RRef,
                        Document200.fFld6261RRef,
                        Document200.fFld6255RRef,
                        '��������� ���������� ������������' as DocType,                     
                        DBMS_LOB.SUBSTR(Document200.Ffld6276, 500)
                    from Document200
                    WHERE trunc(Document200.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- ��������� �������� �����           
                    select  
                        Document213.Fnumber,
                        Document213.Fidrref,
                        '',                    
                        --Document213.Ffld7117rref,
                        NULL,
                        Document213.fFld7118_RRRef,
                        Document213.fFld7119RRef,
                        NULL,
                        '��������� �������� �����' as DocType,                     
                        DBMS_LOB.SUBSTR(Document213.Ffld7123, 500)
                    from Document213
                    WHERE trunc(Document213.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- ��������� �������� ����� ��������           
                    select  
                        Document214.Fnumber,
                        Document214.Fidrref,
                        '',                    
                        --Document214.Ffld7203rref,
                        NULL,
                        Document214.fFld7204_RRRef,
                        Document214.fFld7205RRef,
                        NULL,
                        '��������� �������� ����� ��������' as DocType,                     
                        DBMS_LOB.SUBSTR(Document214.Ffld7209, 500)
                    from Document214
                    WHERE trunc(Document214.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                    -- ��������� �������� �����           
                    select  
                        Document216.Fnumber,
                        Document216.Fidrref,
                        '',                    
                        --Document216.Ffld7357rref,
                        NULL,
                        Document216.fFld7360_RRRef, 
                        Document216.fFld7361RRef,
                        NULL,
                        '��������� �������� �����' as DocType,                    
                        DBMS_LOB.SUBSTR(Document216.Ffld7365, 500)
                    from Document216
                    WHERE trunc(Document216.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')                

                    UNION
                     -- ��������� �������� ����� ��������           
                    select  
                        Document217.Fnumber,
                        Document217.Fidrref,
                        '',                    
                        --Document217.Ffld7438rref,
                        NULL,
                        Document217.fFld7441_RRRef,
                        Document217.fFld7442RRef,
                        NULL,
                        '��������� �������� ����� ��������' as DocType,                    
                        DBMS_LOB.SUBSTR(Document217.Ffld7446, 500)
                    from Document217
                    WHERE trunc(Document217.Fdate_Time) BETWEEN to_date('01/01/2012', 'DD/MM/YYYY') And to_date('31/01/2012', 'DD/MM/YYYY')) DocTable
                    
           left join Reference48 ClientObject   on (DocTable.Client       = ClientObject.FIDRRef)
           left join Reference36 ContractObject on (DocTable.Contract     = ContractObject.FIDRRef)
           left join Reference21 BankAccBranch  on (DocTable.BankAccountBranch  = BankAccBranch.FIDRRef)
           left join Reference21 BankAccClient  on (DocTable.BankAccountClient  = BankAccClient.FIDRRef)                                      
               ) Doc on (Doc.Fidrref = MTable.Registrator)    

