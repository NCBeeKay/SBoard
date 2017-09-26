
0: Load the data in RStudio
> refine_original <- read.csv("refine_original.csv")
# copy to a new data frame
> refine_clean <- refine_original

1: Clean up brand names

#Convert to lowercase
> refine_clean <- transform(refine_clean, company = tolower(company))

#remove white space
> refine_clean$company <- gsub('\\s+', '',refine_clean$company) 

#convert 0 (numeric) to "o" 
> refine_clean$company <- gsub(pattern = "0", replace = "o",refine_clean$company)

#Standardize Company Names
> refine_clean$company <- gsub(".*ps.*", "Philips", refine_clean$company)
> refine_clean$company <- gsub(".*akzo.*", "Akzo", refine_clean$company)
> refine_clean$company <- gsub(".*uten.*", "Van Houten", refine_clean$company)
> refine_clean$company <- gsub(".*ver.*", "Unilever", refine_clean$company)


2: Separate product code and number

 # add two new columns called product_code and product_number, containing the product code and number respectively
> refine_clean <- separate(refine_clean, Product.code...number, c("product_code", "product_number"), sep = "-")


3: Add product categories

# Create new column "product_category"
> refine_clean <- cbind("product_category", refine_clean)
# Note: this created new column by name : "\"product_category\""

# used below code to rename it
> names(refine_clean)[names(refine_clean) == "\"product_category\""] <- "product_category"

# Populate Product Categories
> refine_clean$product_category <- ifelse(refine_clean$product_code == "p","Smartphone",
+ ifelse(refine_clean$product_code == "x", "Laptop",
+ ifelse(refine_clean$product_code == "v", "TV",
+ ifelse(refine_clean$product_code == "q", "Tablet",
+ NA))))


4: Add full address for geocoding

# Concatenate Address, City and Country separated by comma
> refine_clean$full_address <- paste(refine_clean$address,",",refine_clean$city,",",refine_clean$country)


5: Create dummy variables for company and product category

# Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever.
> refine_clean$company_philips <- as.numeric(refine_clean$company == "Philips")
> refine_clean$company_akzo <- as.numeric(refine_clean$company == "Akzo")
> refine_clean$company_van_houten <- as.numeric(refine_clean$company == "Van Houten")
> refine_clean$company_unilever <- as.numeric(refine_clean$company == "Unilever")

# Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet.
> refine_clean$product_smartphone <- as.numeric(refine_clean$product_category == "Smartphone")
> refine_clean$product_tv <- as.numeric(refine_clean$product_category == "TV")
> refine_clean$product_laptop <- as.numeric(refine_clean$product_category == "Laptop")
> refine_clean$product_tablet <- as.numeric(refine_clean$product_category == "Tablet")


Output: Export dataframe to "refine_clean.csv"
write.csv(refine__clean, file = "refine_clean.csv", row.names = FALSE)

