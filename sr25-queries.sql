# sr25 queries

use sr25;

create view amino_acids as
select * from nutr_def
where nutr_no between 501 and 521;

create view friendly_table as # friendly means we display actual names of foods in English
select food_des.long_desc long_desc,
nutr_def.nutrdesc nutrdesc,
nut_data.nutr_val nutr_val,
nutr_def.units units
from food_des, nutr_def, nut_data
where nut_data.ndb_no=food_des.ndb_no
and nut_data.nutr_no=nutr_def.nutr_no;

create view amino_data as
select nut_data.ndb_no ndb_no,
nut_data.nutr_no nutr_no,
nut_data.nutr_val nutr_val
from nut_data, amino_acids
where amino_acids.nutr_no=nut_data.nutr_no
order by nut_data.ndb_no, nut_data.nutr_no;

create view amino_pct as
select nd_a.ndb_no ndb_no,
aa.nutr_no nutr_no,
nd_a.nutr_val/nd_b.nutr_val pct_of_protein
from nut_data nd_a,
nut_data nd_b,
amino_acids aa
where nd_a.ndb_no=nd_b.ndb_no
and nd_a.nutr_no=aa.nutr_no
and nd_b.nutr_no = 203; # protein

/*
+---------+----------------+
| nutr_no | nutrdesc       |
+---------+----------------+
| 501     | Tryptophan     |
| 502     | Threonine      |
| 503     | Isoleucine     |
| 504     | Leucine        |
| 505     | Lysine         |
| 506     | Methionine     |
| 507     | Cystine        |
| 508     | Phenylalanine  |
| 509     | Tyrosine       |
| 510     | Valine         |
| 511     | Arginine       |
| 512     | Histidine      |
| 513     | Alanine        |
| 514     | Aspartic acid  |
| 515     | Glutamic acid  |
| 516     | Glycine        |
| 517     | Proline        |
| 518     | Serine         |
| 521     | Hydroxyproline |
+---------+----------------+
*/



create view amino_pivot as # h/t https://en.wikibooks.org/wiki/MySQL/Pivot_table
select ndb_no,
sum(nutr_val*abs(sign(nutr_no-501))) as Tryptophan,
sum(nutr_val*abs(sign(nutr_no-502))) as Threonine,
sum(nutr_val*abs(sign(nutr_no-503))) as Isoleucine,
sum(nutr_val*abs(sign(nutr_no-504))) as Leucine,
sum(nutr_val*abs(sign(nutr_no-505))) as Lysine,
sum(nutr_val*abs(sign(nutr_no-506))) as Methionine,
sum(nutr_val*abs(sign(nutr_no-507))) as Cystine,
sum(nutr_val*abs(sign(nutr_no-508))) as Phenylalanine,
sum(nutr_val*abs(sign(nutr_no-509))) as Tyrosine,
sum(nutr_val*abs(sign(nutr_no-510))) as Valine,
sum(nutr_val*abs(sign(nutr_no-511))) as Arginine,
sum(nutr_val*abs(sign(nutr_no-512))) as Histidine,
sum(nutr_val*abs(sign(nutr_no-513))) as Alanine,
sum(nutr_val*abs(sign(nutr_no-514))) as Aspartic_acid,
sum(nutr_val*abs(sign(nutr_no-515))) as Glutamic_acid,
sum(nutr_val*abs(sign(nutr_no-516))) as Glycine,
sum(nutr_val*abs(sign(nutr_no-517))) as Proline,
sum(nutr_val*abs(sign(nutr_no-518))) as Serine,
sum(nutr_val*abs(sign(nutr_no-521))) as Hydroxyproline
from amino_data group by ndb_no;

create view friendly_amino_pivot as
select fd.long_desc long_desc,
ap.threonine,
ap.leucine,
ap.methionine,
ap.phenylalanine,
ap.valine,
ap.histidine,
ap.aspartic_acid,
ap.glycine,
ap.serine
from food_des fd, amino_pivot ap;

/*
+----------+-------------------------------------+
| fdgrp_cd | fdgrp_desc                          |
+----------+-------------------------------------+
| 0100     | Dairy and Egg Products              |
| 0200     | Spices and Herbs                    |
| 0300     | Baby Foods                          |
| 0400     | Fats and Oils                       |
| 0500     | Poultry Products                    |
| 0600     | Soups, Sauces, and Gravies          |
| 0700     | Sausages and Luncheon Meats         |
| 0800     | Breakfast Cereals                   |
| 0900     | Fruits and Fruit Juices             |
| 1000     | Pork Products                       |
| 1100     | Vegetables and Vegetable Products   |
| 1200     | Nut and Seed Products               |
| 1300     | Beef Products                       |
| 1400     | Beverages                           |
| 1500     | Finfish and Shellfish Products      |
| 1600     | Legumes and Legume Products         |
| 1700     | Lamb, Veal, and Game Products       |
| 1800     | Baked Products                      |
| 1900     | Sweets                              |
| 2000     | Cereal Grains and Pasta             |
| 2100     | Fast Foods                          |
| 2200     | Meals, Entrees, and Sidedishes      |
| 2500     | Snacks                              |
| 3500     | American Indian/Alaska Native Foods |
| 3600     | Restaurant Foods                    |
+----------+-------------------------------------+
*/

/* can't guarantee the integrity of the following two queries */

create view veg_fd_group as
select * from fd_group
where fdgrp_cd in
('0100', '0200', '0900', '1100', '1200', '1600', '1800', '2000');

create view vegan_fd_group as
select * from veg_fd_group
where fdgrp_cd not in
('0100', '1800');



