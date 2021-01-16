USE prediksi_persediaan

CREATE TABLE data_awal(
    id_stok INT NOT NULL,
    bulan INT,
    tahun VARCHAR(30) NOT NULL,
    angka_aktual INT NOT NULL
)

SELECT * FROM data_awal
DROP TABLE data_awal

TRUNCATE TABLE data_awal
/*-----------------------------------------------------inserting data*/

INSERT INTO data_awal VALUES(1,1,'2020',20)
INSERT INTO data_awal VALUES(2,2,'2020',10)
INSERT INTO data_awal VALUES(3,3,'2020',10)
INSERT INTO data_awal VALUES(4,4,'2020',20)
INSERT INTO data_awal VALUES(5,5,'2020',60)
INSERT INTO data_awal VALUES(6,6,'2020',20)
INSERT INTO data_awal VALUES(7,7,'2020',95)
INSERT INTO data_awal VALUES(8,8,'2020',86)
INSERT INTO data_awal VALUES(9,9,'2020',51)
INSERT INTO data_awal VALUES(10,10,'2020',87)
INSERT INTO data_awal VALUES(11,11,'2020',51)
INSERT INTO data_awal VALUES(12,12,'2020',55)
INSERT INTO data_awal VALUES(13,1,'2021',56)
INSERT INTO data_awal VALUES(14,2,'2021',94)
INSERT INTO data_awal VALUES(15,3,'2021',64)
INSERT INTO data_awal VALUES(16,4,'2021',34)
INSERT INTO data_awal VALUES(17,5,'2021',65)
INSERT INTO data_awal VALUES(18,6,'2021',50)
INSERT INTO data_awal VALUES(19,7,'2021',56)
INSERT INTO data_awal VALUES(20,8,'2021',60)
INSERT INTO data_awal VALUES(21,9,'2021',68)
INSERT INTO data_awal VALUES(22,10,'2021',68)
INSERT INTO data_awal VALUES(23,11,'2021',68)
INSERT INTO data_awal VALUES(24,12,'2021',68)
INSERT INTO data_awal VALUES(25,1,'2022',70)

DELETE FROM data_awal
WHERE id_stok = 19
/*----------------------EXECUTE FROM THIS LINE-------------------------------------------------*/

/*--------------------------------------------------------------------tampilkan data aktual*/
DECLARE @bulan1 INT, @tahun1 VARCHAR(30), @aktual INT, @idstok INT

PRINT '--------------------DATA AKTUAL-----------------'
PRINT 'ID ' +'  Bulan ' + '-  Tahun  ' + '   -  Angka Aktual  '

DECLARE print_data CURSOR FOR
    SELECT id_stok,bulan,tahun,angka_aktual
        FROM data_awal
OPEN print_data
FETCH NEXT FROM print_data INTO @idstok,@bulan1,@tahun1,@aktual
WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT CONVERT(VARCHAR(30),@idstok)+ '  -   ' + CONVERT(VARCHAR(30),@bulan1) + '     -    ' + @tahun1 + '    -   ' + CONVERT(VARCHAR(30),@aktual)
        FETCH NEXT FROM print_data INTO @idstok,@bulan1,@tahun1,@aktual
    END
CLOSE print_data
DEALLOCATE print_data

/*-----------------------------tampilkan prediksi-------------------*/

DECLARE @bulan INT, @prediksi INT, @tahun VARCHAR(30)
PRINT '--------------------DATA PREDIKSI-----------------'
PRINT 'Bulan ' + '   -  Tahun  '+ '-  Prediksi  ' 

/*making CURSOR*/
DECLARE print_prediksi CURSOR FOR
    SELECT 
   bulan,tahun, 
   (SELECT ISNULL(AVG(B.angka_aktual), A.angka_aktual) /*calculate average B.angka_aktual while A.angka_aktual values ISNULL */
     FROM data_awal B                                 
     WHERE (B.id_stok < A.id_stok)                     /*if B.id_stok less than A.id_stok*/
     AND   B.id_stok >= (A.id_stok - 3)                /*and B.id_stok greater equal than A.id_stok minus by 3*/
   ) AS prediksi
FROM data_awal A
WHERE A.id_stok > 3                                    /*showing data if A.stok id greater than 3*/

OPEN print_prediksi
FETCH NEXT FROM print_prediksi INTO @bulan,@tahun,@prediksi
WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT CONVERT(VARCHAR(30),@bulan) + '     -    ' +      @tahun    + '    -   '+ CONVERT(VARCHAR(30),@prediksi)
        FETCH NEXT FROM print_prediksi INTO @bulan,@tahun,@prediksi
    END
CLOSE print_prediksi
DEALLOCATE print_prediksi

/*----------------------------------------------making new row to new prediction*/
DECLARE @id_tambah INT, @prediksi2 INT, @id INT, @bulan2 INT, @tahun2 VARCHAR(30), @angka_aktual INT
SET @bulan2 = (SELECT TOP(1) bulan FROM data_awal ORDER BY id_stok DESC)+1
SET @id = (SELECT TOP(1) id_stok FROM data_awal ORDER BY id_stok DESC)
SET @tahun2 = (SELECT TOP(1) tahun FROM data_awal ORDER BY id_stok DESC)

SET @prediksi2 = 
        (SELECT AVG(angka_aktual) as Total
        FROM (SELECT TOP 3 angka_aktual from data_awal ORDER BY id_stok DESC) AS t)   

IF @bulan2 >= 13
    SET @bulan2 = 1;
ELSE 
    SET @bulan2 = (SELECT TOP(1) bulan FROM data_awal ORDER BY id_stok DESC)+1;
IF @bulan2 = 1
    SET @tahun2 = (SELECT TOP(1) tahun FROM data_awal ORDER BY id_stok DESC)+1;
ELSE
     SET @tahun2 = (SELECT TOP(1) tahun FROM data_awal ORDER BY id_stok DESC);
PRINT CONVERT(VARCHAR(30),@bulan2) + '     -    ' +      @tahun2    + '    -   '+ CONVERT(VARCHAR(30),@prediksi2)