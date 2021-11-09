select r.rental_id, r.rental_date, r.customer_id,
	row_number() over (partition by r.customer_id order by r.rental_date)
from rental r


select c.customer_id, f.special_features, count(f.film_id) over (partition by c.customer_id)
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where f.special_features::text ilike '%Behind the Scenes%' 


create materialized view MW as 
	(select c.customer_id, f.special_features, count(f.film_id) over (partition by c.customer_id)
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where f.special_features::text ilike '%Behind the Scenes%'
)
with NO data

refresh materialized view MW

-------три варианта условия для поиска Behind the Scenes-----

select f.film_id, f.special_features
from film f
where special_features @> array['Behind the Scenes']


select c.customer_id, f.special_features, count(f.film_id) over (partition by c.customer_id)
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where f.special_features[1] = 'Behind the Scenes' or f.special_features[1] = 'Behind the Scenes' or
	f.special_features[2] = 'Behind the Scenes' or f.special_features[2] = 'Behind the Scenes' 

select c.customer_id, f.special_features, count(f.film_id)
from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
where f.special_features::text ilike '%Behind the Scenes%'
group by c.customer_id, f.special_features
