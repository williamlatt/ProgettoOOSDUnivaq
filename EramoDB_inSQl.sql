if not exists(select * from sysobjects where name=N't_rise_u_model' and xtype='U')
begin
  create table [t_rise_u_model]
  (
    [c_id] int identity(1,1) primary key clustered not null,
    [c_u_name] nvarchar(50),
    [c_u_prefix] nvarchar(10),
    [c_u_guid] nvarchar(50),
    [c_u_version] int not null,
    [c_u_versionSequenceNumber] int not null
  )
  alter table [t_rise_u_model] add
    constraint [ix_rise_u_model_u_guid] unique nonclustered ([c_u_guid]),
    constraint [ix_rise_u_model_u_prefix] unique nonclustered ([c_u_prefix]),
    constraint [ix_rise_u_model_u_name] unique nonclustered ([c_u_name])
end
if not exists(select * from sysobjects where name=N't_rise_u_log' and xtype='U')
begin
  create table [t_rise_u_log]
  (
    [c_id] int identity(1,1) primary key clustered not null,
    [c_r_model] int not null,
    [c_u_sequenceNumber] int not null,
    [c_u_timeStamp] datetime not null,
    [c_u_xml] ntext null
  )
  alter table [t_rise_u_log] add
    constraint [fk_rise_u_log_r_model] foreign key ( [c_r_model] ) references [t_rise_u_model] ( [c_id] ),
    constraint [ix_rise_u_log_i_modelSN] unique nonclustered ([c_r_model],[c_u_sequenceNumber])
end
if not exists(select * from sysobjects where name=N't_rise_u_object' and xtype='U')
begin
  create table [t_rise_u_object]
  (
    [c_id] int identity(1,1) primary key clustered not null,
    [c_u_tableName] nvarchar(50) not null,
    [c_u_riseID] nvarchar(50) not null,
    [c_u_dbID] int not null,
    [c_u_state] nvarchar(1) not null
  )
  alter table [t_rise_u_object] add
    constraint [ix_rise_u_object_u_tableNameriseID] unique nonclustered ([c_u_tableName],[c_u_riseID]),
    constraint [ix_rise_u_object_u_tableNamedbID] unique nonclustered ([c_u_tableName],[c_u_dbID])
end
if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_rise_u_object') where sc.name='c_u_state')
  alter table [t_rise_u_object] add [c_u_state] nvarchar(1) null
