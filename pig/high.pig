/*-- TODO (A): Replace 'FIXME' to load the test_ad_data.txt file.*/

data = LOAD '/dualcore/ad_data[1-2]' AS (
  campaign_id:chararray,
  date:chararray, 
  time:chararray,
  keyword:chararray, 
  display_site:chararray, 
  placement:chararray, 
  was_clicked:int, 
  cpc:int);
/*dump data;*/

/*-- TODO (B): Include only records where was_clicked has a value of 1
only_one = filter data by was_clicked == 1;
dump only_one;*/

/*-- TODO (C): Group the data by the appropriate field
group_dp_site = group only_one by display_site;
dump group_dp_site;*/

/* TODO (D): Create a new relation which includes only the 
 *           display site and the total cost of all clicks 
 *           on that site
 */
new_group = group data by keyword;
/*dump new_group;*/
new_data = foreach new_group generate group as keyword, SUM(data.was_clicked) as cost;
/*dump new_data;*/

/*-- TODO (E): Sort that new relation by cost (ascending)*/
sort_new_data = order new_data BY cost desc;
/*dump sort_new_data;*/

/*-- TODO (F): Display just the first three records to the screen*/
limit_three = limit sort_new_data 5;
dump limit_three;
/* highest 5
(PRESENT,1526)
(DUALCORE,1110)
(TABLET,954)
(BARGAIN,697)
(PORTABLE,550) */

