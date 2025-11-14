What is a fact table and what kind of data does it store?

A fact table is a central table in a data warehouse or star schema that stores quantitative data for analysis.

What is a dimension table and how does it relate to a fact table?

A dimension table is essentially the context or descriptive layer in a data warehouse that complements a fact table. While a fact table stores measurable data, a dimension table stores the attributes

Explain the difference between star and snowflake schemas.

In a star schema, all dimension tables are directly related to the main fact one, and in a snowflake schema, dimensions can have their own dimensions.

What is the purpose of the stage layer in a DWH?

Cleaned and standardized version of raw data.Removes duplicates, fixes types, and aligns formats. Purpose: make data consistent for transformation.

Why is the raw layer important in data pipelines?

The raw layer in data pipelines is important for preserving original, immutable data, ensuring recovery, auditing, and flexibility for further transformations.

What is the purpose of the mart layer in a DWH?

Curated, business-ready data. Aggregated and modeled for reporting. Built from staged data, not directly from raw.

How would you handle slowly changing dimensions (SCD Type 1 vs Type 2)?

SCD TYPE 1: Updating the DWH table when a Dimension changes, overwriting the original data. SCD TYPE 2: Keeping full history - Adding additional (historic data) rows for each dimension change.

What is the main difference between Type 1, Type 2, and Type 3 SCDs?

Type 1: Overwrites data; history is not saved. Type 2: Saves full history through new lines. Type3: stores only the previous value in additional columns.

What is Data Lineage?

Data lineage is tracking the path of data from source to end use, including all transformations, processing, and movements, to understand where, how, and by whom the data has been changed.

What is a Data Warehouse (DWH), and what is its main purpose?

A Data Warehouse (DWH) is a centralized repository that stores integrated, historical, and structured data from multiple sources, optimized for reporting, analytics, and decision-making rather than transactional processing.


