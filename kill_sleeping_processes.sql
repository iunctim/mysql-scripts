-- This script kills all sleeping process of the user 'root'
select concat('KILL ',id,';') from information_schema.processlist where user='root' AND Command="Sleep";

select concat('KILL ',id,';') from information_schema.processlist where user='root' AND Command="Sleep" into outfile '/tmp/a.txt';

source /tmp/a.txt;
