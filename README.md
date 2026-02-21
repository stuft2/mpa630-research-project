# ANES Research Project

How does trust in government vary by income, race, and education?

## Variables

| # | ANES Variable | Variable Label | Role | Description | Question | Values |
|---|--------------|----------------|------|-------------|----------|--------|
| 1 | V241229 | Trust federal government | Dependent | Frequency of trusting federal gov't | How often can you trust the federal government in Washington to do what is right? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Always; 2. Most of the time; 3. About half the time; 4. Some of the time; 5. Never |
| 2 | V241231 | Government run by big interests | Dependent | Cynicism about government control | Would you say the government is pretty much run by a few big interests looking out for themselves or that it is run for the benefit of all the people? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Run by a few big interests; 2. For the benefit of all the people |
| 3 | V241232 | Government wastes tax money | Dependent | Perceived government efficiency | Do you think that people in government waste a lot of the money we pay in taxes, waste some of it, or don't waste very much of it? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Waste a lot; 2. Waste some; 3. Don't waste very much |
| 4 | V241566x | Household income (category) | Independent | Respondent household income | — | -9. Refused; -5. Break off; -4. Error; -1. Inapplicable; 1. Under $5,000; 2. $5,000–9,999; ... 28. $250,000 or more |
| 5 | V241501x | Race / ethnicity (summary) | Independent | Summary race–ethnicity | — | -9. Refused; -8. Don't know; -4. Error; 1. White non-Hispanic; 2. Black non-Hispanic; 3. Hispanic; 4. Asian/NHOPI non-Hispanic; 5. Native American/other non-Hispanic; 6. Multiple races non-Hispanic |
| 6 | V241463 | Educational attainment | Independent | Highest education completed | What is the highest level of school you have completed or the highest degree you have received? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Less than 1st grade; ... 16. Doctorate degree; 95. Other |
| 7 | V241177 | Ideological self-placement | Control | Liberal–conservative scale | Where would you place yourself on this scale, or haven't you thought much about this? | -9. Refused; -4. Error; 1. Extremely liberal; 2. Liberal; 3. Slightly liberal; 4. Moderate; 5. Slightly conservative; 6. Conservative; 7. Extremely conservative; 99. Haven't thought much about this |
| 8 | V241129x | Approval of Congress | Control | Job approval of U.S. Congress | — | -2. DK/RF; -1. Inapplicable; 1. Approve strongly; 2. Approve not strongly; 3. Disapprove not strongly; 4. Disapprove strongly |
| 9 | V241458x | Age | Control | Respondent age | — | -2. Missing; 80. Eighty years old or older |
| 10 | V241550 | Sex | Control | Self-reported sex | What is your sex? | -9. Refused; -4. Error; 1. Male; 2. Female |
| 11 | V241461x | Marital status | Control | Current marital status | Are you now married, widowed, divorced, separated or never married? | -9. Refused; -1. Inapplicable; 1. Married: spouse present; 2. Married: spouse absent; 3. Widowed; 4. Divorced; 5. Separated; 6. Never married |
| 12 | V241294x | National economy retrospective | Control | Economic perceptions | National economy better or worse in last year? | -4. Error; -2. DK/RF; 1. Gotten much better; 2. Gotten somewhat better; 3. Stayed about the same; 4. Gotten somewhat worse; 5. Gotten much worse |
| 13 | V241235 | Elections make government responsive | Control | Democratic responsiveness | How much do you feel that having elections makes the government pay attention to what the people think? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. A good deal; 2. Some; 3. Not much |
| 14 | V241234 | Generalized social trust | Control | Interpersonal trust | Generally speaking, how often can you trust other people? | -9. Refused; -1. Inapplicable; 1. Always; 2. Most of the time; 3. About half the time; 4. Some of the time; 5. Never |
| 15 | V241127 | Approval of Congress (binary) | Robustness | Approve/disapprove Congress | Do you approve or disapprove of the way the U.S. Congress has been handling its job? | -9. Refused; -8. Don't know; -1. Inapplicable; 1. Approve; 2. Disapprove |
| 16 | V242058x | Registered state | Control | State respondent is registered to vote | — | -1. Inapplicable; State numeric codes (1–56) |
| 17 | V241227x | Party identification (summary) | Control | Respondent's party identification | — | -9. Refused; -8. Don't know; -4. Error; 1. Strong Democrat; 2. Not very strong Democrat; 3. Independent-Democrat; 4. Independent; 5. Independent-Republican; 6. Not very strong Republican; 7. Strong Republican |

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
