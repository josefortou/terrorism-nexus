# Terrorism and organized crime in Colombia

This repository contains replication files for the book chapter:

- Duncan, G., Sosa, S. & Fortou, J.A. (Forthcoming). Terrorism and organized crime in Colombia. In C. Fijnaut, L. Paoli & J. Wouters (Eds.), *What is the nexus between organized crime and terrorism? Types, promoting conditions and policies*. Edward Elgar Publishing.

There are two key files, both in the `R` folder:

- `prep.R` loads, tidies, and merges data from the Centro Nacional de Memoria Histórica (CNMH) and the Global Terrorism Dataset (GTD) stored in the `data/` folder. The output is a single file containing the final dataset, saved in both RDS and CSV formats (`output/terr_data.rds` and `output/terr_data.csv`).
- `analysis.R` takes the dataset produced in `prep.R` and outputs Figures 1 and 2 from the book chapter.
