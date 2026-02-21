# ANES Research Project

How does trust in government vary by income, race, and education?

## Variables

## Pre-Cleaning Variable Summary 

## Variables

| ANES Variable | Variable Label | Role | Type | Question | Values |
|--------------|----------------|------|------|----------|--------|
| V241229 | Trust federal government | Dependent | Ordinal (5-point) | How often can you trust the federal government in Washington to do what is right? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Always; 2. Most of the time; 3. About half the time; 4. Some of the time; 5. Never |
| V241231 | Government run by big interests | Dependent | Ordinal | Would you say the government is pretty much run by a few big interests looking out for themselves or that it is run for the benefit of all the people? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Run by a few big interests; 2. For the benefit of all the people |
| V241232 | Government wastes tax money | Dependent | Ordinal | Do you think that people in government waste a lot of the money we pay in taxes, waste some of it, or don't waste very much of it? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Waste a lot; 2. Waste some; 3. Don't waste very much |
| V241566x | Household income (category) | Independent | Ordinal categorical | — | -9. Refused; -5. Break off; -4. Error; -1. Inapplicable; 1. Under $5,000; 2. $5,000–9,999; ... 28. $250,000 or more |
| V241501x | Race / ethnicity (summary) | Independent | Categorical | — | -9. Refused; -8. Don't know; -4. Error; 1. White non-Hispanic; 2. Black non-Hispanic; 3. Hispanic; 4. Asian/NHOPI non-Hispanic; 5. Native American/other non-Hispanic; 6. Multiple races non-Hispanic |
| V241463 | Educational attainment | Independent | Ordinal | What is the highest level of school you have completed or the highest degree you have received? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Less than 1st grade; ... 16. Doctorate degree; 95. Other |
| V241177 | Ideological self-placement | Control | Ordinal | Where would you place yourself on this scale, or haven't you thought much about this? | -9. Refused; -4. Error; 1. Extremely liberal; 2. Liberal; 3. Slightly liberal; 4. Moderate; 5. Slightly conservative; 6. Conservative; 7. Extremely conservative; 99. Haven't thought much about this |
| V241129x | Approval of Congress | Control | Ordinal | — | -2. DK/RF; -1. Inapplicable; 1. Approve strongly; 2. Approve not strongly; 3. Disapprove not strongly; 4. Disapprove strongly |
| V241458x | Age | Control | Continuous | — | -2. Missing; 80. Eighty years old or older |
| V241550 | Sex | Control | Binary | What is your sex? | -9. Refused; -4. Error; 1. Male; 2. Female |
| V241461x | Marital status | Control | Categorical | Are you now married, widowed, divorced, separated or never married? | -9. Refused; -1. Inapplicable; 1. Married: spouse present; 2. Married: spouse absent; 3. Widowed; 4. Divorced; 5. Separated; 6. Never married |
| V241294x | National economy retrospective | Control | Ordinal | National economy better or worse in last year? | -4. Error; -2. DK/RF; 1. Gotten much better; 2. Gotten somewhat better; 3. Stayed about the same; 4. Gotten somewhat worse; 5. Gotten much worse |
| V241235 | Elections make government responsive | Control | Ordinal | How much do you feel that having elections makes the government pay attention to what the people think? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. A good deal; 2. Some; 3. Not much |
| V241234 | Generalized social trust | Control | Ordinal | Generally speaking, how often can you trust other people? | -9. Refused; -1. Inapplicable; 1. Always; 2. Most of the time; 3. About half the time; 4. Some of the time; 5. Never |
| V241127 | Approval of Congress (binary) | Robustness | Binary | Do you approve or disapprove of the way the U.S. Congress has been handling its job? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Approve; 2. Disapprove |
| V242058x | Registered state | Control | Categorical | — | -1. Inapplicable; State numeric codes (1–56) |
| V241227x | Party identification (summary) | Control | Ordinal | — | -9. Refused; -8. Don't know; -4. Error; 1. Strong Democrat; 2. Not very strong Democrat; 3. Independent-Democrat; 4. Independent; 5. Independent-Republican; 6. Not very strong Republican; 7. Strong Republican |

## Post-Cleaning Variable Summary