if not exists(select * from sysobjects where name = 'f_rise_u_dbID' and xtype='FN')
  execute(N'create function f_rise_u_dbID (@p_tableName nvarchar(50), @p_riseID nvarchar(50)) returns int
    as
    begin
      declare @v_dbID int
      select @v_dbID = c_u_dbID from t_rise_u_object where c_u_tableName = @p_tableName and c_u_riseID = @p_riseID
      return @v_dbID
    end')
if not exists(select * from sysobjects where name=N'v_rise_nextSNinner' and xtype='V')
  execute(N'create view [v_rise_nextSNinner] ([SN],[c_r_model]) as
    select max([c_u_sequenceNumber])+1,[c_r_model]
    from [t_rise_u_log]
    group by [c_r_model]')
if not exists(select * from sysobjects where name=N'v_rise_nextSN' and xtype='V')
  execute(N'create view [v_rise_nextSN] ([SN],[prefix],[guid]) as
    select isnull([l].[SN],1),[m].[c_u_prefix],[m].[c_u_guid]
    from [t_rise_u_model] [m]
    left outer join [v_rise_nextSNinner] [l] on ([l].[c_r_model]=[m].[c_id])')
GO -- 'end-of-command

if not exists(select * from [t_rise_u_model] where [c_u_prefix]=N'EramoDB' and [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb') insert into [t_rise_u_model] ([c_u_name],[c_u_prefix],[c_u_guid],[c_u_version],[c_u_versionSequenceNumber]) values (N'EramoDB',N'EramoDB',N'83633980-65ef-46e2-834e-6dc3c6b448bb',0,0)
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=1)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],1,getdate(),N'<rise:release xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>1</rise:sequenceNumber><rise:timeStamp>2018-04-26T11:53:43</rise:timeStamp><rise:comment>Created from empty model Blank (,49944b71-12fc-41f2-81a9-bcde1d55782e) </rise:comment></rise:release>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  update t_rise_u_model set c_u_version=1,c_u_versionSequenceNumber=1 where c_u_prefix='EramoDB' and c_u_guid='83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=2)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],2,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>2</rise:sequenceNumber><rise:timeStamp>2018-04-26T11:54:04</rise:timeStamp><rise:entity><rise:name>Entity</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    create table [t_EramoDB_u_Entity]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=3)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],3,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>3</rise:sequenceNumber><rise:timeStamp>2018-04-26T11:54:07</rise:timeStamp><rise:entity><rise:name>Entity1</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity1') 
    create table [t_EramoDB_u_Entity1]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=4)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],4,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>4</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:02:19</rise:timeStamp><rise:entityName>Entity</rise:entityName><rise:newEntityName>Opera</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Opera') 
      exec sp_rename N'[t_EramoDB_u_Entity]',N't_EramoDB_u_Opera'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=5)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],5,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>5</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:02:29</rise:timeStamp><rise:entityName>Entity1</rise:entityName><rise:newEntityName>Categoria</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity1') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria') 
      exec sp_rename N'[t_EramoDB_u_Entity1]',N't_EramoDB_u_Categoria'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=6)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],6,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>6</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:02:37</rise:timeStamp><rise:entity><rise:name>Entity</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    create table [t_EramoDB_u_Entity]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=7)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],7,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>7</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:02:44</rise:timeStamp><rise:entityName>Entity</rise:entityName><rise:newEntityName>Pagina</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Pagina') 
      exec sp_rename N'[t_EramoDB_u_Entity]',N't_EramoDB_u_Pagina'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=8)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],8,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>8</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:02:52</rise:timeStamp><rise:entity><rise:name>Entity</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    create table [t_EramoDB_u_Entity]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=9)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],9,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>9</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:03:00</rise:timeStamp><rise:entityName>Entity</rise:entityName><rise:newEntityName>Trascrizione</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Trascrizione') 
      exec sp_rename N'[t_EramoDB_u_Entity]',N't_EramoDB_u_Trascrizione'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=10)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],10,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>10</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:03:03</rise:timeStamp><rise:entity><rise:name>Entity</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    create table [t_EramoDB_u_Entity]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=11)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],11,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>11</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:07:06</rise:timeStamp><rise:entityName>Entity</rise:entityName><rise:newEntityName>Immagine</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Immagine') 
      exec sp_rename N'[t_EramoDB_u_Entity]',N't_EramoDB_u_Immagine'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=12)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],12,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>12</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:07:47</rise:timeStamp><rise:entity><rise:name>Entity</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    create table [t_EramoDB_u_Entity]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=13)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],13,getdate(),N'<rise:newEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>13</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:07:54</rise:timeStamp><rise:entity><rise:name>Entity1</rise:name><rise:maxID>0</rise:maxID></rise:entity></rise:newEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity1') 
    create table [t_EramoDB_u_Entity1]
    (
      [c_id] bigint identity(1,1) primary key clustered not null
    )
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=14)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],14,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>14</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:07:59</rise:timeStamp><rise:entityName>Entity</rise:entityName><rise:newEntityName>Utente</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Utente') 
      exec sp_rename N'[t_EramoDB_u_Entity]',N't_EramoDB_u_Utente'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=15)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],15,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>15</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:08:05</rise:timeStamp><rise:entityName>Entity1</rise:entityName><rise:newEntityName>Categoria1</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Entity1') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria1') 
      exec sp_rename N'[t_EramoDB_u_Entity1]',N't_EramoDB_u_Categoria1'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=16)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],16,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>16</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:08:05</rise:timeStamp><rise:entityName>Categoria1</rise:entityName><rise:newEntityName>Categoria2</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria1') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria2') 
      exec sp_rename N'[t_EramoDB_u_Categoria1]',N't_EramoDB_u_Categoria2'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=17)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],17,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>17</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:08:31</rise:timeStamp><rise:entityName>Categoria2</rise:entityName><rise:newEntityName>Categoria1</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria2') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria1') 
      exec sp_rename N'[t_EramoDB_u_Categoria2]',N't_EramoDB_u_Categoria1'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=18)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],18,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>18</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:08:31</rise:timeStamp><rise:entityName>Categoria1</rise:entityName><rise:newEntityName>Categoria2</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria1') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria2') 
      exec sp_rename N'[t_EramoDB_u_Categoria1]',N't_EramoDB_u_Categoria2'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=19)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],19,getdate(),N'<rise:renameEntity xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>19</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:08:50</rise:timeStamp><rise:entityName>Categoria2</rise:entityName><rise:newEntityName>Ruolo</rise:newEntityName></rise:renameEntity>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Categoria2') 
    if not exists(select id from sysobjects where xtype='U' and name='t_EramoDB_u_Ruolo') 
      exec sp_rename N'[t_EramoDB_u_Categoria2]',N't_EramoDB_u_Ruolo'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=20)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],20,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>20</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:16:30</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_id_utente') 
    alter table [t_EramoDB_u_Utente] add [c_u_id_utente] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_id_utente] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_id_utente] bigint not null else alter table [t_EramoDB_u_Utente] alter column [c_u_id_utente] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id_utente') 
    alter table [t_EramoDB_u_Utente] add constraint [ix_EramoDB_u_Utente_u_id_utente] unique nonclustered ([c_u_id_utente])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=21)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],21,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>21</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:16:39</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_nome') 
    alter table [t_EramoDB_u_Utente] add [c_u_nome] nvarchar(50) null
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_nome] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_nome] nvarchar(50) not null else alter table [t_EramoDB_u_Utente] alter column [c_u_nome] nvarchar(50) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=22)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],22,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>22</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:16:46</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>cognome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_cognome') 
    alter table [t_EramoDB_u_Utente] add [c_u_cognome] nvarchar(50) null
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_cognome] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_cognome] nvarchar(50) not null else alter table [t_EramoDB_u_Utente] alter column [c_u_cognome] nvarchar(50) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=23)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],23,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>23</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:16:54</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>eta</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_eta') 
    alter table [t_EramoDB_u_Utente] add [c_u_eta] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_eta] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_eta] bigint not null else alter table [t_EramoDB_u_Utente] alter column [c_u_eta] bigint null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=24)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],24,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>24</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:17:46</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>id_opera</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_u_id_opera') 
    alter table [t_EramoDB_u_Opera] add [c_u_id_opera] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Opera] where [c_u_id_opera] is null)) alter table [t_EramoDB_u_Opera] alter column [c_u_id_opera] bigint not null else alter table [t_EramoDB_u_Opera] alter column [c_u_id_opera] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id_opera') 
    alter table [t_EramoDB_u_Opera] add constraint [ix_EramoDB_u_Opera_u_id_opera] unique nonclustered ([c_u_id_opera])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=25)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],25,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>25</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:17:52</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_u_nome') 
    alter table [t_EramoDB_u_Opera] add [c_u_nome] nvarchar(50) null
  execute('if(not exists(select * from [t_EramoDB_u_Opera] where [c_u_nome] is null)) alter table [t_EramoDB_u_Opera] alter column [c_u_nome] nvarchar(50) not null else alter table [t_EramoDB_u_Opera] alter column [c_u_nome] nvarchar(50) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=26)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],26,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>26</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:18:15</rise:timeStamp><rise:entity><rise:name>Categoria</rise:name><rise:attribute><rise:name>id_categoria</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Categoria') where sc.name='c_u_id_categoria') 
    alter table [t_EramoDB_u_Categoria] add [c_u_id_categoria] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Categoria] where [c_u_id_categoria] is null)) alter table [t_EramoDB_u_Categoria] alter column [c_u_id_categoria] bigint not null else alter table [t_EramoDB_u_Categoria] alter column [c_u_id_categoria] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Categoria_u_id_categoria') 
    alter table [t_EramoDB_u_Categoria] add constraint [ix_EramoDB_u_Categoria_u_id_categoria] unique nonclustered ([c_u_id_categoria])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=27)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],27,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>27</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:18:21</rise:timeStamp><rise:entity><rise:name>Categoria</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Categoria') where sc.name='c_u_nome') 
    alter table [t_EramoDB_u_Categoria] add [c_u_nome] nvarchar(50) null
  execute('if(not exists(select * from [t_EramoDB_u_Categoria] where [c_u_nome] is null)) alter table [t_EramoDB_u_Categoria] alter column [c_u_nome] nvarchar(50) not null else alter table [t_EramoDB_u_Categoria] alter column [c_u_nome] nvarchar(50) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=28)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],28,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>28</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:18:45</rise:timeStamp><rise:entity><rise:name>Categoria</rise:name><rise:attribute><rise:name>descrizione</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>200</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist><rise:description /></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Categoria') where sc.name='c_u_descrizione') 
    alter table [t_EramoDB_u_Categoria] add [c_u_descrizione] nvarchar(200) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=29)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],29,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>29</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:19:11</rise:timeStamp><rise:relation><rise:name>CategoriaOpera</rise:name><rise:node><rise:name>Categoria</rise:name><rise:entityName>Categoria</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Opera</rise:name><rise:entityName>Opera</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_r_Categoria') 
    alter table [t_EramoDB_u_Opera] add [c_r_Categoria] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Opera] where [c_r_Categoria] is null)) alter table [t_EramoDB_u_Opera] alter column [c_r_Categoria] bigint not null else alter table [t_EramoDB_u_Opera] alter column [c_r_Categoria] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Opera_r_Categoria') 
    alter table [t_EramoDB_u_Opera] add constraint [fk_EramoDB_u_Opera_r_Categoria] foreign key ([c_r_Categoria]) references [t_EramoDB_u_Categoria]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=30)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],30,getdate(),N'<rise:newIndex xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>30</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:20:20</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:index><rise:name>id_opera</rise:name><rise:mustBeUnique>True</rise:mustBeUnique><rise:indexColumn><rise:attributeName>id_opera</rise:attributeName><rise:orderBy>ASC</rise:orderBy></rise:indexColumn></rise:index><rise:maxID>0</rise:maxID></rise:entity></rise:newIndex>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id_opera') 
    create unique index [idx_EramoDB_u_Opera_id_opera] on [t_EramoDB_u_Opera] ([c_u_id_opera] ASC)
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=31)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],31,getdate(),N'<rise:renameAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>31</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:23:40</rise:timeStamp><rise:entityName>Opera</rise:entityName><rise:attributeName>id_opera</rise:attributeName><rise:newAttributeName>id</rise:newAttributeName></rise:renameAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id_opera') 
    exec sp_rename N'[t_EramoDB_u_Opera].[idx_EramoDB_u_Opera_id_opera]',N'idx_EramoDB_u_Opera_id','INDEX'
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id_opera') 
    if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id') 
      exec sp_rename N'[ix_EramoDB_u_Opera_u_id_opera]',N'ix_EramoDB_u_Opera_u_id','OBJECT'
  if exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_u_id_opera') 
    if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_u_id') 
      exec sp_rename N'[t_EramoDB_u_Opera].[c_u_id_opera]',N'c_u_id','COLUMN'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=32)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],32,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>32</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:24:10</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>auto_increment</rise:check></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id') 
    drop index [idx_EramoDB_u_Opera_id] on [t_EramoDB_u_Opera]
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id') 
    alter table [t_EramoDB_u_Opera] drop constraint [ix_EramoDB_u_Opera_u_id]
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id') 
    alter table [t_EramoDB_u_Opera] add constraint [ix_EramoDB_u_Opera_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Opera_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Opera] add constraint [ck_EramoDB_u_Opera_u_id] check (auto_increment)')
    if(@@error <> 0) print 'constraint ignored!'
  end
  if not exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id') 
    create unique index [idx_EramoDB_u_Opera_id] on [t_EramoDB_u_Opera] ([c_u_id] ASC)
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=33)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],33,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>33</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:24:48</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id') 
    drop index [idx_EramoDB_u_Opera_id] on [t_EramoDB_u_Opera]
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id') 
    alter table [t_EramoDB_u_Opera] drop constraint [ix_EramoDB_u_Opera_u_id]
  if exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Opera_u_id') 
    alter table [t_EramoDB_u_Opera] drop constraint [ck_EramoDB_u_Opera_u_id]
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id') 
    alter table [t_EramoDB_u_Opera] add constraint [ix_EramoDB_u_Opera_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Opera_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Opera] add constraint [ck_EramoDB_u_Opera_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
  if not exists(select id from sysindexes where name='idx_EramoDB_u_Opera_id') 
    create unique index [idx_EramoDB_u_Opera_id] on [t_EramoDB_u_Opera] ([c_u_id] ASC)
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=34)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],34,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>34</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:25:41</rise:timeStamp><rise:entity><rise:name>Categoria</rise:name><rise:attribute><rise:name>id_categoria</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Categoria_u_id_categoria') 
    alter table [t_EramoDB_u_Categoria] drop constraint [ix_EramoDB_u_Categoria_u_id_categoria]
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Categoria_u_id_categoria') 
    alter table [t_EramoDB_u_Categoria] add constraint [ix_EramoDB_u_Categoria_u_id_categoria] unique nonclustered ([c_u_id_categoria])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Categoria_u_id_categoria') 
  begin
    execute('alter table [t_EramoDB_u_Categoria] add constraint [ck_EramoDB_u_Categoria_u_id_categoria] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=35)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],35,getdate(),N'<rise:renameAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>35</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:25:41</rise:timeStamp><rise:entityName>Categoria</rise:entityName><rise:attributeName>id_categoria</rise:attributeName><rise:newAttributeName>id</rise:newAttributeName></rise:renameAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Categoria_u_id_categoria') 
    if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Categoria_u_id') 
      exec sp_rename N'[ix_EramoDB_u_Categoria_u_id_categoria]',N'ix_EramoDB_u_Categoria_u_id','OBJECT'
  if exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Categoria_u_id_categoria') 
    alter table [t_EramoDB_u_Categoria] drop constraint [ck_EramoDB_u_Categoria_u_id_categoria]
  if exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Categoria') where sc.name='c_u_id_categoria') 
    if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Categoria') where sc.name='c_u_id') 
      exec sp_rename N'[t_EramoDB_u_Categoria].[c_u_id_categoria]',N'c_u_id','COLUMN'
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Categoria_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Categoria] add constraint [ck_EramoDB_u_Categoria_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=36)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],36,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>36</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:26:03</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>id_categoria</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Opera') where sc.name='c_u_id_categoria') 
    alter table [t_EramoDB_u_Opera] add [c_u_id_categoria] nvarchar(50) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=37)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],37,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>37</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:26:45</rise:timeStamp><rise:entity><rise:name>Opera</rise:name><rise:attribute><rise:name>id_categoria</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Categoria</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Opera] where [c_u_id_categoria] is null)) alter table [t_EramoDB_u_Opera] alter column [c_u_id_categoria] bigint not null else alter table [t_EramoDB_u_Opera] alter column [c_u_id_categoria] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Opera_u_id_categoria') 
    alter table [t_EramoDB_u_Opera] add constraint [ix_EramoDB_u_Opera_u_id_categoria] unique nonclustered ([c_u_id_categoria])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Opera_u_id_categoria') 
    alter table [t_EramoDB_u_Opera] add constraint [xf_EramoDB_u_Opera_u_id_categoria] foreign key ([c_u_id_categoria]) references [Categoria]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=38)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],38,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>38</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:27:23</rise:timeStamp><rise:entity><rise:name>Ruolo</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Ruolo') where sc.name='c_u_id') 
    alter table [t_EramoDB_u_Ruolo] add [c_u_id] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=39)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],39,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>39</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:27:43</rise:timeStamp><rise:entity><rise:name>Ruolo</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary  key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Ruolo] where [c_u_id] is null)) alter table [t_EramoDB_u_Ruolo] alter column [c_u_id] bigint not null else alter table [t_EramoDB_u_Ruolo] alter column [c_u_id] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Ruolo_u_id') 
    alter table [t_EramoDB_u_Ruolo] add constraint [ix_EramoDB_u_Ruolo_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Ruolo_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Ruolo] add constraint [ck_EramoDB_u_Ruolo_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=40)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],40,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>40</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:28:01</rise:timeStamp><rise:entity><rise:name>Ruolo</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Ruolo') where sc.name='c_u_nome') 
    alter table [t_EramoDB_u_Ruolo] add [c_u_nome] nvarchar(50) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=41)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],41,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>41</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:28:20</rise:timeStamp><rise:entity><rise:name>Ruolo</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Ruolo] where [c_u_nome] is null)) alter table [t_EramoDB_u_Ruolo] alter column [c_u_nome] nvarchar(50) not null else alter table [t_EramoDB_u_Ruolo] alter column [c_u_nome] nvarchar(50) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=42)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],42,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>42</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:28:30</rise:timeStamp><rise:entity><rise:name>Ruolo</rise:name><rise:attribute><rise:name>descrizione</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>200</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Ruolo') where sc.name='c_u_descrizione') 
    alter table [t_EramoDB_u_Ruolo] add [c_u_descrizione] nvarchar(200) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=43)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],43,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>43</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:29:04</rise:timeStamp><rise:relation><rise:name>RuoloUtente</rise:name><rise:node><rise:name>Ruolo</rise:name><rise:entityName>Ruolo</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Utente</rise:name><rise:entityName>Utente</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_r_Ruolo') 
    alter table [t_EramoDB_u_Utente] add [c_r_Ruolo] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_r_Ruolo] is null)) alter table [t_EramoDB_u_Utente] alter column [c_r_Ruolo] bigint not null else alter table [t_EramoDB_u_Utente] alter column [c_r_Ruolo] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Utente_r_Ruolo') 
    alter table [t_EramoDB_u_Utente] add constraint [fk_EramoDB_u_Utente_r_Ruolo] foreign key ([c_r_Ruolo]) references [t_EramoDB_u_Ruolo]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=44)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],44,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>44</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:29:46</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id_utente') 
    alter table [t_EramoDB_u_Utente] drop constraint [ix_EramoDB_u_Utente_u_id_utente]
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id_utente') 
    alter table [t_EramoDB_u_Utente] add constraint [ix_EramoDB_u_Utente_u_id_utente] unique nonclustered ([c_u_id_utente])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Utente_u_id_utente') 
  begin
    execute('alter table [t_EramoDB_u_Utente] add constraint [ck_EramoDB_u_Utente_u_id_utente] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=45)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],45,getdate(),N'<rise:renameAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>45</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:29:46</rise:timeStamp><rise:entityName>Utente</rise:entityName><rise:attributeName>id_utente</rise:attributeName><rise:newAttributeName>id</rise:newAttributeName></rise:renameAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id_utente') 
    if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id') 
      exec sp_rename N'[ix_EramoDB_u_Utente_u_id_utente]',N'ix_EramoDB_u_Utente_u_id','OBJECT'
  if exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Utente_u_id_utente') 
    alter table [t_EramoDB_u_Utente] drop constraint [ck_EramoDB_u_Utente_u_id_utente]
  if exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_id_utente') 
    if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_id') 
      exec sp_rename N'[t_EramoDB_u_Utente].[c_u_id_utente]',N'c_u_id','COLUMN'
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Utente_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Utente] add constraint [ck_EramoDB_u_Utente_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=46)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],46,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>46</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:30:06</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_ruolo</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_id_ruolo') 
    alter table [t_EramoDB_u_Utente] add [c_u_id_ruolo] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=47)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],47,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>47</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:30:47</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_ruolo</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Ruolo</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>Foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_id_ruolo] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_id_ruolo] bigint not null else alter table [t_EramoDB_u_Utente] alter column [c_u_id_ruolo] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Utente_u_id_ruolo') 
    alter table [t_EramoDB_u_Utente] add constraint [ix_EramoDB_u_Utente_u_id_ruolo] unique nonclustered ([c_u_id_ruolo])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Utente_u_id_ruolo') 
    alter table [t_EramoDB_u_Utente] add constraint [xf_EramoDB_u_Utente_u_id_ruolo] foreign key ([c_u_id_ruolo]) references [Ruolo]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=48)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],48,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>48</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:31:14</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_ruolo2</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.name='c_u_id_ruolo2') 
    alter table [t_EramoDB_u_Utente] add [c_u_id_ruolo2] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=49)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],49,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>49</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:33:16</rise:timeStamp><rise:entity><rise:name>Utente</rise:name><rise:attribute><rise:name>id_ruolo2</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:default>Null

