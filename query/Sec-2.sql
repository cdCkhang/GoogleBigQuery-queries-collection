
--1.	Truy vấn tất cả dữ liệu có trong table.
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv`;


--2.	Cho biết thông tin về name, nationality, date_of_birth, height, weight, total, sport của các VDV (VDV) nữ.
SELECT name, nationality, date_of_birth, height, weight, total, sport FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex = 'female';


--3.	Cho biết name, date_of_birth của tất cả VDV, nhưng sắp xếp kết quả theo date_of_birth và những hàng có giá trị NULL sẽ được đưa lên đầu của kết quả truy vấn.
SELECT name, date_of_birth FROM `bigdataclass-436106.vdv.thongtinvdv` ORDER BY date_of_birth ASC;


--4.	Tương tự câu trên (vẫn sắp xếp kết quả theo date_of_birth) nhưng cho những hàng có giá trị NULL chuyển xuống cuối của kết quả truy vấn.
SELECT name, date_of_birth FROM `bigdataclass-436106.vdv.thongtinvdv` ORDER BY date_of_birth DESC;


--5.	Xem danh sách các VDV nữ không có huy chương (total=0).
SELECT name, total FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE total = 0 AND sex = 'female';


--6.	Cho biết tên những nước mà thông tin date_of_birth của VDV bị  thiếu (null).
SELECT nationality, name, date_of_birth FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE date_of_birth is NULL;


--7.	Cho biết tên những nước có vận động viên nữ tham gia môn rugby sevens (sport= rugby sevens).
SELECT nationality, name, sport FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sport='rugby sevens' AND sex = 'female';


--8.	Cho biết tên những VDV chỉ đạt huy chương vàng nhưng không đạt huy chương bạc và đồng.
SELECT name, gold, total FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE bronze = 0 AND silver = 0 AND gold > 0


--9.	Cho biết tên những VDV nữ chỉ đạt huy chương vàng gold.
SELECT name, gold, total FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE bronze = 0 AND silver = 0 AND gold > 0 AND sex = 'female'


--10.	Cho biết name, nationality, sex, date_of_birth của những VDV nữ có huy chương vàng môn cycling khi có tuổi chưa đến 23. Nhắc lại dữ liệu trong table này thu thập về thành tích của VDV trong năm 2016.
SELECT name, nationality, sex, date_of_birth FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sport = 'cycling' AND gold > 0 AND sex = 'female' AND (2016 - EXTRACT(YEAR from date_of_birth)) < 23


--2.2.2.	SELECT * EXCEPT
--11.	Cho biết nội dung của tất cả các field, ngoại trừ field total của những VDV có bất kỳ huy chương nào khi đã trên 50 tuổi.
SELECT * EXCEPT(total) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE 2016 - EXTRACT(YEAR from date_of_birth) > 50


--12.	Cho biết nội dung của tất cả các field, ngoại trừ 2 field height và weight của những VDV người Marocco (MAR) bị thiếu thông tin về ngày sinh (date_of_birth=null).
SELECT * EXCEPT (height, weight) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE nationality = 'MAR' AND date_of_birth is NULL


--2.2.3.	SELECT * REPLACE
--13.	Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Yêu cầu cho biết các thông tin trong table, trong đó thay giá trị cột total thành tổng số tiền thưởng mà VDV đó được nhận và chỉ tính cho những người có huy chương (total>0). 

WITH BountyCalc AS(
  SELECT gold as goldB
  UNION ALL
  SELECT silver as silverB
  UNION ALL
  SELECT bronze as bronzeB
)

SELECT * FROM BountyCalc
SELECT name, total FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE total > 0 

--2.2.4.	Toán tử [NOT] LIKE - hàm Starts_with
--Mỗi câu sau đây yêu cầu HV thực hiện bằng cả 2 cách: LIKE và Starts_With (nếu được)
--14.	Cho biết tên VDV và tên nước của VDV đó sao cho 3 ký tự đầu của tên VDV là ‘Car’. Yêu cầu thực hiện bằng 2 cách: sử dụng toán tử LIKE và hàm Starts_with.
--C1
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE STARTS_WITH(name,'Car')

--C2
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE name LIKE 'Car%'


--15.	Cho biết tên VDV và tên nước của VDV đó sao cho ký tự thứ ba của tên VDV là ký tự ‘o’ và ký tự thứ năm là ‘a’.
--C1 
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE STARTS_WITH (SUBSTR(name,3,1),'a') AND STARTS_WITH(SUBSTR(name,5,1),'o')

--C2
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE name LIKE '__a_o%'


--16.	Tìm tên (name) những VDV có ký tự thứ 3 không phải là chữ ‘d’ và ký tự thứ 5 không phải là khoảng trắng.
--C1
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE NOT STARTS_WITH (SUBSTR(name,3,1),'d') AND NOT STARTS_WITH(SUBSTR(name,5,1),' ')

--C2
SELECT name, nationality FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE name NOT LIKE '__d__%'

--17.	Tìm tên (name) những VDV có ký tự đầu tiên là chữ ‘S’ và ký tự thứ 5 không phải là 1 trong 2 ký tự ‘m’ hoặc ‘n’.
-- C1: No between 
SELECT name FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE STARTS_WITH(SUBSTR(name,1,1),'S') AND NOT STARTS_WITH(SUBSTR(name,5,1),'m') AND NOT STARTS_WITH(SUBSTR(name,5,1),'n')

--C2: YES BETWEEN (advanced)
SELECT name FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE STARTS_WITH(SUBSTR(name,1,1),'S') AND (SUBSTR(name,5,1) NOT BETWEEN 'm' AND 'n')


--2.2.5.	Toán tử [NOT] BETWEEN
--Thực hiện các yêu cầu này bằng 2 cách: có và không có sử dụng toán tử BETWEEN
--18.	 Cho biết những VDV nữ nào có chiều cao từ 1,6m đến 1.8m, trọng lượng nhẹ hơn 60 kg nhưng vẫn đạt huy chương vàng. 
--C1:
SELECT name, weight, height FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE height BETWEEN 1.6 AND 1.8 AND weight < 60 AND gold > 0


--C2:
SELECT name, weight, height FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE height > 1.6 AND  height < 1.8 AND weight < 60 AND gold > 0


--19.	Cho biết tên những VDV đạt huy chương vàng khi tuổi không nằm trong khoảng từ 18 đến 53.
--C1:
SELECT name, date_of_birth, gold FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE 2016 - EXTRACT(YEAR from date_of_birth) NOT BETWEEN 18 AND 53


--C2:
SELECT name, date_of_birth, gold FROM `bigdataclass-436106.vdv.thongtinvdv`WHERE 2016 - EXTRACT(YEAR from date_of_birth) < 18 AND 2016 - EXTRACT(YEAR from date_of_birth) > 53


--2.2.6.	LIMIT
--20.	Truy vấn 1000 hàng đầu trong dữ liệu.
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv` LIMIT 1003