| Variable | Retained Values | N (Non-Missing) | Mean | Median | Mode |
|----------|----------------|----------------|------|--------|------|
| **Dependent Variables** ||||||
| trust_clean | Always; Most of the time; About half the time; Some of the time; Never | 4,928 | — | — | Some of the time |
| trust_numeric | 1–5 | 4,928 | 3.56 | 4 | 4 |
| trust_binary | 1 = High Trust (Always/Most of the time); 0 = Low Trust (Some/Never) | 3,557 | 0.21 | 0 | 0 |
| big_interests_clean | Run by big interests; For benefit of all | 4,894 | — | — | Run by big interests |
| big_interests_numeric | 1–2 | 4,894 | 1.17 | 1 | 1 |
| waste_clean | Waste a lot; Waste some; Don't waste very much | 4,919 | — | — | Waste a lot |
| waste_numeric | 1–3 | 4,919 | 1.35 | 1 | 1 |
| **Independent Variables** ||||||
| income_clean | 1–28 (original brackets) | 4,928 | 17.72 | 20 | 27 |
| income_category | Under $25,000; $25,000–$49,999; $50,000–$99,999; $100,000+ | 4,928 | — | — | $100,000+ |
| race_clean | White non-Hispanic; Black non-Hispanic; Hispanic; Asian/Pacific Islander non-Hispanic; Native American/Other non-Hispanic; Multiple races non-Hispanic | 4,928 | — | — | White, non-Hispanic |
| education_clean | 1–16; 95 | 4,928 | 12.46 | 12 | 13 |
| education_category | Less than high school; High school graduate; Some college/Associate; Bachelor's degree; Graduate degree | 4,872 | — | — | Some college/Associate |
| **Control Variables** ||||||
| ideology_clean | Extremely liberal; Liberal; Slightly liberal; Moderate; Slightly conservative; Conservative; Extremely conservative | 4,263 | — | — | Moderate |
| ideology_numeric | 1–7 | 4,263 | 4.10 | 4 | 4 |
| congress_approval_clean | Approve strongly; Approve not strongly; Disapprove not strongly; Disapprove strongly | 4,831 | — | — | Disapprove strongly |
| congress_approval_numeric | 1–4 | 4,831 | 3.35 | 4 | 4 |
| age_clean | 18–80 | 4,782 | 52.73 | 53 | 80 |
| sex_clean | Male; Female | 4,922 | — | — | Female |
| marital_clean | Married: spouse present; Married: spouse absent; Widowed; Divorced; Separated; Never married | 4,927 | — | — | Married: spouse present |
| marital_simple | Married; Previously married; Never married | 4,927 | — | — | Married |
| economy_clean | Much better; Somewhat better; About the same; Somewhat worse; Much worse | 4,902 | — | — | Much worse |
| economy_numeric | 1–5 | 4,902 | 3.65 | 4 | 5 |
| elections_responsive_clean | A good deal; Some; Not much | 4,928 | — | — | Some |
| elections_responsive_numeric | 1–3 | 4,928 | 1.89 | 2 | 2 |
| social_trust_clean | Always; Most of the time; About half the time; Some of the time; Never | 4,921 | — | — | Most of the time |
| social_trust_numeric | 1–5 | 4,921 | 2.84 | 3 | 2 |
| congress_binary_clean | Approve; Disapprove | 4,841 | — | — | Disapprove |
| congress_binary | 1–2 | 4,841 | 1.82 | 2 | 2 |
| party_clean | Strong Democrat; Not very strong Democrat; Independent-Democrat; Independent; Independent-Republican; Not very strong Republican; Strong Republican | 4,914 | — | — | Strong Democrat |
| party_numeric | 1–7 | 4,914 | 3.87 | 4 | 1 |
| state_clean | Valid state codes > 0 (1–56) | 4,574 | 28.22 | 27 | 6 |

> **Note:** Mean and median are shown for numeric variables only; — indicates
> categorical variables where averages are not meaningful. trust_binary N is
> lower (3,557) because "About half the time" (value 3) was excluded from
> the binary recoding. All negative values and 99 were recoded as NA.
## Data Cleaning

1. Adapted existing R code for the ANES dataset, updating name, email, and date in the script header.
2. Loaded the `pacman` package to manage dependencies.
3. Imported the CSV data into an object called `dt`.
4. Selected the 17 variables of interest and stored them in an object called `anes`.
5. Renamed all variable numbers with descriptive variable labels.
6. Removed non-substantive responses using the codebook, recoding the following values as `NA`:
   - `-9` = Refused
   - `-8` = Don't know
   - `-4` = Error
   - `-2` = DK/RF
   - `-1` = Inapplicable
   - `99` = Haven't thought much about this
7. Recoded trust variables into a binary measure: **High Trust** vs. **Low Trust**.
8. Collapsed income categories to reduce the number of brackets.
9. Ran verification code to assess how much data was removed after recoding.
10. Reran `summary()`, `glimpse()`, and `names()` on the cleaned `anes` object to confirm results.
