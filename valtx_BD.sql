prompt PL/SQL Developer Export User Objects for user VALTX@XE
prompt Created by Mauricio on martes, 12 de Octubre de 2021
set define off
spool valtx_BD.log

prompt
prompt Creating table PRODUCTO
prompt =======================
prompt
create table VALTX.PRODUCTO
(
  cod_producto CHAR(2) not null,
  nombre       VARCHAR2(50) not null,
  precio       NUMBER(10,2) not null,
  estado       NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table VALTX.PRODUCTO
  add constraint PK_PRODUCTO primary key (COD_PRODUCTO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table VALTX.PRODUCTO
  add constraint CHK_PRODUCTO_PRECIO
  check (precio>0);

prompt
prompt Creating table SUCURSAL
prompt =======================
prompt
create table VALTX.SUCURSAL
(
  cod_sucursal CHAR(2) not null,
  nombre       VARCHAR2(50) not null,
  estado       NUMBER(1)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table VALTX.SUCURSAL
  add constraint PK_SUCURSAL primary key (COD_SUCURSAL)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table USUARIO
prompt ======================
prompt
create table VALTX.USUARIO
(
  cod_usuario  CHAR(2) not null,
  nombre       VARCHAR2(50) not null,
  login        VARCHAR2(50) not null,
  clave        VARCHAR2(50) not null,
  cod_sucursal CHAR(2) not null,
  estado       NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table VALTX.USUARIO
  add constraint PK_USUARIO primary key (COD_USUARIO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table VALTX.USUARIO
  add constraint FK_SUCURSAL foreign key (COD_SUCURSAL)
  references VALTX.SUCURSAL (COD_SUCURSAL);

prompt
prompt Creating package PCK_VALTX
prompt ==========================
prompt
create or replace noneditionable package valtx.PCK_VALTX is
  procedure PRC_CONSULTAR_SUCURSALES(i_cod_sucursal     IN VARCHAR2,
                                     i_npagina          IN INTEGER,
                                     i_nregistros       IN INTEGER,
                                     o_cursor           OUT SYS_REFCURSOR,
                                     o_retorno          OUT INTEGER,
                                     o_mensaje          OUT VARCHAR2,
                                     o_sqlerrm          OUT VARCHAR2);

  procedure PRC_INSERTAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2);

  procedure PRC_MODIFICAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                     i_nombre       IN VARCHAR2,
                                     o_retorno      OUT INTEGER,
                                     o_mensaje      OUT VARCHAR2,
                                     o_sqlerrm      OUT VARCHAR2);

  procedure PRC_ANULAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                  o_retorno      OUT INTEGER,
                                  o_mensaje      OUT VARCHAR2,
                                  o_sqlerrm      OUT VARCHAR2);                                  

  procedure PRC_CONSULTAR_PRODUCTOS(i_cod_producto     IN VARCHAR2,
                                     i_npagina          IN INTEGER,
                                     i_nregistros       IN INTEGER,
                                     o_cursor           OUT SYS_REFCURSOR,
                                     o_retorno          OUT INTEGER,
                                     o_mensaje          OUT VARCHAR2,
                                     o_sqlerrm          OUT VARCHAR2);

  procedure PRC_INSERTAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    i_precio       IN DECIMAL,
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2);

  procedure PRC_MODIFICAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                     i_nombre       IN VARCHAR2,
                                     i_precio       IN DECIMAL,
                                     o_retorno      OUT INTEGER,
                                     o_mensaje      OUT VARCHAR2,
                                     o_sqlerrm      OUT VARCHAR2);

  procedure PRC_ANULAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                  o_retorno      OUT INTEGER,
                                  o_mensaje      OUT VARCHAR2,
                                  o_sqlerrm      OUT VARCHAR2);   

  procedure PRC_CONSULTAR_USUARIOS(i_cod_usuario     IN VARCHAR2,
                                   i_npagina          IN INTEGER,
                                   i_nregistros       IN INTEGER,
                                   o_cursor           OUT SYS_REFCURSOR,
                                   o_retorno          OUT INTEGER,
                                   o_mensaje          OUT VARCHAR2,
                                   o_sqlerrm          OUT VARCHAR2);

  procedure PRC_INSERTAR_USUARIOS(i_cod_usuario IN VARCHAR2,
                                  i_nombre       IN VARCHAR2,
                                  i_login        IN VARCHAR2,
                                  i_clave        IN VARCHAR2,
                                  i_cod_sucursal IN VARCHAR2,
                                  o_retorno      OUT INTEGER,
                                  o_mensaje      OUT VARCHAR2,
                                  o_sqlerrm      OUT VARCHAR2);

  procedure PRC_MODIFICAR_USUARIOS(i_cod_usuario IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    i_login        IN VARCHAR2,
                                    i_clave        IN VARCHAR2,
                                    i_cod_sucursal IN VARCHAR2,
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2);

  procedure PRC_ANULAR_USUARIOS(i_cod_usuario IN VARCHAR2,
                                o_retorno      OUT INTEGER,
                                o_mensaje      OUT VARCHAR2,
                                o_sqlerrm      OUT VARCHAR2); 
