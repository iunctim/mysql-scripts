-- a mysql query to update the sys_language_uid (0 -> 1) of the translated pages in a pagetree (rootpid = 297) with a max-depth of 4
UPDATE (
		(select p1.title as title, p1.uid as uid from pages p1 WHERE p1.pid=297 order by p1.sorting)
		UNION 
		(select p2.title as title, p2.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid WHERE p1.pid=297 AND NOT p2.uid IS NULL order by p1.sorting, p2.sorting)
		UNION 
		(select p3.title as title, p3.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid WHERE p1.pid=297 AND NOT p3.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting) 
		UNION 
		(select p4.title as title, p4.uid as uid from pages p1 left join pages p2 on p2.pid = p1.uid left join pages p3 on p3.pid = p2.uid left join pages p4 on p4.pid=p3.uid WHERE p1.pid=297 AND NOT p4.uid IS NULL order by p1.sorting, p2.sorting, p3.sorting, p4.sorting)
	) pagetree
LEFT JOIN pages_language_overlay po ON po.pid=pagetree.uid SET po.sys_language_uid=1 WHERE NOT po.uid IS NULL and po.sys_language_uid=0;
