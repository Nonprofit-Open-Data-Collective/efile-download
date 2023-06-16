# efile-download

Script for downloading 990 files from the IRS "Form 990 Series Download" site. 

```r

library( dplyr )
library( xml2 )
library( rvest )
library( microseq )

get_filename <- function(x)
{
  strsplit( x, "/" ) %>%
  unlist() %>%
  tail(1)
}

get_year <- function(x)
{
  xml.year <- microseq::gregexpr( 'xml/[0-9]{4}/', x, extract = TRUE ) %>% unlist()
  year <- substr( xml.year, 5, 8 )
  return(year)
}


# DIRECTORY SETUP:
# CREATE ONE FOLDER PER YEAR

dir.create("XML")
setwd("XML")

xml.zip %>%
  sapply( get_year ) %>% 
  unique() %>% 
  lapply( dir.create )


### GET DOWNLOAD URLS 

URL <- "https://www.irs.gov/charities-non-profits/form-990-series-downloads"
pg <- read_html(URL)

links <- html_attr( html_nodes( pg, "a" ), "href" )
xml.zip <- grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}zip', links, value = TRUE )
index.csv <-   grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}\\.csv', links, value = TRUE )


### DOWNLOAD INDEX FILES

for( i in index.csv )
{
  fn <- get_filename(i)
  download.file( i, fn )
}


### DOWNLOAD XML ZIPPED FILES
### AND UNZIP

for( i in xml.zip )
{
  fn <- get_filename( i )
  yyyy <- get_year( i )

  setwd( yyyy )
  try( download.file( i, fn ) )
  try( unzip( fn ) )
  setwd("..")
}
```


## Current XML File Links

Updated June 2023. 

```r
index.csv <- 
c("https://apps.irs.gov/pub/epostcard/990/xml/2023/index_2023.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/index_2022.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/index_2021.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/index_2020.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/index_2019.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/index_2018.csv", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/index_2017.csv"
)

xml.zip <- 
c("https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_01A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_02A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_03A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_04A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01B.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01C.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01D.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01E.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01F.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_11A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_11B.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_11C.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01A.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01B.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01C.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01D.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01E.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01F.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01G.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2021/2021_TEOS_XML_01H.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_2.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_3.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_4.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_5.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_6.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_7.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2020/download990xml_2020_8.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_2.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_3.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_4.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_5.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_6.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_7.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2019/download990xml_2019_8.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_2.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_3.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_4.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_5.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_6.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2018/download990xml_2018_7.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_2.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_3.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_4.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_5.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_6.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2017/download990xml_2017_7.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_2.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_3.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_4.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_5.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2016/download990xml_2016_6.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2015/download990xml_2015_1.zip", 
"https://apps.irs.gov/pub/epostcard/990/xml/2015/download990xml_2015_2.zip"
)
```
