# History of changes -> SCD2
A simple example to illustrate how one can create a SCD2 table from a table containing a history of changes on a certain format (create and update = 'Active' and delete = 'Deleted'.

# Input - History of changes
| id | key | name	  | status  | extract_day |
|----|-----|--------|---------|-------------|
| 1  | 1	 | Jon	  | Active	| 2025-08-01  |
| 2  | 1	 | John	  | Active	| 2025-08-05  |
| 3	 | 1	 | Jon	  | Active	| 2025-08-07  |
| 4	 | 1	 |        | Deleted	| 2025-08-10  |
| 5	 | 1	 | Jon	  | Active	| 2025-08-15  |
| 6	 | 2	 | Bjarne	| Active	| 2025-08-10  |
| 7	 | 2	 |        | Deleted	| 2025-08-20  |

# Output - SCD2
| key	| name   | valid_from | valid_to   | is_valid |
|-----|--------|------------|------------|----------|
| 1   | Jon    | 2025-08-01	| 2025-08-05 | 0        |
| 1	  | John	 | 2025-08-05	| 2025-08-07 | 0        |
| 1	  | Jon	   | 2025-08-07	| 2025-08-10 | 0        |
| 1	  | Jon	   | 2025-08-15	| 9999-12-31 | 1        |
| 2	  | Bjarne | 2025-08-10	| 2025-08-20 | 1        |

Can be tested at https://sqlfiddle.com/postgresql/online-compiler

# Disclaimer: 
The example is made purely to illustrate a concept.
This should be further tested and verified before it's put into production. 
