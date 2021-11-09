---В каких городах больше одного аэропорта?
select city 
from airports
group by city
having count(airport_name) > 1
---Для выполнения этого задания необходимо подсчитать 
---количество аэропортов в каждом городе командой "count". 
---Далее задать группировку по городу, что бы обьединить результаты запроса.
---Оператор "having" отфильтрует поле с агрегирующей функцией по необходимому условию.


---В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
select f.departure_airport
from flights f 
join aircrafts ac using(aircraft_code)
where "range" in (
	select max("range")
	from aircrafts ac
	)
group by f.departure_airport
---Чтобы ответить на этот вопрос нужно соединить те таблицы, которые имеют общие столбцы. Значения "range" можно взять из таблицы aircrafts.
---Также в задаче сказано что нужно вывести именно аэропорты, то для этой задачи лучше подойдет таблица flights.(как мне кажется)
---Для этого применяем оператор "join" для таблиц aircrafts и flights. 
---Далее оператором where задаем условие для фильтрациии в подзапросе обозначаем, 
---что необходимо вывести только тот самолет, который имеет максимальную дальность перелета.


---Вывести 10 рейсов с максимальным временем задержки вылета
select flight_no, max(actual_departure - scheduled_departure) max_d
from flights 
group by flight_no
order by max_d desc
limit 10
---Для решения этой задачи нужно вычислить время задержки и определить максимальное значение среди всех значений столбца.
---задержка = фактическое время вылета - время по расписанию.
---Установливаем предсказуемую сортировку с помощью order by, от большего к меньшему.
---limit вернет нам только 10 необхадимых значений из всей выборки.


--Были ли брони, по которым не были получены посадочные талоны?
select count(t.book_ref), count(bp.boarding_no)
from boarding_passes bp
right join tickets t using(ticket_no)
where bp.boarding_no is null
---Да, такие брони были. Соединяем таблицы boarding_passes и tickets. Используем right join для обогощения таблицы. 
---В условии прописываем, что нас интересуют посадочные талоны со специальным значением null.


---Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
---Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных
---пассажиров из каждого аэропорта на каждый день.
select flight_no, actual_departure, cnt_boarding_no, cnt_seat_no - cnt_boarding_no sm, 100*(cnt_seat_no - cnt_boarding_no)/cnt_seat_no free_prcnt,
  sum(cnt_boarding_no) over (partition by f.departure_airport, date_trunc('day', f.actual_departure) order by f.actual_departure) departed_today
from flights f
join (
  select count(bp.boarding_no) cnt_boarding_no, bp.flight_id
  from boarding_passes bp
  group by bp.flight_id
) bp on f.flight_id = bp.flight_id
join (
  select count(s.seat_no) cnt_seat_no, s.aircraft_code
  from seats s
  group by s.aircraft_code
) s on f.aircraft_code = s.aircraft_code
where f.status = 'Departed' or f.status = 'Arrived'
order by f.actual_departure
---В начале нам нужно найти составить подзапросы в которых мы получим 1)количество занятых мест для каждого перелета, 
---2)количество мест в самолете. Используем оконную функцию для суммарного накопления количества вывезенных пассажиров. 
---Так как нас интересуют только вывезенные пассажиры, то необхадимо задать фильтрацию по статусу полета, в данном случае 'Arrived'.


---Найдите процентное соотношение перелетов по типам самолетов от общего количества. 
select a.model, round((fm.cnt/fm.all_cnt)*100, 1) pr
from aircrafts a
join ( 
	select count(flight_no) cnt, aircraft_code, sum(count(flight_no)) over () all_cnt
	from flights f
	group by f.aircraft_code
) fm on a.aircraft_code = fm.aircraft_code
---По принципу предыдущего запроса ищем процентное соотношение. 
---В подзапросе счиатем общее количество полетов, приходящихся на каждую модеть самолета.
---Вычисляем по формуле процент для каждой модели и оператором round округляем до одного знака после запятой.


---Были ли города, в которые можно добраться бизнес - классом дешевле, чем эконом-классом в
---рамках перелета?
with cte as (
    select a.airport_name, tf.flight_id, tf.fare_conditions, tf.amount
    from ticket_flights tf   
    join flights f using(flight_id)
    join airports a on f.arrival_airport = a.airport_code
)
select airport_name
from (
	select airport_name, min(amount) bus_min 
	from cte 
	where fare_conditions = 'Business' 
	group by airport_name
) bm
join (
	select airport_name, max(amount) eco_max
	from cte 
	where fare_conditions = 'Economy' 
	group by airport_name
) em using(airport_name)
where bus_min < eco_max
---Создаем CTE в котором формируем временный результат зароса, выдающий нам имя аэропорта, класс и стоимость.
---Делаем запрос к CTE и соединияем его с подзапросами возвращающими нам данные о стоимости для сравнения. 
---Для того, что бы понять куда бизнесом летать дешевле, нужно минимальную цену по бизнесс классу сравнить с максимальной по эконому.
---Соответствено группируем по аэропортам, которые попадают под условия задачи.