</rise:default><rise:fkAttribute><rise:pkTable>Ruolo</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>Foreign key ......puo avere solamente valore nullo o l id che corrisponde a "trascrittore"</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Utente] where [c_u_id_ruolo2] is null)) alter table [t_EramoDB_u_Utente] alter column [c_u_id_ruolo2] bigint not null else alter table [t_EramoDB_u_Utente] alter column [c_u_id_ruolo2] bigint null')
  if not exists(select id from sysobjects where xtype='D' and name='df_EramoDB_u_Utente_u_id_ruolo2') 
  begin
    execute('alter table [t_EramoDB_u_Utente] add constraint [df_EramoDB_u_Utente_u_id_ruolo2] default (Null
  ) for [c_u_id_ruolo2] with values')
    if(@@error <> 0) print 'default value ignored!'
    else
    begin
      if exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Utente') where sc.isnullable=1 and sc.name='c_u_id_ruolo2') 
      begin
        execute('declare @v_default bigint set @v_default = Null
   update [t_EramoDB_u_Utente] set [c_u_id_ruolo2]=@v_default where [c_u_id_ruolo2] is null')
        alter table [t_EramoDB_u_Utente] alter column [c_u_id_ruolo2] bigint not null
      end
    end
  end
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Utente_u_id_ruolo2') 
    alter table [t_EramoDB_u_Utente] add constraint [xf_EramoDB_u_Utente_u_id_ruolo2] foreign key ([c_u_id_ruolo2]) references [Ruolo]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=50)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],50,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>50</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:34:18</rise:timeStamp><rise:relation><rise:name>UtenteImmagine</rise:name><rise:node><rise:name>Utente</rise:name><rise:entityName>Utente</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Immagine</rise:name><rise:entityName>Immagine</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_r_Utente') 
    alter table [t_EramoDB_u_Immagine] add [c_r_Utente] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Immagine] where [c_r_Utente] is null)) alter table [t_EramoDB_u_Immagine] alter column [c_r_Utente] bigint not null else alter table [t_EramoDB_u_Immagine] alter column [c_r_Utente] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Immagine_r_Utente') 
    alter table [t_EramoDB_u_Immagine] add constraint [fk_EramoDB_u_Immagine_r_Utente] foreign key ([c_r_Utente]) references [t_EramoDB_u_Utente]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=51)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],51,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>51</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:34:26</rise:timeStamp><rise:relation><rise:name>UtenteTrascrizione</rise:name><rise:node><rise:name>Utente</rise:name><rise:entityName>Utente</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Trascrizione</rise:name><rise:entityName>Trascrizione</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_r_Utente') 
    alter table [t_EramoDB_u_Trascrizione] add [c_r_Utente] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Trascrizione] where [c_r_Utente] is null)) alter table [t_EramoDB_u_Trascrizione] alter column [c_r_Utente] bigint not null else alter table [t_EramoDB_u_Trascrizione] alter column [c_r_Utente] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Trascrizione_r_Utente') 
    alter table [t_EramoDB_u_Trascrizione] add constraint [fk_EramoDB_u_Trascrizione_r_Utente] foreign key ([c_r_Utente]) references [t_EramoDB_u_Utente]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=52)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],52,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>52</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:35:38</rise:timeStamp><rise:relationName>UtenteTrascrizione</rise:relationName><rise:newRelationName>FA</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=53)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],53,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>53</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:36:04</rise:timeStamp><rise:relationName>UtenteImmagine</rise:relationName><rise:newRelationName>CARICA</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=54)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],54,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>54</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:36:40</rise:timeStamp><rise:relation><rise:name>Utente1Trascrizione1</rise:name><rise:node><rise:name>Utente1</rise:name><rise:entityName>Utente</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Trascrizione1</rise:name><rise:entityName>Trascrizione</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_r_Utente1') 
    alter table [t_EramoDB_u_Trascrizione] add [c_r_Utente1] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Trascrizione] where [c_r_Utente1] is null)) alter table [t_EramoDB_u_Trascrizione] alter column [c_r_Utente1] bigint not null else alter table [t_EramoDB_u_Trascrizione] alter column [c_r_Utente1] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Trascrizione_r_Utente1') 
    alter table [t_EramoDB_u_Trascrizione] add constraint [fk_EramoDB_u_Trascrizione_r_Utente1] foreign key ([c_r_Utente1]) references [t_EramoDB_u_Utente]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=55)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],55,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>55</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:37:13</rise:timeStamp><rise:relationName>Utente1Trascrizione1</rise:relationName><rise:newRelationName>Revisiona</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=56)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],56,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>56</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:37:59</rise:timeStamp><rise:relation><rise:name>Utente1Immagine1</rise:name><rise:node><rise:name>Utente1</rise:name><rise:entityName>Utente</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Immagine1</rise:name><rise:entityName>Immagine</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_r_Utente1') 
    alter table [t_EramoDB_u_Immagine] add [c_r_Utente1] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Immagine] where [c_r_Utente1] is null)) alter table [t_EramoDB_u_Immagine] alter column [c_r_Utente1] bigint not null else alter table [t_EramoDB_u_Immagine] alter column [c_r_Utente1] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Immagine_r_Utente1') 
    alter table [t_EramoDB_u_Immagine] add constraint [fk_EramoDB_u_Immagine_r_Utente1] foreign key ([c_r_Utente1]) references [t_EramoDB_u_Utente]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=57)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],57,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>57</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:38:19</rise:timeStamp><rise:relationName>Utente1Immagine1</rise:relationName><rise:newRelationName>Supervisiona</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=58)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],58,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>58</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:38:49</rise:timeStamp><rise:relation><rise:name>TrascrizionePagina</rise:name><rise:node><rise:name>Trascrizione</rise:name><rise:entityName>Trascrizione</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Pagina</rise:name><rise:entityName>Pagina</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_r_Trascrizione') 
    alter table [t_EramoDB_u_Pagina] add [c_r_Trascrizione] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_r_Trascrizione] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_r_Trascrizione] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_r_Trascrizione] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Pagina_r_Trascrizione') 
    alter table [t_EramoDB_u_Pagina] add constraint [fk_EramoDB_u_Pagina_r_Trascrizione] foreign key ([c_r_Trascrizione]) references [t_EramoDB_u_Trascrizione]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=59)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],59,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>59</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:39:25</rise:timeStamp><rise:relationName>TrascrizionePagina</rise:relationName><rise:newRelationName>Trascrizione+Immagine_forma</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=60)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],60,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>60</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:39:33</rise:timeStamp><rise:relation><rise:name>ImmaginePagina</rise:name><rise:node><rise:name>Immagine</rise:name><rise:entityName>Immagine</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Pagina</rise:name><rise:entityName>Pagina</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_r_Immagine') 
    alter table [t_EramoDB_u_Pagina] add [c_r_Immagine] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_r_Immagine] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_r_Immagine] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_r_Immagine] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Pagina_r_Immagine') 
    alter table [t_EramoDB_u_Pagina] add constraint [fk_EramoDB_u_Pagina_r_Immagine] foreign key ([c_r_Immagine]) references [t_EramoDB_u_Immagine]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=61)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],61,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>61</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:40:52</rise:timeStamp><rise:relationName>ImmaginePagina</rise:relationName><rise:newRelationName>Immagine+(Trascrizione)_forma</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=62)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],62,getdate(),N'<rise:newRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>62</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:41:51</rise:timeStamp><rise:relation><rise:name>OperaPagina</rise:name><rise:node><rise:name>Opera</rise:name><rise:entityName>Opera</rise:entityName><rise:cardinality>1</rise:cardinality></rise:node><rise:node><rise:name>Pagina</rise:name><rise:entityName>Pagina</rise:entityName><rise:cardinality>0toN</rise:cardinality></rise:node><rise:maxID>0</rise:maxID></rise:relation></rise:newRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_r_Opera') 
    alter table [t_EramoDB_u_Pagina] add [c_r_Opera] bigint null
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_r_Opera] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_r_Opera] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_r_Opera] bigint null')
  if not exists(select id from sysobjects where xtype='F' and name='fk_EramoDB_u_Pagina_r_Opera') 
    alter table [t_EramoDB_u_Pagina] add constraint [fk_EramoDB_u_Pagina_r_Opera] foreign key ([c_r_Opera]) references [t_EramoDB_u_Opera]([c_id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=63)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],63,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>63</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:42:23</rise:timeStamp><rise:relationName>OperaPagina</rise:relationName><rise:newRelationName>E composta da</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=64)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],64,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>64</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:42:36</rise:timeStamp><rise:relationName>CategoriaOpera</rise:relationName><rise:newRelationName>Fa Parte</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=65)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],65,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>65</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:42:48</rise:timeStamp><rise:relationName>RuoloUtente</rise:relationName><rise:newRelationName>Ricopre</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=66)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],66,getdate(),N'<rise:renameRelation xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>66</rise:sequenceNumber><rise:timeStamp>2018-04-26T12:43:13</rise:timeStamp><rise:relationName>Ricopre</rise:relationName><rise:newRelationName>E Ricoperto</rise:newRelationName></rise:renameRelation>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=67)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],67,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>67</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:05:33</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_u_id') 
    alter table [t_EramoDB_u_Immagine] add [c_u_id] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=68)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],68,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>68</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:05:46</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Immagine] where [c_u_id] is null)) alter table [t_EramoDB_u_Immagine] alter column [c_u_id] bigint not null else alter table [t_EramoDB_u_Immagine] alter column [c_u_id] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Immagine_u_id') 
    alter table [t_EramoDB_u_Immagine] add constraint [ix_EramoDB_u_Immagine_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Immagine_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Immagine] add constraint [ck_EramoDB_u_Immagine_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=69)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],69,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>69</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:06:00</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>nome</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_u_nome') 
    alter table [t_EramoDB_u_Immagine] add [c_u_nome] nvarchar(50) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=70)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],70,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>70</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:06:16</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>fileJPEG</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>200</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_u_fileJPEG') 
    alter table [t_EramoDB_u_Immagine] add [c_u_fileJPEG] nvarchar(200) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=71)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],71,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>71</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:06:21</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>fileJPEG</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>200</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Immagine] where [c_u_fileJPEG] is null)) alter table [t_EramoDB_u_Immagine] alter column [c_u_fileJPEG] nvarchar(200) not null else alter table [t_EramoDB_u_Immagine] alter column [c_u_fileJPEG] nvarchar(200) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=72)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],72,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>72</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:06:39</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>id_utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Immagine') where sc.name='c_u_id_utente') 
    alter table [t_EramoDB_u_Immagine] add [c_u_id_utente] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=73)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],73,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>73</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:07:09</rise:timeStamp><rise:entity><rise:name>Immagine</rise:name><rise:attribute><rise:name>id_utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Utente</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Immagine] where [c_u_id_utente] is null)) alter table [t_EramoDB_u_Immagine] alter column [c_u_id_utente] bigint not null else alter table [t_EramoDB_u_Immagine] alter column [c_u_id_utente] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Immagine_u_id_utente') 
    alter table [t_EramoDB_u_Immagine] add constraint [ix_EramoDB_u_Immagine_u_id_utente] unique nonclustered ([c_u_id_utente])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Immagine_u_id_utente') 
    alter table [t_EramoDB_u_Immagine] add constraint [xf_EramoDB_u_Immagine_u_id_utente] foreign key ([c_u_id_utente]) references [Utente]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=74)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],74,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>74</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:07:44</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_u_id') 
    alter table [t_EramoDB_u_Trascrizione] add [c_u_id] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=75)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],75,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>75</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:08:04</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_inrement</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Trascrizione] where [c_u_id] is null)) alter table [t_EramoDB_u_Trascrizione] alter column [c_u_id] bigint not null else alter table [t_EramoDB_u_Trascrizione] alter column [c_u_id] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Trascrizione_u_id') 
    alter table [t_EramoDB_u_Trascrizione] add constraint [ix_EramoDB_u_Trascrizione_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Trascrizione_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Trascrizione] add constraint [ck_EramoDB_u_Trascrizione_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=76)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],76,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>76</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:08:34</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>titolo</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_u_titolo') 
    alter table [t_EramoDB_u_Trascrizione] add [c_u_titolo] nvarchar(50) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=77)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],77,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>77</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:08:46</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>descrizione</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>50</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_u_descrizione') 
    alter table [t_EramoDB_u_Trascrizione] add [c_u_descrizione] nvarchar(50) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=78)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],78,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>78</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:09:07</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>testo</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>500000</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_u_testo') 
    alter table [t_EramoDB_u_Trascrizione] add [c_u_testo] nvarchar(500000) null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=79)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],79,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>79</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:09:17</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>testo</rise:name><rise:dataTypeAlias /><rise:dataType>string</rise:dataType><rise:dataSize>500000</rise:dataSize><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Trascrizione] where [c_u_testo] is null)) alter table [t_EramoDB_u_Trascrizione] alter column [c_u_testo] nvarchar(500000) not null else alter table [t_EramoDB_u_Trascrizione] alter column [c_u_testo] nvarchar(500000) null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=80)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],80,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>80</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:09:29</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>id_Utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Trascrizione') where sc.name='c_u_id_Utente') 
    alter table [t_EramoDB_u_Trascrizione] add [c_u_id_Utente] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=81)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],81,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>81</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:09:54</rise:timeStamp><rise:entity><rise:name>Trascrizione</rise:name><rise:attribute><rise:name>id_Utente</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Utente</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Trascrizione] where [c_u_id_Utente] is null)) alter table [t_EramoDB_u_Trascrizione] alter column [c_u_id_Utente] bigint not null else alter table [t_EramoDB_u_Trascrizione] alter column [c_u_id_Utente] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Trascrizione_u_id_Utente') 
    alter table [t_EramoDB_u_Trascrizione] add constraint [ix_EramoDB_u_Trascrizione_u_id_Utente] unique nonclustered ([c_u_id_Utente])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Trascrizione_u_id_Utente') 
    alter table [t_EramoDB_u_Trascrizione] add constraint [xf_EramoDB_u_Trascrizione_u_id_Utente] foreign key ([c_u_id_Utente]) references [Utente]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=82)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],82,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>82</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:10:10</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_u_id') 
    alter table [t_EramoDB_u_Pagina] add [c_u_id] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=83)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],83,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>83</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:10:22</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:check>primary key</rise:check><rise:description>auto_increment</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_u_id] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_u_id] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_u_id] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Pagina_u_id') 
    alter table [t_EramoDB_u_Pagina] add constraint [ix_EramoDB_u_Pagina_u_id] unique nonclustered ([c_u_id])
  if not exists(select id from sysobjects where xtype='C' and name='ck_EramoDB_u_Pagina_u_id') 
  begin
    execute('alter table [t_EramoDB_u_Pagina] add constraint [ck_EramoDB_u_Pagina_u_id] check (primary)')
    if(@@error <> 0) print 'constraint ignored!'
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=84)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],84,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>84</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:10:34</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>numero</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_u_numero') 
    alter table [t_EramoDB_u_Pagina] add [c_u_numero] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=85)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],85,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>85</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:10:36</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>numero</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_u_numero] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_u_numero] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_u_numero] bigint null')
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=86)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],86,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>86</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:10:52</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>numero</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:default>0
</rise:default></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select id from sysobjects where xtype='D' and name='df_EramoDB_u_Pagina_u_numero') 
  begin
    execute('alter table [t_EramoDB_u_Pagina] add constraint [df_EramoDB_u_Pagina_u_numero] default (0
  ) for [c_u_numero] with values')
    if(@@error <> 0) print 'default value ignored!'
    else
    begin
      if exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.isnullable=1 and sc.name='c_u_numero') 
      begin
        execute('declare @v_default bigint set @v_default = 0
   update [t_EramoDB_u_Pagina] set [c_u_numero]=@v_default where [c_u_numero] is null')
        alter table [t_EramoDB_u_Pagina] alter column [c_u_numero] bigint not null
      end
    end
  end
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=87)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],87,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>87</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:11:48</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_trascrizione</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_u_id_trascrizione') 
    alter table [t_EramoDB_u_Pagina] add [c_u_id_trascrizione] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=88)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],88,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>88</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:12:12</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_trascrizione</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Trascrizione</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_u_id_trascrizione] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_u_id_trascrizione] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_u_id_trascrizione] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Pagina_u_id_trascrizione') 
    alter table [t_EramoDB_u_Pagina] add constraint [ix_EramoDB_u_Pagina_u_id_trascrizione] unique nonclustered ([c_u_id_trascrizione])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Pagina_u_id_trascrizione') 
    alter table [t_EramoDB_u_Pagina] add constraint [xf_EramoDB_u_Pagina_u_id_trascrizione] foreign key ([c_u_id_trascrizione]) references [Trascrizione]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=89)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],89,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>89</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:12:25</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_Immagine</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_u_id_Immagine') 
    alter table [t_EramoDB_u_Pagina] add [c_u_id_Immagine] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=90)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],90,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>90</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:12:42</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_Immagine</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Immagine</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_u_id_Immagine] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_u_id_Immagine] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_u_id_Immagine] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Pagina_u_id_Immagine') 
    alter table [t_EramoDB_u_Pagina] add constraint [ix_EramoDB_u_Pagina_u_id_Immagine] unique nonclustered ([c_u_id_Immagine])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Pagina_u_id_Immagine') 
    alter table [t_EramoDB_u_Pagina] add constraint [xf_EramoDB_u_Pagina_u_id_Immagine] foreign key ([c_u_id_Immagine]) references [Immagine]([id])
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=91)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],91,getdate(),N'<rise:newAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>91</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:13:09</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_opera</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>False</rise:mustBeUnique><rise:mustExist>False</rise:mustExist></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:newAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  if not exists(select sc.id from syscolumns sc join sysobjects so on (so.id =sc.id and so.xtype ='U' and so.name='t_EramoDB_u_Pagina') where sc.name='c_u_id_opera') 
    alter table [t_EramoDB_u_Pagina] add [c_u_id_opera] bigint null
