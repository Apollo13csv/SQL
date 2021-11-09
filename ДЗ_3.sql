select c.store_id, count(c.customer_id)
from customer c
join store s on c.store_id = s.store_id
group by c.store_id
having count(c.customer_id) > 300

select c.customer_id, c.first_name, c.last_name, ct.city 
from address a
join customer c on a.address_id = c.address_id
join city ct on a.city_id  = ct.city_id 

--дополнительное задание

select sf.first_name, sf.last_name, city
from staff sf
join store s using(store_id)
join address a on a.address_id = s.address_id
join city c using(city_id)
join customer c2 using(store_id)
group by sf.first_name, sf.last_name, city
having count(c2.customer_id) > 300

select count(fa.actor_id)
from film_actor fa 
join film f using(film_id)
where f.rental_rate = 2.99
group by f.rental_rate
