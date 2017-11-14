<b>A Web Crawler for Heriditas journal</b> available at https://hereditasjournal.biomedcentral.com/.

The crawler extracts the data related to all the articles in the journal.


There are four scripts in this folder:

Crawler.R:
	This script has the crawl() function which is used to get all DOI addresses.

Crawler_Main.R:
	This script will process DOI addresses we get from Crawler.R and read those articles and then save all articles as html files in a folder called "Crawlered Files".

Extract_Data.R:
	This script scans the crawled files and extracts data and create a data frame. Aditionally it writes the data frame a text file.

<b>Steps:</b>
1. Execute Crawled_Main.R to save the .html files in a new folder "Crawled Files".
2. Then execute Extract_data.R to extract the data and store it in "Hereditas.txt" file.)