--21.	Cho biết 10 VDV có nhiều huy chương nhất (tìm dựa trên field total)
SELECT gold, name, sport FROM `bigdataclass-436106.vdv.thongtinvdv` ORDER BY gold DESC LIMIT 10


--22.	Cho biết 10 VDV nữ có nhiều huy chương vàng nhất.
SELECT gold, name, sport FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex = 'female' ORDER BY gold DESC LIMIT 10


--23.	Cho biết tên VDV nữ trẻ tuổi nhất của Việt Nam có đạt huy chương (không phân biệt gold, silver hay bronze).
SELECT name, sport, date_of_birth, total FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex = 'female' AND nationality = 'VIE'  ORDER BY 2016 - EXTRACT(YEAR from date_of_birth) ASC LIMIT 1


--24.	Trong số những vận động viên nữ, cho biết tên VDV của nước Mỹ có số huy chương vàng nhiều thứ 3 của nước Mỹ.
SELECT name, sport, gold FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex = 'female' AND nationality = 'USA' ORDER BY gold DESC LIMIT 1 OFFSET 2


--2.2.7.	Sub query
--	Lần lượt thực hiện các truy vấn sau (từ câu 25 đến câu 27) bằng 2 cách:
--•	Sử dụng LIMIT.
--•	Sử dụng sub query.
--Dựa trên kết quả truy vấn để thấy được ưu điểm của mỗi cách viết truy vấn.

