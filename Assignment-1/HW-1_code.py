import csv

education_type = [] #Array that contain education status for all applicants
balance = [] #Array that contain balnce for all applicants
loans = [] #Array that contain loan approval status for all applicants  

# Function to read values 'loans.csv' file
with open('loans.csv') as csvDataFile: 
    csvReader = csv.reader(csvDataFile)
    for row in csvReader:

    	#Reading the values from particular rows and copying it to the corresponding array
        education_type.append(row[3]) 
        balance.append(row[5])  
        loans.append(row[16])

# Variable to the store the the value of total number of applicants
size=len(education_type)-1 

count_p=0 #Variable to count the total number of primary applicants
count_s=0 #Variable to count the total number of secondary applicants
count_t=0 #Variable to count the total number of tertiary applicants
count_n=0 #Variable to count the total number of applicants with no particular education status
balance_p= [] #Array to store the balances of the primary applicants
balance_s= [] #Array to store the balances of the secondary applicants
balance_t= [] #Array to store the balances of the tertiary applicants
balance_n= [] #Array to store the balances of the applicants with no particular education status
loan_yp=0 #Variable to count the total number of loan approvals of primary applicants
loan_ys=0 #Variable to count the total number of loan approvals of secondary applicants
loan_yt=0 #Variable to count the total number of loan approvals of tertiary applicants
loan_yn=0 #Variable to count the total number of loan approvals of applicants with no particular education status

#A loop for calculating all the necessary data 
while (size>=0):
	size=size-1

	#Condition to calculate all the required details of primary applicants
	if education_type[size]=='primary':
		balance_p.append(float(balance[size]))
		count_p = count_p + 1
		
		if loans[size]=='yes':
			loan_yp=loan_yp+1


	#Condition to calculate all the required details of secondary applicants
	if education_type[size]=='secondary':
		balance_s.append(float(balance[size]))
		count_s = count_s + 1

		if loans[size]=='yes':
			loan_ys=loan_ys+1


    #Condition to calculate all the required details of tertiary applicants
	if education_type[size]=='tertiary':
		balance_t.append(float(balance[size]))
		count_t = count_t + 1

		if loans[size]=='yes':
			loan_yt=loan_yt+1
		

    #Condition to calculate all the required details of applicants with no particular education status
	if not education_type[size]:
		balance_n.append(float(balance[size]))
		count_n = count_n + 1

		if loans[size]=='yes':
			loan_yn=loan_yn+1
		
# A variable for cross-checking the total number of applicants
total=count_p+count_s+count_t+count_n 

# Print commands for all the values 
print('Total Number of Applicants with Primary Education = ',count_p)
print("Maximum balance of Primary education applicant = ",max(balance_p))
print("Minimum balance of Primary education applicant = ",min(balance_p))
print('Average Balance of Applicants with Primary Education = ',sum(balance_p)/len(balance_p))
print('Number of Primary education applicants with loans approved = ',loan_yp)
print('Number of Primary education applicants with loans rejected = ',(count_p-loan_yp))
print('The probability of Primary education applicants for loan being approved = ',(float(loan_yp)/float(count_p)))

print('Total Number of Applicants with Secondary Education = ',count_s)
print("Maximum balance of Secondary education applicant = ",max(balance_s))
print("Minimum balance of Secondary education applicant = ",min(balance_s))
print('Average Balance of Applicants with Secondary Education = ',sum(balance_s)/len(balance_s))
print('Number of Secondary education applicants with loans approved = ',loan_ys)
print('Number of Secondary education applicants with loans rejected = ',(count_s-loan_ys))
print('The probability of Secondary education applicants for loan being approved = ',(float(loan_ys)/float(count_s)))

print('Total Number of Applicants with Tertiary Education = ',count_t)
print("Maximum balance of Tertiary education applicant = ",max(balance_t))
print("Minimum balance of Tertiary education applicant = ",min(balance_t))
print('Average Balance of Applicants with Tertiary Education = ',sum(balance_t)/len(balance_t))
print('Number of Tertiary education applicants with loans approved = ',loan_yt)
print('Number of Tertiary education applicants with loans rejected = ',(count_t-loan_yt))
print('The probability of Tertiary education applicants for loan being approved = ',(float(loan_yt)/float(count_t)))

print('Total Number of Applicants with no particular Educational Specifications = ',count_n)
print("Maximum balance of Applicants with no particular Educational Specifications = ",max(balance_n))
print("Minimum balance of Applicants with no particular Educational Specifications = ",min(balance_n))
print('Average Balance of Applicants with no particular Educational Specifications = ',sum(balance_n)/len(balance_n))
print('Number of no particular Educational Specifications applicants with loans approved = ',loan_yn)
print('Number of no particular Educational Specifications applicants with loans rejected = ',(count_n-loan_yn))
print('The probability of no particular Educational Specifications applicants for loan being approved = ',(float(loan_yn)/float(count_n)))

print('Total Number of applicants = ',total)


# Function to write the output into the csv file for getting output in the required tabular form
with open('output.csv', 'wb') as csvfile:
    filewriter = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    filewriter.writerow(['Education', 'No. of Applicants', 'Maximum Balance', 'Minimum Balance', 'Average Balance', 
    	                 'Total Loan Approval Count', 'Total Loan Rejection Count', 'Loan Approval probability'])
    
    filewriter.writerow(['Primary', count_p, max(balance_p), min(balance_p), sum(balance_p)/len(balance_p), loan_yp, (count_p-loan_yp),
    					 float(loan_yp)/float(count_p) ])
    
    filewriter.writerow(['Secondary', count_s, max(balance_s), min(balance_s), sum(balance_s)/len(balance_s), loan_ys, (count_s-loan_ys),
    					 float(loan_ys)/float(count_s)])
    
    filewriter.writerow(['Tertiary', count_t, max(balance_t), min(balance_t), sum(balance_t)/len(balance_t), loan_yt, (count_t-loan_yt),
    					 float(loan_yt)/float(count_t)])
    
    filewriter.writerow(['No Particular Education', count_n, max(balance_n), min(balance_n), sum(balance_n)/len(balance_n), loan_yn, (count_n-loan_yn),
    					 float(loan_yn)/float(count_n)])