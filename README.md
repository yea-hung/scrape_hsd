# Description

R function for scraping facility data from the [Homeless Shelter Directory](https://www.homelessshelterdirectory.org/).

# Dependencies

- *rvest*

# Use

Define `NAME` and `ABB` in `scrape_facilities()`. For example:

```r
wyoming<-scrape_hsd('Wyoming','WY')
```