end PCK_VALTX;
/

prompt
prompt Creating package body PCK_VALTX
prompt ===============================
prompt
create or replace noneditionable package body valtx.PCK_VALTX is
  procedure PRC_CONSULTAR_SUCURSALES(i_cod_sucursal     IN VARCHAR2,
                                     i_npagina          IN INTEGER,
                                     i_nregistros       IN INTEGER,
                                     o_cursor           OUT SYS_REFCURSOR,
                                     o_retorno          OUT INTEGER,
                                     o_mensaje          OUT VARCHAR2,
                                     o_sqlerrm          OUT VARCHAR2) IS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Transacción correctamente efectuada';
  
    open o_cursor for
      SELECT *
        FROM (SELECT r.*, ROWNUM RNUM, COUNT(*) OVER() RESULT_COUNT
                FROM (SELECT *
                        FROM (SELECT o.cod_sucursal, o.nombre, o.estado
                                FROM sucursal o
                                WHERE i_cod_sucursal IS NULL or COD_SUCURSAL = I_COD_SUCURSAL)
                       ORDER BY cod_sucursal ASC) R)
       WHERE RNUM between ((i_npagina - 1) * i_nregistros) + 1 and
             i_npagina * i_nregistros;
  EXCEPTION
    WHEN OTHERS THEN
      o_retorno := 1;
      o_mensaje := 'No se obtuvo los registros de SUCURSAL';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
    
  END PRC_CONSULTAR_SUCURSALES;

  procedure PRC_INSERTAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2) IS
  
    existe_registro number := 0;
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Inserción Satisfactoria';
  
    select nvl(count(*), 0)
      into existe_registro
      from sucursal
     where cod_sucursal = i_cod_sucursal;
  
    if (existe_registro > 0) then
      o_mensaje := 'Ya existe ese Cod_sucursal';
      o_retorno := 1;
      return;
    end if;
  
    insert into sucursal values (i_cod_sucursal, i_nombre, 1);
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 2;
      o_mensaje := 'No se pudo ingresar el registro a SUCURSAL';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_INSERTAR_SUCURSALES;

  procedure PRC_MODIFICAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                     i_nombre       IN VARCHAR2,
                                     o_retorno      OUT INTEGER,
                                     o_mensaje      OUT VARCHAR2,
                                     o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Modificación Satisfactoria';
  
    update sucursal
       set nombre = i_nombre
     where cod_sucursal = i_cod_sucursal;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo actualizar el registro a SUCURSAL';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_MODIFICAR_SUCURSALES;

  procedure PRC_ANULAR_SUCURSALES(i_cod_sucursal IN VARCHAR2,
                                  o_retorno      OUT INTEGER,
                                  o_mensaje      OUT VARCHAR2,
                                  o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Anulación Satisfactoria';
    update sucursal set estado = 0 where cod_sucursal = i_cod_sucursal;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo anular el registro a SUCURSAL';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_ANULAR_SUCURSALES;

  procedure PRC_CONSULTAR_PRODUCTOS(i_cod_producto     IN VARCHAR2,
                                     i_npagina          IN INTEGER,
                                     i_nregistros       IN INTEGER,
                                     o_cursor           OUT SYS_REFCURSOR,
                                     o_retorno          OUT INTEGER,
                                     o_mensaje          OUT VARCHAR2,
                                     o_sqlerrm          OUT VARCHAR2) IS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Transacción correctamente efectuada';
  
    open o_cursor for
      SELECT *
        FROM (SELECT r.*, ROWNUM RNUM, COUNT(*) OVER() RESULT_COUNT
                FROM (SELECT *
                        FROM (SELECT o.cod_producto, o.nombre, o.precio, o.estado
                                FROM producto o
                                WHERE i_cod_producto IS NULL or cod_producto = i_cod_producto)
                       ORDER BY cod_producto ASC) R)
       WHERE RNUM between ((i_npagina - 1) * i_nregistros) + 1 and
             i_npagina * i_nregistros;
  EXCEPTION
    WHEN OTHERS THEN
      o_retorno := 1;
      o_mensaje := 'No se obtuvo los registros de PRODUCTO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
    
  END PRC_CONSULTAR_PRODUCTOS;

  procedure PRC_INSERTAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    i_precio       IN DECIMAL,
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2) IS
  
    existe_registro number := 0;
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Inserción Satisfactoria';
  
    select nvl(count(*), 0)
      into existe_registro
      from producto
     where cod_producto = i_cod_producto;
  
    if (existe_registro > 0) then
      o_mensaje := 'Ya existe ese Cod_Producto';
      o_retorno := 1;
      return;
    end if;
  
    insert into producto values (i_cod_producto, i_nombre, i_precio, 1);
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 2;
      o_mensaje := 'No se pudo ingresar el registro a PRODUCTO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_INSERTAR_PRODUCTOS;

  procedure PRC_MODIFICAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                     i_nombre       IN VARCHAR2,
                                     i_precio       IN DECIMAL,
                                     o_retorno      OUT INTEGER,
                                     o_mensaje      OUT VARCHAR2,
                                     o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Modificación Satisfactoria';
  
    update producto
       set nombre = i_nombre, precio = i_precio
     where cod_producto = i_cod_producto;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo actualizar el registro a PRODUCTO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_MODIFICAR_PRODUCTOS;

  procedure PRC_ANULAR_PRODUCTOS(i_cod_producto IN VARCHAR2,
                                  o_retorno      OUT INTEGER,
                                  o_mensaje      OUT VARCHAR2,
                                  o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Anulación Satisfactoria';
    update producto set estado = 0 where cod_producto = i_cod_producto;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo anular el registro a PRODUCTO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_ANULAR_PRODUCTOS;

  procedure PRC_CONSULTAR_USUARIOS(i_cod_usuario     IN VARCHAR2,
                                   i_npagina          IN INTEGER,
                                   i_nregistros       IN INTEGER,
                                   o_cursor           OUT SYS_REFCURSOR,
                                   o_retorno          OUT INTEGER,
                                   o_mensaje          OUT VARCHAR2,
                                   o_sqlerrm          OUT VARCHAR2) IS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Transacción correctamente efectuada';
  
    open o_cursor for
      SELECT *
        FROM (SELECT r.*, ROWNUM RNUM, COUNT(*) OVER() RESULT_COUNT
                FROM (SELECT *
                        FROM (SELECT o.cod_usuario, o.nombre, o.login, o.clave, o.estado, o.cod_sucursal, a.nombre nombresucursal
                                FROM usuario o 
                                LEFT OUTER JOIN sucursal a on a.cod_sucursal = o.cod_sucursal
                                WHERE i_cod_usuario IS NULL or cod_usuario = i_cod_usuario)
                       ORDER BY cod_usuario ASC) R)
       WHERE RNUM between ((i_npagina - 1) * i_nregistros) + 1 and
             i_npagina * i_nregistros;
  EXCEPTION
    WHEN OTHERS THEN
      o_retorno := 1;
      o_mensaje := 'No se obtuvo los registros de USUARIO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
    
  END PRC_CONSULTAR_USUARIOS;

  procedure PRC_INSERTAR_USUARIOS(i_cod_usuario IN VARCHAR2,
                                    i_nombre       IN VARCHAR2,
                                    i_login        IN VARCHAR2,
                                    i_clave        IN VARCHAR2,                                    
                                    i_cod_sucursal IN VARCHAR2,                                    
                                    o_retorno      OUT INTEGER,
                                    o_mensaje      OUT VARCHAR2,
                                    o_sqlerrm      OUT VARCHAR2) IS
  
    existe_registro number := 0;
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Inserción Satisfactoria';
  
    select nvl(count(*), 0)
      into existe_registro
      from usuario
     where cod_usuario = i_cod_usuario;
  
    if (existe_registro > 0) then
      o_mensaje := 'Ya existe ese Cod_Usuario';
      o_retorno := 1;
      return;
    end if;
  
    insert into usuario values (i_cod_usuario, i_nombre, i_login, i_clave, i_cod_sucursal, 1);
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 2;
      o_mensaje := 'No se pudo ingresar el registro a USUARIO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_INSERTAR_USUARIOS;

  procedure PRC_MODIFICAR_USUARIOS(i_cod_usuario  IN VARCHAR2,
                                   i_nombre       IN VARCHAR2,
                                   i_login        IN VARCHAR2,
                                   i_clave        IN VARCHAR2,
                                   i_cod_sucursal IN VARCHAR2,
                                   o_retorno      OUT INTEGER,
                                   o_mensaje      OUT VARCHAR2,
                                   o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Modificación Satisfactoria';
  
    update usuario
       set nombre = i_nombre, 
           login = i_login,
           clave = i_clave,
           cod_sucursal = i_cod_sucursal
     where cod_usuario = i_cod_usuario;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo actualizar el registro a USUARIO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_MODIFICAR_USUARIOS;

  procedure PRC_ANULAR_USUARIOS(i_cod_usuario IN VARCHAR2,
                                o_retorno      OUT INTEGER,
                                o_mensaje      OUT VARCHAR2,
                                o_sqlerrm      OUT VARCHAR2) AS
  BEGIN
    o_retorno := 0;
    o_mensaje := 'Anulación Satisfactoria';
    update usuario set estado = 0 where cod_usuario = i_cod_usuario;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      o_retorno := 1;
      o_mensaje := 'No se pudo anular el registro a USUARIO';
      o_sqlerrm := SQLCODE || ': ' || SQLERRM;
      RETURN;
  END PRC_ANULAR_USUARIOS;

end PCK_VALTX;
/


prompt Done
spool off
set define on
