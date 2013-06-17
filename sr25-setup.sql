# Download https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR25/dnload/sr25.zip
# Unzip it
# Run the present file in the directory created by unzipping it:
# mysql -uroot -p < sr25-setup.sql

create database if not exists sr25;

grant all on sr25.* to 'your_username_here'@'localhost';

use sr25;

create table if not exists food_des ( # see p. 28 of sr25_doc.pdf
 ndb_no char(5) primary key,
 fdgrp_cd char(4),
 long_desc char(200),
 short_desc char(60),
 comname char(100),
 manufacname char(65),
 survey char(1),
 ref_desc char(135),
 refuse decimal(2),
 sciname char(65),
 n_factor decimal(4, 2),
 pro_factor decimal(4, 2),
 fat_factor decimal(4, 2),
 cho_factor decimal(4, 2),

 foreign key (fdgrp_cd)
 references fd_group(fdgrp_cd)
);

create index long_desc on food_des(long_desc);

load data local infile 'FOOD_DES.txt'
into table food_des
fields terminated by '^' # a rather bizarre choice of delimiters, no?
optionally enclosed by '~'
lines terminated by '\r\n'; # yup, the download uses MS-DOS line breaks

create table if not exists fd_group (
 fdgrp_cd char(4) primary key,
 fdgrp_desc char(60)
);

load data local infile 'FD_GROUP.txt'
into table fd_group
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists langual (
 ndb_no char(5),
 factor_code char(5),

 foreign key (ndb_no)
 references nut_data(ndb_no)
);

load data local infile 'LANGUAL.txt'
into table langual
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists nutr_def (
 nutr_no char(3) primary key,
 units char(7),
 tagname char(20),
 nutrdesc char(60),
 num_dec char(1),
 sr_order decimal(6)
);

load data local infile 'NUTR_DEF.txt'
into table nutr_def
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists src_cd (
 src_cd char(2) primary key,
 srccd_desc char(60)
);

load data local infile 'SRC_CD.txt'
into table src_cd
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists deriv_cd (
 deriv_cd char(4) primary key,
 deriv_desc char(120)
);

load data local infile 'DERIV_CD.txt'
into table deriv_cd
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';


create table if not exists weight (
 ndb_no char(5),
 seq char(2),
 amount decimal(5, 3),
 msre_desc char(84),
 gm_wgt decimal(7, 1),
 num_data_pts decimal(3),
 std_dev decimal(7, 3),

 foreign key (ndb_no)
 references food_des(ndb_no)
);

load data local infile 'WEIGHT.txt'
into table weight
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists footnote (
 ndb_no char(5),
 footnt_no char(4),
 footnt_type char(1),
 nutr_no char(3),
 footnt_text char(200),

 foreign key (ndb_no)
 references food_des(ndb_no),

 foreign key (nutr_no)
 references nutr_def(nutr_no)
);

load data local infile 'FOOTNOTE.txt'
into table footnote
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

create table if not exists datsrcln (
 ndb_no char(5),
 nutr_no char(3),
 datasrc_id char(6),
 
 foreign key (ndb_no)
 references food_des(ndb_no),

 foreign key (nutr_no)
 references nutr_def(nutr_no),

 foreign key (datasrc_id)
 references data_src(datasrc_id)
);

load data local infile 'DATSRCLN.txt'
into table datsrcln
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';


create table if not exists data_src (
 datasrc_id char(6) primary key,
 authors char(255),
 title char(255),
 year char(4),
 journal char(135),
 vol_city char(16),
 issue_state char(5),
 start_page char(5),
 end_page char(5)
);

load data local infile 'DATA_SRC.txt'
into table data_src
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';


create table if not exists nut_data (
 ndb_no char(5),
 nutr_no char(3),
 nutr_val decimal(10, 3),
 num_data_pts decimal(5, 0),
 std_error decimal(8, 3),
 src_cd char(2),
 deriv_cd char(4),
 ref_ndb_no char(5),
 add_nutr_mark char(1),
 num_studies decimal(2),
 _min decimal(10, 3),
 _max decimal(10, 3),
 df decimal(4),
 low_eb decimal(10, 3),
 up_eb decimal(10, 3),
 stat_cmt char(10),
 addmod_date char(10),
 cc char(1),

 foreign key (ndb_no)
 references food_des(ndb_no),

 foreign key (nutr_no)
 references nutr_def(nutr_no),

 foreign key (src_cd)
 references src_cd(src_cd),

 foreign key (deriv_cd)
 references deriv_cd(deriv_cd)
);

create index nutr_val on nut_data(nutr_val);

load data local infile 'NUT_DATA.txt'
into table nut_data
fields terminated by '^'
optionally enclosed by '~'
lines terminated by '\r\n';

