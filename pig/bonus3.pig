-- Load only the ad_data1 and ad_data2 directories
data = LOAD '/dualcore/ad_data[12]' AS (campaign_id:chararray,
             date:chararray, time:chararray,
             keyword:chararray, display_site:chararray,
             placement:chararray, was_clicked:int, cpc:int);

grouped = GROUP data BY display_site;

by_site = FOREACH grouped {
  -- Include only records where the ad was clicked
  wasClicked = FILTER data BY was_clicked == 1;
  -- count the number of records in this group
   GENERATE   data.display_site, COUNT (wasClicked) as cost;	  
  /* Calculate the click-through rate by dividing the 
   * clicked ads in this group by the total number of ads
   * in this group.
   */
}

sort_new_data = order by_site BY cost;
limit_three = limit sort_new_data 3;
dump limit_three;
-- sort the records in ascending order of clickthrough rate


-- show just the first three
-- 잘못짠건지 이상하게 나오네...