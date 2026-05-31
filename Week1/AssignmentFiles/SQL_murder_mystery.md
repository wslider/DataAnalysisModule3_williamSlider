
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

### witness 1: Annabel Miller

select *
from person p
left join interview i
on i.person_id = p.id
where p.address_street_name = 'Franklin Ave' and p.name = 'Annabel Miller'

interview.transcript = 
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


### witness 1: Morty Schapiro

select * 
from person p
left join interview i
on i.person_id = p.id
where p.address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1;

interview.transcript =  
I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".


### witness 2: Annabel Miller

select *
from person p
left join interview i
on i.person_id = p.id
where p.address_street_name = 'Franklin Ave' and p.name = 'Annabel Miller'

interview.transcript = 
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

## search for matches using data from witness testemonies 
- gold memder
- membership id beings with 48z
- plate number includes "H42W"
- check-in date of 20180109

select * from person p 
left join 
get_fit_now_member gfm
on gfm.person_id = p.id
left join 
get_fit_now_check_in gfci
on gfci.membership_id = gfm.id
left join 
drivers_license dl
on p.license_id = dl.id
where 
	gfm.membership_status like 'gold%' 
	and gfm.id like '48Z%' 
	and gfci.check_in_date = 20180109 
	and dl.plate_number like "%H42W%";


* AI (Grok 4) rendered markdown table from output provided in the SQL lite interface

| person_id | name          | license_id | address_number | address_street_name       | ssn        | membership_id | membership_start_date | membership_status | check_in_date | check_in_time | check_out_time | age | height | eye_color | hair_color | gender | plate_number | car_make   | car_model   |
|-----------|---------------|------------|----------------|---------------------------|------------|---------------|-----------------------|-------------------|---------------|---------------|----------------|-----|--------|-----------|------------|--------|--------------|------------|-------------|
| 67318     | Jeremy Bowers | 423327     | 530            | Washington Pl, Apt 3A     | 871539279  | 48Z55         | 20160101              | gold              | 20180109      | 1530          | 1700           | 30  | 70     | brown     | brown      | male   | 0H42W2       | Chevrolet  | Spark LS    |


## Confirmed - Jeremy Bowers is the murderer 

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        SELECT value FROM solution;

Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.

## Check interview statement 

select * from person p 
left join 
interview i
on p.id = i.person_id
where 
	p.name = 'Jeremy Bowers'; 


Transcript:
I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

## Use clues in transcript to find out who hired him

select * from person p
left join drivers_license d
on p.license_id = d.id
left join income i
on p.ssn = i.ssn
left join facebook_event_checkin fb
on p.id = fb.person_id
  where 
  d.height between 65 and 67
  and d.hair_color = 'red'
  and d.car_make = 'Tesla'
  and d.car_model = 'Model S' 
  and d.gender = 'female'
  and fb.event_name like '%SQL Symphony Concert%';


Answer: 
  Miranda Priestly