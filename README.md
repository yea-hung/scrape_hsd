# Description

An R package for scraping facility data from the [Homeless Shelter Directory](https://www.homelessshelterdirectory.org/).

# Installation

Install *devtools* if you don't already have it:

```r
install.packages('devtools')
```

Install the *scrapeHSD* package:

```r
devtools::install_github('yea-hung/scrapeHSD')
```

# Use

Specify `state_name` and `state_abbreviation` in `scrape_hsd()`. For example:

```r
wyoming<-scrape_hsd('Wyoming','WY')
```