--25.	Cho biết tên 1 VDV nữ đạt huy chương vàng nhưng “nhẹ cân” nhất trong những VDV nữ đạt huy chương vàng.
-- C1: Limit
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex = 'female'AND gold > 0 ORDER BY weight ASC LIMIT 1

-- C2: Sub-query
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE
weight = (SELECT MIN(weight) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE gold > 0 ) LIMIT 1


--26.	Cho biết tên của nữ VDV có cân nặng nhẹ nhất trong tất cả các VDV người Argentina (nationality=ARG) từng đạt huy chương vàng.
-- C1: Limit
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex='female' AND gold > 0 AND nationality = 'ARG' ORDER BY weight ASC LIMIT 1

-- C2: Sub-query
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv`
WHERE weight = (SELECT MIN(weight) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE gold > 0 and nationality = 'ARG') LIMIT 1

--27.	Cho biết tên VĐV, quốc tịch của VĐV nam có trọng lượng nhẹ nhất. 
--C1 : Limit
SELECT * FROM `bigdataclass-436106.vdv.thongtinvdv` where sex= 'male' order by weight ASC limit 1

--C2: Subquery
SELECT name, weight from `bigdataclass-436106.vdv.thongtinvdv`
WHERE weight = (SELECT MIN(weight) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE sex='male') LIMIT 1

--2.2.8.	Aggregate functions
--28.	Cho biết số hàng dữ liệu (records) có trong table.
SELECT COUNT(*) FROM `bigdataclass-436106.vdv.thongtinvdv`

--29.	Có bao nhiêu nước có VDV đạt huy chương đồng (bronze>0 và không quan tâm đến môn mà VDV thi đấu).
SELECT COUNT(DISTINCT nationality) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE bronze > 0


--	Từ đây trở đi, trong mỗi câu của phần Agregate functions, yêu cầu học viên thực hiện bằng 2 cách:
--o	Sử dụng mệnh đề GROUP BY.
--o	Sử dụng mệnh đề OVER (nếu có thể vận dụng được).

--30.	Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Cho biết tổng số tiền thưởng mà mỗi nước sẽ nhận được. 
-- c1: GROUP BY
SELECT nationality, SUM(bronze * 3000 + silver * 5000 + gold * 10000) as total_prize FROM `bigdataclass-436106.vdv.thongtinvdv`  GROUP BY nationality


--c2: OVER
SELECT distinct nationality, SUM(bronze*3000 + silver*5000 + gold*10000) OVER (PARTITION BY  nationality) 
FROM `bigdataclass-436106.vdv.thongtinvdv`  



--31.	Thống kê số lượng VDV của mỗi nước tham gia gồm: mã quốc gia, số lượng nam, số lượng nữ, tổng số VDV. Kết quả được sắp xếp giảm dần theo số lượng VDV nữ, nếu số lượng này bằng nhau sẽ sắp tăng dần theo số lượng VDV nam.
--C1: GROUP BY
SELECT nationality,COUNTif( sex='male') as male_count, COUNTIF(sex='female') as female_count, COUNT (*) as total_athelete 
from `bigdataclass-436106.vdv.thongtinvdv`group by nationality  ORDER BY female_count DESC 

--C2:
SELECT * FROM (SELECT DISTINCT nationality, COUNTIF(sex='female') OVER (PARTITION BY nationality), COUNTIF(sex='male') OVER (PARTITION BY nationality )  
from `bigdataclass-436106.vdv.thongtinvdv`)


--32.	Cho biết tên mỗi nước, tuổi nhỏ nhất, tuổi lớn nhất của những VDV nước đó?
SELECT nationality, MIN(2016 - EXTRACT(YEAR from date_of_birth)) as youngest_age, MAX(2016-EXTRACT(YEAR from date_of_birth)) as oldest_age 
FROM `bigdataclass-436106.vdv.thongtinvdv` group by nationality

SELECT DISTINCT nationality, MIN(2016 - EXTRACT(YEAR from date_of_birth)) OVER (PARTITION BY nationality), 
MAX(2016-EXTRACT(YEAR from date_of_birth))OVER (PARTITION BY nationality)
FROM `bigdataclass-436106.vdv.thongtinvdv` 



--33.	Cho biết tên nước, số lượng nam, nữ của mỗi nước theo minh họa sau:
SELECT nationality, sex,count(*)
FROM `bigdataclass-436106.vdv.thongtinvdv` group by nationality,sex ORDER BY nationality DESC

SELECT DISTINCT nationality, sex, count(*) OVER (PARTITION BY nationality, sex)
FROM `bigdataclass-436106.vdv.thongtinvdv`
ORDER BY nationality DESC



--34.	Cho biết tên tất cả các nước và số lượng VDV nữ đạt được huy chương vàng. Các nước không có nữ đạt huy chương vàng vẫn hiện tên nước đó, nhưng lúc này số lượng sẽ là 0
SELECT nationality, countif(gold>0) as gold_by_female FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE  sex='female' group by nationality

SELECT distinct nationality, COUNTIF (gold>0) OVER (PARTITION BY nationality) FROM `bigdataclass-436106.vdv.thongtinvdv`


--35.	Cho biết tên tất cả các nước và số lượng VDV nữ đạt được huy chương vàng. Chỉ hiện tên các nước có nữ đạt huy chương vàng
SELECT nationality, (COUNT(*)) as gold_by_female FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE  sex='female' AND gold > 0 group by nationality

SELECT distinct nationality, COUNT(*) OVER (PARTITION BY nationality) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE  sex='female' AND gold > 0 


--36.	Cho biết nationality, số lượng từng loại huy chương (gold, silver và bronze) của những VDV nữ (sex = ‘female’) trong môn judo (sport=judo). Sắp xếp giảm dần theo từng số lượng huy chương. 
--Nếu số lương huy chương gold bằng nhau thì sắp xếp dựa trên silver, tương tự nếu gold và silver bằng nhau sẽ xét tiếp trên bronze.
SELECT nationality, sum(gold), sum(silver), sum(bronze)
FROM `bigdataclass-436106.vdv.thongtinvdv`
WHERE  sport = 'judo' 
group by nationality 


--	Lần lượt thực hiện các truy vấn sau sau (từ câu 37 đến câu 38) bằng 3 cách:
--•	ANY_VALUE
--•	MAX_BY/MIN_BY

--37.	Cho biết tên 3 nước có VĐV “nặng ký” nhất (trọng lượng lớn nhất).
SELECT nationality, MAX(weight)
FROM `bigdataclass-436106.vdv.thongtinvdv`
group by nationality, weight
ORDER BY weight DESC
LIMIT 3


--•	Không sử dụng các hàm ANY_VALUE và MAX_BY/MIN_BY.
--38.	Cho biết tên môn thể thao nào mà nước Mỹ có nhiều huy chương bạc nhất.
SELECT distinct sport, sum(silver) FROM `bigdataclass-436106.vdv.thongtinvdv` WHERE nationality = 'USA'
GROUP BY sport,silver
ORDER BY silver DESC
limit 100

select distinct sport from`bigdataclass-436106.vdv.thongtinvdv` WHERE nationality = 'USA'
SELECT SUM(bronze),SUM(silver),SUM(gold), nationality
FROM `bigdataclass-436106.vdv.thongtinvdv`
GROUP BY nationality

--39.	Cho biết tên nước có VĐV “lớn tuổi” và “nhỏ tuổi” nhất. Kết quả truy vấn:
SELECT MAX_BY(nationality, 2016-EXTRACT(YEAR FROM date_of_birth)) as nationality_oldest, 
MIN_BY(nationality, 2016-EXTRACT(YEAR FROM date_of_birth)) as nationality_youngest
FROM `bigdataclass-436106.vdv.thongtinvdv`


--Học viên tự đưa ra nhận xét về cách viết truy vấn cùng kết quả của truy vấn.
--40.	Lần lượt thực hiện các thống kê sau:
--a.-	Thống kê tên các quốc gia, tuổi giảm dần của các VDV.
SELECT nationality, (2016-EXTRACT(YEAR FROM date_of_birth)) as age
FROM `bigdataclass-436106.vdv.thongtinvdv` 
ORDER BY age DESC


--b.-	Dựa vào câu truy vấn a, hiệu chỉnh lại để lấy ra 5 nước (không trùng nhau) có VDV lớn tuổi nhất.
SELECT nationality, MAX(2016-EXTRACT(YEAR FROM date_of_birth)) as oldest_age
FROM `vdv.thongtinvdv`
GROUP BY nationality
ORDER BY oldest_age DESC
LIMIT 5


SELECT distinct nationality,MAX(2016 - EXTRACT(YEAR FROM date_of_birth)) OVER (PARTITION BY nationality) as age
FROM `vdv.thongtinvdv`
ORDER BY age DESC
LIMIT 5


--c.-	Kết quả thực hiện tương tự như kết quả của câu b, nhưng yêu cầu thực hiện bằng cách sử dụng hàm ARRAY_AGG.

SELECT ARRAY_AGG(nationality), ARRAY_AGG(age)
FROM(
  select nationality, age
  FROM(
    select distinct nationality,2016 - EXTRACT(YEAR FROM date_of_birth) as age
    FROM `vdv.thongtinvdv`
  )
  GROUP BY nationality, age
  ORDER BY age DESC 
  LIMIT 5
)


--d.-	Kết quả thực hiện tương tự như kết quả của câu b và c, nhưng yêu cầu thực hiện bằng cách sử dụng hàm ARRAY.
SELECT ARRAY(
  select nationality
  from(
    SELECT distinct nationality,( 2016-EXTRACT(YEAR FROM date_of_birth) )as age
    FROM `vdv.thongtinvdv`)
    GROUP BY nationality, age
    ORDER BY age DESC limit 5    
)
,
ARRAY(
  select age
  from(
    SELECT distinct nationality, (2016-EXTRACT(YEAR FROM date_of_birth) )as age
    FROM `vdv.thongtinvdv`)
    GROUP BY nationality, age
    ORDER BY age DESC limit 5  
)


--41.	Tạo thống kê số lượng VDV theo từng chiều cao (height)

SELECT ARRAY_AGG(height) as height, ARRAY_AGG(athlete_count) as athlete_count
FROM(
  SELECT distinct height, athlete_count
  FROM(
    SELECT ROUND(height,1) as height, COUNT(*) OVER (PARTITION BY CAST(ROUND(height,1) AS STRING) ) AS athlete_count
    FROM `vdv.thongtinvdv`
  )
  ORDER BY height
)

--42.	Chỉ số BMI (Body Mass Index - chỉ số khối cơ thể) giúp mọi người tự kiểm tra sức khỏe dựa trên công thức: 
--BMI: cân nặng (kg) / (chiều cao (m) * chiều cao (m))
--Tra chỉ số BMI vừa có trong bảng sau người ta biết được mức độ béo phì.
--Yêu cầu: xác định số lượng VDV của từng mức đánh giá, nhưng chỉ tính cho những VDV môn cử tạ (sport= weightlifting). Kết quả truy vấn có dạng

SELECT ARRAY_AGG(udw) as underweight, ARRAY_AGG(nrm) as normal, ARRAY_AGG(ovw) as overweight, ARRAY_AGG(obs) as obese
FROM
(
  SELECT obs, ovw, nrm, udw
  FROM (
    SELECT COUNTIF( weight/(ROUND(height,2) * ROUND(height,2))>25) as obs,
     COUNTIF(weight/(ROUND(height,2) * ROUND(height,2)) > 23 AND weight/(ROUND(height,2) * ROUND(height,2))<= 24.99 ) as ovw,
      COUNTIF(weight/(ROUND(height,2) * ROUND(height,2)) > 18.5 AND weight/(ROUND(height,2) * ROUND(height,2)) <= 22.99) as nrm,
       COUNTIF(weight/(ROUND(height,2) * ROUND(height,2)  )<18.5) as udw
    FROM `vdv.thongtinvdv`
    WHERE sport = 'weightlifting'
  )  
)

SELECT COUNT(*) FROM `vdv.thongtinvdv` where sport = 'weightlifting'

--2.2.9.	Conditional expressions
--Yêu cầu: sử dụng tất cả các biểu thức điều kiện (CASE, IF, …) mà học viên biết để xử lý cho các câu sau đây:
--43.	Cho biết VDV với name= Kelsi Worrell có đạt huy chương vàng môn aquatics (sport= aquatics) hay không? Trả lời ‘Có’ hoặc ‘không’.

SELECT IF(COUNT(*)>0,"YES","NO")
FROM `vdv.thongtinvdv` WHERE name ="Kelsi Worrell" AND gold > 0 AND sport="aquatics"

--44.	Cho biết VĐV ‘Hoang Xuan Vinh’ của Việt Nam có đạt được huy hương vàng môn bắn súng (shooting) hay không? Trả lời ‘Có’ hoặc ‘không’.

SELECT IF(COUNT(*)>0,"YES","NO")
FROM `vdv.thongtinvdv` WHERE name ="Xuan Vinh Hoang" AND gold > 0 AND sport="shooting"


--45.	Cho biết tỷ lệ VDV nữ có giải / số lượng VDV nam có giải của Việt Nam (VIE) có lớn hơn 40% hay không? Trả lời ‘Có’ hoặc ‘không’. 
--Lưu ý: cần kiểm tra trước xem số lượng VDV nam có giải của Việt Nam có >0 hay không trước khi tính toán tỷ lệ, vì nếu số lượng này =0 sẽ dẫn đến phép chia có mẫu số =0 sẽ gây lỗi.
--	Lần lượt thực hiện các truy vấn sau sau (từ câu 46 đến câu 48) bằng 3 cách
--•	SUM
--•	COUNT
--•	COUNTIF

SELECT IF(  
  COUNTIF(total>0 AND sex='male')>0,
    IF(COUNTIF(total>0 AND sex='male')/COUNTIF(sex='male')*100 > 40,
    "YES","NO"),
  "No record of any male got a medal."
  )
FROM `vdv.thongtinvdv` WHERE nationality = "VIE" 

SELECT COUNTIF(total>0)/COUNT(*)*100
FROM `vdv.thongtinvdv` WHERE nationality = "VIE" 

SELECT COUNT(*)
FROM `vdv.thongtinvdv` WHERE nationality = "VIE" 

SELECT COUNTIF(total>0)
FROM `vdv.thongtinvdv` WHERE nationality = "VIE" 


--46.	Cho biết tên nước, số lượng nam, số lượng nữ theo hình minh họa sau:
--nationality	soluongnu	soluongnam
--ZIM	26	9
--ZAM	2	5
--YEM	1	2
--VIN	2	2
--VIE	13	10
--…	…	…
SELECT distinct nationality, countif(sex='male') as male_ath, countif(sex='female') as female_ath
FROM `vdv.thongtinvdv`
GROUP BY nationality
ORDER BY nationality DESC


--47.	Cho biết số lượng VDV tham gia theo từng nhóm tuổi: dưới 14, từ 15-16, từ 17-18, từ 19-22 và trên 22 của mỗi nước. Thông tin gồm nationality, LessThan14, From15To16, From17To18, From19To22, OlderThan22. Gợi ý: dựa trên năm sinh và năm tham gia (2016).

CREATE TEMP FUNCTION getAge (x DATE)
RETURNS INT64
AS (
  2016 - EXTRACT(YEAR FROM x)
);

SELECT nationality, COUNTIF(getAge(date_of_birth)<14) as Under14, 
COUNTIF(getAge(date_of_birth) BETWEEN 15 AND 16 ) as From15To16,
COUNTIF(getAge(date_of_birth) BETWEEN 17 AND 18 ) as From17to18,  
COUNTIF(getAge(date_of_birth) BETWEEN 19 AND 22 ) as From19To22,
COUNTIF(getAge(date_of_birth) >22 ) as OlderThan22
FROM `vdv.thongtinvdv` 
GROUP BY nationality

--48.	Thực hiện thống kê gồm tên nước, số lượng VDV nữ đạt huy chương vàng của nước đó, tương tự cho huy chương bạc và đồng. Kết quả sắp xếp giảm dần theo số lượng VDV đạt huy chương vàng. 
--nationality	FemaleWithGold	FemaleWithSilver	FemaleWithBronze
--USA	74	26	35
--RUS	38	17	22
--GER	29	14	23
--CHN	28	21	22
--GBR	27	18	15

SELECT distinct nationality, countif(bronze>0) as bronze_winner,
countif(silver>0) as silver_winner,countif( gold>0) as gold_winner
FROM `vdv.thongtinvdv`
WHERE sex='female'
GROUP BY nationality
ORDER BY gold_winner DESC



--2.2.10.	Subquery
--49.	Có bao nhiêu nước trong danh sách. Yêu cầu viết bằng 2 cách: có và không có sử dụng subquery
SELECT num_of_countries 
FROM
(
  SELECT COUNT(distinct nationality) as num_of_countries
  FROM `vdv.thongtinvdv`
)

SELECT COUNT(distinct nationality) AS num_of_countries
FROM `vdv.thongtinvdv`


--50.	Cho biết tên và số lượng huy chương vàng của những VDV mà những VDV này có số huy chương vàng nhiều hơn VDV có tên là ‘Usain Bolt’.
--meth 1: with subquery
SELECT name, gold
FROM `vdv.thongtinvdv`
WHERE gold > 
(
  SELECT gold FROM `vdv.thongtinvdv` where name = "Usain Bolt"
)

--meth 1: anti-subquery
SELECT gold
FROM `vdv.thongtinvdv`
WHERE name = 'Usain Bolt'


SELECT name, gold
FROM `vdv.thongtinvdv`
HAVING gold > 

--51.	Cho biết tên và chiều cao của 4 VDV có chiều cao là cao nhất trong tất cả các VDV. Nếu có nhiều VDV cùng có chiều cao như VDV thứ 4 thì lấy tất cả những người này (khi đó danh sách kết quả có thể có nhiều hơn 4 VDV).

SELECT name, height 
FROM
(
  SELECT name, height FROM `vdv.thongtinvdv`
  ORDER BY height DESC
  LIMIT 4

)


--52.	Cho biết tên nước, số lượng huy chương đồng mà nước đó đạt được giống như số lượng huy chương đồng mà nước Hàn Quốc (KOR) đã đạt. Yêu cầu kết quả không có tên nước Hàn Quốc
--2.2.11.	Lớn/nhỏ nhất
--	Lần lượt thực hiện các truy vấn trong phần này bằng 2 cách:
--•	Sử dụng LIMIT.
--•	Sử dụng sub query.