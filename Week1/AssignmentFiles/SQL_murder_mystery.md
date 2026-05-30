
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

## find additional information about these two found in other tables 
