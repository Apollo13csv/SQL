insert into "language" (id, "name", total_speakers)
values ('001','English', '1348000000'),
	('002', 'Mandarin Chinese', '1120000000'),
	('003', 'Hindi', '600000000'),
	('004', 'Spanish', '543000000'),
	('005', 'Standard Arabic', '274000000')
	
insert into nation (id, "name", "area")
values ('001','Germanic', ' Europe, North America, Oceania, Southern Africa'),
	('002', 'Sinitic', 'Chinese'),
	('003', 'Indo-Aryan', 'Hindi-Urdu, Bengal, Nepal'),
	('004', 'Romance', 'Spanish, Portuguese, French, Italian, Romanian'),
	('005', 'Semitic', ' Arabic, Amharic, Tigrinya, Hebrew, Tigre, Aramaic, Maltese')
	
insert into ñountry (id, "name", land_area)
values ('001','United Kingdom', '241930'),
	('002', 'China', '9388211'),
	('003', 'Nepal', '143350'),
	('004', 'Spain', '498800'),
	('005', 'Qatar', '11610')
	
insert into nation_language(n_language_id, n_nation_id)
values ('1', '1'),
		('2', '2'),
		('3', '3'),
		('4', '4'),
		('5', '5')
		
insert into ñountry_language(cl_ñountry_id, ñl_language_id)
values ('1', '1'),
		('2', '2'),
		('3', '3'),
		('4', '4'),
		('5', '5')