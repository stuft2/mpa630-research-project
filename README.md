# ANES Research Project

How does trust in government vary by income, race, and education?

## Variables

| ANES Variable | Variable Label                              | Role        | Description                                 |
|--------------|----------------------------------------------|------------|---------------------------------------------|
| V241229     | Trust federal government                     | Dependent  | Frequency of trusting federal gov’t         |
| V241231     | Government run by big interests              | Dependent  | Cynicism about government control           |
| V241232     | Government wastes tax money                  | Dependent  | Perceived government efficiency             |
| V241566x    | Household income (category)                  | Independent| Respondent household income                 |
| V241501x    | Race / ethnicity (summary)                   | Independent| Summary race–ethnicity                      |
| V241463     | Educational attainment                       | Independent| Highest education completed                 |
| V241177     | Ideological self-placement                   | Control    | Liberal–conservative scale                  |
| V241129x    | Approval of Congress                         | Control    | Job approval of U.S. Congress               |
| V241458x    | Age                                          | Control    | Respondent age                              |
| V241551     | Gender identity                              | Control    | Self-identified gender                      |
| V241550     | Sex                                          | Control    | Self-reported sex                           |
| V241461x    | Marital status                               | Control    | Current marital status                      |
| V241294x    | National economy retrospective               | Control    | Economic perceptions                        |
| V241235     | Elections make government responsive         | Control    | Democratic responsiveness                   |
| V241234     | Generalized social trust                     | Control    | Interpersonal trust                         |
| V241127     | Approval of Congress (binary)                | Robustness | Approve/disapprove Congress                 |
| V242058x    | Registered state                             | Control    | State in which respondent is registered to vote |
| V241227x    | Party identification (summary)               | Control    | Respondent’s party identification           |


## Cleaning the data

Non-substantive responses were recoded as `NA`:
  - `-9` = Refused
  - `-8` = Don’t know
  - `-1` = Inapplicable


