# ANES Variable Plan

## Research Question

How does trust in government vary by income, race, and education?

## Variables Overview

| Variable Code | Variable Name | Type / Category | Description |
|--------------|---------------|-----------------|-------------|
| [**V241229**](#v241229--trust-federal-government) | Trust federal government | Dependent variable (Trust) | How often respondent trusts the federal government in Washington to do what is right (Always → Never). |
| [**V241231**](#v241231--government-run-by-big-interests) | Government run by big interests | Dependent variable (Trust/Cynicism) | Whether government is run by a few big interests or for the benefit of all people. |
| [**V241232**](#v241232--government-wastes-tax-money) | Government wastes tax money | Dependent variable (Trust/Efficiency) | Perception of how much tax money the government wastes. |
| [**V241566x**](#V241566x--household-income-category) | Household income (category) | Key independent variable | Household income category (<$40k, $40k–$74,999, $75k–$124,999, $125k+). |
| [**V241507x**](#v241507x--race--ethnicity-summary) | Race / ethnicity (summary) | Key independent variable | Summary race/ethnicity: Non-Hispanic White, Non-Hispanic Black, Hispanic, Non-Hispanic Other. |
| [**V241509**](#v241509--educational-attainment) | Educational attainment | Key independent variable | Highest level of education completed (less than HS → graduate degree). |
| [**V241227x**](#v241227x--party-identification) | Party identification | Political control | Seven-point party ID scale from Strong Democrat to Strong Republican. |
| [**V241177**](#v241177--ideological-self-placement) | Ideological self-placement | Political control | Respondent’s placement on a 7-point liberal–conservative scale. |
| [**V241129x**](#v241129x--approval-of-congress) | Approval of Congress | Political control | Summary measure of approval or disapproval of Congress’s job performance. |
| [**V241632**](#v241632--age) | Age | Demographic control | Respondent age (derived/summary variable used for analysis). |
| [**V241551**](#v241551--gender) | Gender | Demographic control | Self-reported gender (man, woman, nonbinary, other). |
| [**V241550**](#v241550--sex) | Sex | Demographic control | Self-reported sex (male or female). |
| [**V241505**](#v241505--marital-status) | Marital status | Demographic control | Marital status (married, widowed, divorced/separated, never married). |
| [**V241294x**](#v241294x--national-economy-retrospective) | National economy retrospective | Economic perception control | Summary measure of whether the national economy has gotten better or worse over the past year. |
| [**V241235**](#v241235--elections-make-government-responsive) | Elections make government responsive | Democratic attitudes | Perception of how much elections make government pay attention to people. |
| [**V241234**](#v241234--generalized-social-trust) | Generalized social trust | Social trust control | How often the respondent thinks other people can be trusted. |

## Methodology

### General Recoding Principles

Non-substantive responses were treated as missing:
  - `-9` = Refused
  - `-8` = Don’t know
  - `-1` = Inapplicable

### Trust in Government Variables

To measure trust in government, we created several new variables from survey questions asked in the 2024 American National Election Studies (ANES). All variables were coded so that higher values indicate greater trust in government. Responses such as “Don’t know,” “Refused,” or “Inapplicable” were treated as missing.

#### trust_fed_gov_pos  
This variable measures how often respondents say they can trust the federal government in Washington to do what is right. The original survey question allowed answers ranging from “Always” to “Never.” We reversed the original scale so that higher values represent more trust in the federal government.

#### gov_run_pos  
This variable captures whether respondents believe the government is run by a small group of powerful interests or for the benefit of all people. Respondents who believe the government works for the benefit of all people are coded as having higher trust.

#### gov_waste_pos  
This variable reflects respondents’ views about how much tax money the government wastes. People who believe the government does not waste much tax money are coded as having higher trust.

#### z_trust_fed_gov  
This is a standardized version of *trust_fed_gov_pos*. Standardization rescales the variable so that it reflects how much more or less trusting a respondent is compared to the average respondent in the sample.

#### z_gov_run  
This is a standardized version of *gov_run_pos*, placing responses on the same scale as the other trust measures so they can be combined.

#### z_gov_waste  
This is a standardized version of *gov_waste_pos*, also rescaled to be comparable with the other trust measures.

#### trust_index_z  
This variable is an overall measure of trust in government. It was created by averaging the three standardized trust measures described above. Values above zero indicate higher-than-average trust in government, while values below zero indicate lower-than-average trust.

## Variables Overview

### V241229 – Trust federal government
Type: Dependent variable (Trust)  
Description: How often respondent trusts the federal government in Washington to do what is right (Always → Never).  
Notes: Primary trust DV; five-point scale.

Valid responses (`1–5`) were reverse-coded so that higher values indicate greater trust in government:

| Original value | Original label            | Recoded value | Recoded label        |
|----------------|---------------------------|---------------|----------------------|
| 1              | Always                    | 5             | Very high trust      |
| 2              | Most of the time          | 4             | High trust           |
| 3              | About half the time       | 3             | Moderate trust       |
| 4              | Some of the time          | 2             | Low trust            |
| 5              | Never                     | 1             | Very low trust       |

### V241231 – Government run by big interests
Type: Dependent variable (Trust/Cynicism)  
Description: Whether government is run by a few big interests or for the benefit of all people.  
Notes: Captures cynicism about responsiveness.

### V241232 – Government wastes tax money
Type: Dependent variable (Trust/Efficiency)  
Description: Perception of how much tax money the government wastes.  
Notes: Useful as an alternate trust indicator.

### V241566x – Household income (category)
Type: Key independent variable  
Description: Respondent household income measured on a 28-category ordinal scale ranging from under $5,000 to $250,000 or more, with finer income gradations at lower and middle income levels.
Notes: Includes standard ANES missing codes (refused, break-off, error, inapplicable). For primary analyses, income is treated as an ordered categorical variable; robustness checks may collapse categories into broader income bands.

### V241501x – Race / ethnicity (summary)
Type: Key independent variable  
Description: Summary race/ethnicity: Non-Hispanic White, Non-Hispanic Black, Hispanic, Non-Hispanic Other.  
Notes: Use summary race–ethnicity variable.

### V241509 – Educational attainment
Type: Key independent variable  
Description: Highest level of education completed (less than HS → graduate degree).  
Notes: Standard education categories.

### V241227x – Party identification
Type: Political control  
Description: Seven-point party ID scale from Strong Democrat to Strong Republican.  
Notes: Strong predictor of trust.

### V241177 – Ideological self-placement
Type: Political control  
Description: Respondent’s placement on a 7-point liberal–conservative scale.  
Notes: Captures ideology independent of party.

### V241129x – Approval of Congress
Type: Political control  
Description: Summary measure of approval or disapproval of Congress’s job performance.  
Notes: Separates institutional trust from partisan approval.

### V241632 – Age
Type: Demographic control  
Description: Respondent age (derived/summary variable used for analysis).  
Notes: Standard life-cycle control.

### V241551 – Gender
Type: Demographic control  
Description: Self-reported gender (man, woman, nonbinary, other).  
Notes: Use as gender identity measure.

### V241550 – Sex
Type: Demographic control  
Description: Self-reported sex (male or female).  
Notes: Keep if analysis requires sex rather than gender.

### V241505 – Marital status
Type: Demographic control  
Description: Marital status (married, widowed, divorced/separated, never married).  
Notes: Standard family-structure control.

### V241294x – National economy retrospective
Type: Economic perception control  
Description: Whether the national economy has gotten better or worse over the past year.  
Notes: Attitudes about the economy often drive trust.

### V241235 – Elections make government responsive
Type: Democratic attitudes  
Description: Perception of how much elections make government pay attention to people.  
Notes: Measures perceived responsiveness.

### V241234 – Generalized social trust
Type: Social trust control  
Description: How often the respondent thinks other people can be trusted.  
Notes: Distinguishes political trust from interpersonal trust.

## Modeling Notes

- Primary trust DV: V241229 (you can also build an index with V241231 and V241232).
- Core predictors from the research question: V241566x, V241507x, V241509.
- Standard controls: V241227x, V241177, V241129x, V241632, V241551/V241550, V241505, V241294x, V241235, V241234.
