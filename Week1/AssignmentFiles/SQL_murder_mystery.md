
## Search Crime Scene Report for Match to City, Date, and Type

select * from crime_scene_report
where city = 'SQL City' and date = 20180115 and type = 'murder';

### Descripition Column 

- Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

## Locate The Witnesses in Person Table: 

### Who lives in the last house on nortwestern drive? 

select * from person
where address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1;

id	    name	        license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	    4919	        Northwestern Dr	    111564949

### Get info on this "Annabel" the lives on franklin ave

select * from person
where address_street_name like 'franklin%' and name like '%Annabel%'; 

id	    name	        license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	    103	            Franklin Ave	    318771143

## What did they see? find additional information about these two and their interview transcripts (interview table)

### witness 1: 

select *
from person p
left join interview i
on i.person_id = p.id
where p.address_street_name = 'Franklin Ave' and p.name = 'Annabel Miller'

interview.transcript = 
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


### witness 2: 

select * 
from person p
left join interview i
on i.person_id = p.id
where p.address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1;

interview.transcript =  
I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".