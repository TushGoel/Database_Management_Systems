-- CS5200: Database Systems
-- Homework #2: Genes and Disease

-- Create a new schema called "gad"
-- Then use the data import wizard to load the data "gad.csv" into a new table, also called "gad"
-- Remember to change the inferred datatype for the chromosome field from INT to TEXT
-- (There is a MySQL workbench bug where you have to slightly resize the dialog box before you can scroll through the list of fields.)
-- You should end up with a table containing 39,910 records

-- Write a query to answer each of the following questions
-- Questions 1-15: 6 points each. Question 16: 10 points.
-- Save your script file as cs5200_hw2_fullname.sql
-- Submit this file for your homework submission


use gad;

describe gad;

-- ALTER TABLE gad
-- MODIFY chromosome TEXT;

-- 1. 
-- Verify that you have 39,910 records 
use gad;
select count(gene) as 'Total Records'
from gad;

-- 2. 
-- What are the most studied disease classes?
-- In otherwords, how many gad records are there for each disease class?
-- Output your list from most records to least
-- Ans-2
select disease_class as 'Disease Class', count(disease_class) as 'Total GAD Records'
from gad
group by disease_class
order by count(disease_class) DESC;

-- 3. 
-- What are the most studied phenotypes for the disease class IMMUNE?
-- Ans-3
select phenotype, count(phenotype)
from gad
where disease_class = 'IMMUNE'
group by phenotype
order by count(phenotype) desc;

-- 4. 
-- List all G protein-coupled receptors in alphabetical order
-- Hint: look for the phrase "G protein-coupled" in the gene name.
-- Output gene, gene name, and chromosome
-- (These genes are often the target for new drugs, so are of particular interest)
select gene, gene_name, chromosome
from gad
where gene_name like '%G protein-coupled%'
order by gene_name;


-- 5. 
-- What diseases have been positively linked to G protein-coupled receptors?
-- List the disease/phenotype and the number of publications (records) that report a positive association.
-- Use a sub-query, not a view
-- Ans-5
select disease_class, phenotype, count(association)
from gad
where gene_name like '%G protein-coupled%' and association='Y'
group by phenotype
order by disease_class;

-- 6. 
-- For genes on chromosome 3, what is the minimum, maximum DNA location
-- Exclude cases where the dna_start value is 0
-- Ans-6
select min(dna_start) as 'Minimum DNA location', max(dna_end) as 'Maximum DNA location'
from gad
where chromosome = '3' and dna_start <> '0';
-- group by gene
-- order by dna_start;

-- 7. 
-- For each gene, what is the earliest and latest reported year
-- involving a positive association
-- Ignore records where the year isn't valid. (You have to determine what constitutes a valid year.)
-- Output the gene, min-year, max-year, and number of records
-- order by min-year, max-year, gene (3-level sorting)
-- Ans-7
select gene, min(year), max(year), count(gene) 
from gad
where association='Y' and year > 999
group by gene
order by min(year), max(year), gene;

-- 8. 
-- How many records are there for each gene?
-- Output the gene symbol and name and the count of the number of records
-- Order by the record count in descending order
-- Ans-8
select gene, gene_name, count(gene)
from gad
group by gene, gene_name
order by count(gene) desc;

-- 9. 
-- Modify query 8 by considering only positive associations
-- and limit output to records having at least 100 associations
-- Ans-9
select gene, gene_name, count(gene)
from gad
where association='Y' 
group by gene_name
having count(association)>= 100
order by count(gene);

-- 10. 
-- How many records are there for each population group?
-- Sort in descending order by count
-- Show only the top five records
-- Do NOT include cases where the population is blank
-- Ans-10
select population, count(population)
from gad
where population <> ''
group by population
having count(population) > 350
order by count(population) desc;

-- 11.
-- What genes are linked to Asthma?  
-- Include any gene with a positive assoication to a phenotype containing the substring 'asthma'. 
-- Rank the genes by the number of publications that report the linkage (most to least).  
-- Output the gene (symbol), gene name, and number of publications. Include only genes that have been 
-- linked to asthma-related phenotypes in 2 or more publications.  
-- Create a VIEW called asthma_genes containing the output of these query.
-- Ans-11
-- create view asthma_genes as
select gene, gene_name, count(pubmed_id) as 'No. of Publications'
from gad
where phenotype like '%asthma%' and association = 'Y'
group by gene, gene_name
having count(pubmed_id) >= 2
order by count(pubmed_id) desc;

-- 12.
-- With the help of your asthma_genes VIEW, find all distinct gene-phenotype 
-- associations involving asthma genes.  Sort your result by phenotype, then gene.
-- Exclude blank / empty phenotypes
-- Ans-12
select distinct phenotype, gene
from gad
where gene in (select gene
from asthma_genes) and phenotype <> '' and association = 'Y'
order by phenotype, gene;

-- 13. 
-- The phenotypes listed in the previous table are all phenotypes
-- linked to one or more asthma genes. For each of these phenotypes,
-- count the number of asthma genes linked to that phenotype.
-- Order from most to least. Show only the top 5 disease / phenotypes.   
-- Be sure to exclude both asthma-related phenotypes and empty phenotypes from this list!
-- Use a sub-query instead of a view.
-- Ans-13
select phenotype, gene, count(distinct gene)
from gad
where gene in (select distinct gene
from asthma_genes)
and phenotype <> '' and phenotype <> 'asthma'
group by phenotype
order by count(distinct gene) desc
limit 5;

-- 14.	
-- Consider asthma and the top disease found in the previous question.
-- What genes do they all have in common? (You may hard-code the names of the phenotypes in your query.)
-- For each gene, list how ofteneee it was reported to be positively linked to asthma and in a separate column
-- how often it was reported to be positively linked to your top disease.
-- Filter your result to show only those genes where links to both asthma and your top disease have been
-- reported multiple times (i.e., 3 or more times).
-- Ans-14
select distinct gene, 
count(case when phenotype = 'Multiple Sclerosis' and association like 'Y' then 1 else null end) as 'Mutliple_Sclerosis_Count', 
count(case when phenotype = 'asthma' and association like 'Y' then 1 else null end) as 'Asthma_Count'
from gad
where gene in (select gene from gad where phenotype = 'Multiple Sclerosis')  
and gene in (select gene from gad where phenotype = 'asthma') 
group by gene
having Mutliple_Sclerosis_Count >= 3 and Asthma_Count >= 3
order by gene;

-- 15. 
-- Interpret your analysis:
-- a) Does existing biomedical research support a connection between asthma and the disease you identified above?
-- b) Why might a drug company be interested in instances of such "overlapping" phenotypes?
-- Ans-15 Attach .PDF File contains the answer of this question. (PFA)

-- 16. (10 points) OPEN RESEARCH QUESTION
-- What other interesting insight can you derive from this dataset using a SQL query? 
-- Perhaps something involving populations?  Publications? Disease class?  
-- Are some types of diseases the focus of more research?   This is an open-ended question! 
-- Impress me with your analytical creativity! But if you want full credit you have to:

-- a)	Ask a specific and interesting question
-- b)	Define a single SQL query that produces a result
-- c)	Present your answer (You may attach a separate .PDF file with your analysis including tables or figures.)
-- Ans-16 SQl Query
select disease_class as 'Disease Class', 
phenotype as 'Disease/Phenotype', 
population as 'Population Type', 
association 'Type Of Association', 
count(phenotype) as 'No. of Records', 
max(year) as 'Latest Year of Occurence'
from gad
where population <> '' and association='Y' and year > 999 
group by disease_class, population, phenotype
order by count(phenotype) desc
Limit 16;