end
GO -- 'end-of-command

if exists(select * from [v_rise_nextSN] where [prefix]=N'EramoDB' and [guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb' and [SN]=92)
begin
  insert into [t_rise_u_log]([c_r_model],[c_u_sequenceNumber],[c_u_timeStamp],[c_u_xml]) select [c_id],92,getdate(),N'<rise:editAttribute xmlns:rise="http://www.r2bsoftware/ns/rise/"><rise:sequenceNumber>92</rise:sequenceNumber><rise:timeStamp>2018-04-26T14:13:34</rise:timeStamp><rise:entity><rise:name>Pagina</rise:name><rise:attribute><rise:name>id_opera</rise:name><rise:dataTypeAlias /><rise:dataType>int</rise:dataType><rise:mustBeUnique>True</rise:mustBeUnique><rise:mustExist>True</rise:mustExist><rise:fkAttribute><rise:pkTable>Opera</rise:pkTable><rise:pkColumn>id</rise:pkColumn></rise:fkAttribute><rise:description>foreign key</rise:description></rise:attribute><rise:maxID>0</rise:maxID></rise:entity></rise:editAttribute>' from [t_rise_u_model] where [c_u_guid]=N'83633980-65ef-46e2-834e-6dc3c6b448bb'
  execute('if(not exists(select * from [t_EramoDB_u_Pagina] where [c_u_id_opera] is null)) alter table [t_EramoDB_u_Pagina] alter column [c_u_id_opera] bigint not null else alter table [t_EramoDB_u_Pagina] alter column [c_u_id_opera] bigint null')
  if not exists(select id from sysobjects where xtype='UQ' and name='ix_EramoDB_u_Pagina_u_id_opera') 
    alter table [t_EramoDB_u_Pagina] add constraint [ix_EramoDB_u_Pagina_u_id_opera] unique nonclustered ([c_u_id_opera])
  if not exists(select id from sysobjects where xtype='F' and name='xf_EramoDB_u_Pagina_u_id_opera') 
    alter table [t_EramoDB_u_Pagina] add constraint [xf_EramoDB_u_Pagina_u_id_opera] foreign key ([c_u_id_opera]) references [Opera]([id])
end
GO -- 'end-of-command

