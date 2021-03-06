# Preventing Adverse Drug Events (ADEs) with Stored Programs

In this assignment, you’ll extend the toy EMR (Electronic Medical Record) system database demonstrated in class with additional features primarily aimed at identifying Adverse Drug Events - also known as ADEs. These might occur if a drug is improperly prescribed, or if two drugs taken together have an unintended and possibly serious side-effect (also known as a drug-drug interaction). Over two million ADEs are reported annually resulting in more than 100,000 deaths, so avoiding ADEs is a major healthcare priority. 

1. Open the ade_setup.sql script in a ROOT connection and run it to build a new database called ade.

2. Open ade_start.sql. This is the starting point for your assignment. Inside you will find an outline for a stored procedure and a trigger that you will fully implement and test.

3. Implement the stored procedure called prescribe. This procedure adds a new prescription record. It takes the parameters: Patient Name, Doctor’s Name, Medication Name, and # Pills prescribed per day. The date assigned will be the current date and time. For the prescription to be accepted, the patient must meet the guidelines of the medication:
• If patient is under 12 years old and the medication isn’t indicated for children under 12, reject the prescription with the following error message: <medication_name> cannot be prescribed to children under 12.
• If the patient is pregnant, don’t allow a prescription for a medication that shouldn’t be taken when pregnant. Reject the prescription with the following message:
<medication_name> cannot be prescribed to pregnant women.
• If dosage exceeds maximum, reject the prescription with the following message: Maximum dosage for <medication_name> is <X> pills per day for patient
<patient_name>. When computing the maximum number of pills allowed, be sure to round down to a whole (integer) number of pills using the FLOOR function.
• If you detect a potential drug interaction, reject the prescription with the following error message: <medication_name> interacts with <current_medication> currently
prescribed to <patient_name>. 

4. Add a trigger that responds to a patient becoming pregnant. It should add a recommendation: “Take pre-natal vitamins”. If the patient is currently taking any
medications that shouldn’t be taken when pregnant, automatically delete these prescriptions. Once the patient is no longer pregnant, remove the pre-natal vitamin
recommendation. You don’t need to add back in any deleted prescriptions.

5. At the bottom of the ade_start.sql script you will find some test cases to help you validate your code. Don’t change these. The TAs will use these for grading.

6. Here are a few guidelines in anticipation of some questions you might have: 
• You stored procedure implementation doesn’t have to validate your input parameters.
• You don’t have to handle the exception – just signal it and allow the error message to be reported, halting the execution of the stored procedure.
• In checking for excessive dosage, you don’t have to take into account what might already be prescribed to the patient. It is sufficient just to consider the parameters of
the prescription itself.
