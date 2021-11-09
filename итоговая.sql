---� ����� ������� ������ ������ ���������?
select city 
from airports
group by city
having count(airport_name) > 1
---��� ���������� ����� ������� ���������� ���������� 
---���������� ���������� � ������ ������ �������� "count". 
---����� ������ ����������� �� ������, ��� �� ���������� ���������� �������.
---�������� "having" ����������� ���� � ������������ �������� �� ������������ �������.


---� ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?
select f.departure_airport
from flights f 
join aircrafts ac using(aircraft_code)
where "range" in (
	select max("range")
	from aircrafts ac
	)
group by f.departure_airport
---����� �������� �� ���� ������ ����� ��������� �� �������, ������� ����� ����� �������. �������� "range" ����� ����� �� ������� aircrafts.
---����� � ������ ������� ��� ����� ������� ������ ���������, �� ��� ���� ������ ����� �������� ������� flights.(��� ��� �������)
---��� ����� ��������� �������� "join" ��� ������ aircrafts � flights. 
---����� ���������� where ������ ������� ��� ����������� � ���������� ����������, 
---��� ���������� ������� ������ ��� �������, ������� ����� ������������ ��������� ��������.


---������� 10 ������ � ������������ �������� �������� ������
select flight_no, max(actual_departure - scheduled_departure) max_d
from flights 
group by flight_no
order by max_d desc
limit 10
---��� ������� ���� ������ ����� ��������� ����� �������� � ���������� ������������ �������� ����� ���� �������� �������.
---�������� = ����������� ����� ������ - ����� �� ����������.
---������������� ������������� ���������� � ������� order by, �� �������� � ��������.
---limit ������ ��� ������ 10 ����������� �������� �� ���� �������.


--���� �� �����, �� ������� �� ���� �������� ���������� ������?
select count(t.book_ref), count(bp.boarding_no)
from boarding_passes bp
right join tickets t using(ticket_no)
where bp.boarding_no is null
---��, ����� ����� ����. ��������� ������� boarding_passes � tickets. ���������� right join ��� ���������� �������. 
---� ������� �����������, ��� ��� ���������� ���������� ������ �� ����������� ��������� null.


---������� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
---�������� ������� � ������������� ������ - ��������� ���������� ���������� ����������
---���������� �� ������� ��������� �� ������ ����.
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
---� ������ ��� ����� ����� ��������� ���������� � ������� �� ������� 1)���������� ������� ���� ��� ������� ��������, 
---2)���������� ���� � ��������. ���������� ������� ������� ��� ���������� ���������� ���������� ���������� ����������. 
---��� ��� ��� ���������� ������ ���������� ���������, �� ���������� ������ ���������� �� ������� ������, � ������ ������ 'Arrived'.


---������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������. 
select a.model, round((fm.cnt/fm.all_cnt)*100, 1) pr
from aircrafts a
join ( 
	select count(flight_no) cnt, aircraft_code, sum(count(flight_no)) over () all_cnt
	from flights f
	group by f.aircraft_code
) fm on a.aircraft_code = fm.aircraft_code
---�� �������� ����������� ������� ���� ���������� �����������. 
---� ���������� ������� ����� ���������� �������, ������������ �� ������ ������ ��������.
---��������� �� ������� ������� ��� ������ ������ � ���������� round ��������� �� ������ ����� ����� �������.


---���� �� ������, � ������� ����� ��������� ������ - ������� �������, ��� ������-������� �
---������ ��������?
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
---������� CTE � ������� ��������� ��������� ��������� ������, �������� ��� ��� ���������, ����� � ���������.
---������ ������ � CTE � ���������� ��� � ������������ ������������� ��� ������ � ��������� ��� ���������. 
---��� ����, ��� �� ������ ���� �������� ������ �������, ����� ����������� ���� �� ������� ������ �������� � ������������ �� �������.
---������������� ���������� �� ����������, ������� �������� ��� ������� ������.