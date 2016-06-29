-- a mysql query to select all sys_file entries in the bodytext field of tt_content elements in a pagetree (rootpid = 292) with a max-depth of 4
SELECT sys_file.uid, sys_file.identifier, sys_file.storage 
	FROM (
		(select p1.title as title, p1.uid as uid from pages p1 WHERE p1.pid=292 order by p1.sorting)
		UNION 
		(select p2.title as title, p2.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid WHERE p1.pid=292 AND NOT p2.uid IS NULL order by p1.sorting, p2.sorting)
		UNION 
		(select p3.title as title, p3.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid WHERE p1.pid=292 AND NOT p3.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting) 
		UNION 
		(select p4.title as title, p4.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid left join pages p4 on p4.pid=p3.uid WHERE p1.pid=292 AND NOT p4.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting, p4.sorting)
	) pagetree
LEFT JOIN tt_content ON tt_content.pid=pagetree.uid AND tt_content.bodytext LIKE '%<link file:%'
LEFT JOIN sys_file ON sys_file.uid=trim('>' FROM trim(substring(substring(tt_content.bodytext, locate('<link file:', tt_content.bodytext), 15), 12, 4)))
WHERE NOT sys_file.uid IS NULL;

-- a mysql query to update the sys_file_storage (-> 63) of all sys_file entries in the bodytext field of tt_content elements in a pagetree (rootpid = 292) to with a max-depth of 4
UPDATE 
	(
		(select p1.title as title, p1.uid as uid from pages p1 WHERE p1.pid=292 order by p1.sorting)
		UNION 
		(select p2.title as title, p2.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid WHERE p1.pid=292 AND NOT p2.uid IS NULL order by p1.sorting, p2.sorting)
		UNION 
		(select p3.title as title, p3.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid WHERE p1.pid=292 AND NOT p3.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting) 
		UNION 
		(select p4.title as title, p4.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid left join pages p4 on p4.pid=p3.uid WHERE p1.pid=292 AND NOT p4.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting, p4.sorting)
	) pagetree
LEFT JOIN tt_content ON tt_content.pid=pagetree.uid AND tt_content.bodytext LIKE '%<link file:%'
LEFT JOIN sys_file ON sys_file.uid=trim('>' FROM trim(substring(substring(tt_content.bodytext, locate('<link file:', tt_content.bodytext), 15), 12, 4)))
SET sys_file.storage=63
WHERE NOT sys_file.uid IS NULL;
