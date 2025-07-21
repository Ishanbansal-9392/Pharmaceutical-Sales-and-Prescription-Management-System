Developed a pharmaceutical inventory and prescription management system using SQL, featuring 10+ relational tables, advanced queries, triggers, and stored procedures to automate sales tracking, billing, stock alerts, and ensure data integrity.
**Tools Used:** MySQL

**Project Overview:**
Designed and implemented a comprehensive relational database system for a pharmaceutical environment to manage medicines, prescriptions, doctors, patients, suppliers, and sales data. The goal was to automate critical operations like prescription tracking, stock monitoring, sales recording, and restock alert generation through efficient SQL design, queries, triggers, and stored procedures.

**Key Features & Responsibilities:**
**Database Design:**
Created 10+ interrelated tables (medicines, patients, doctors, sales, prescriptions, etc.) with appropriate primary and foreign key constraints to ensure data integrity.
Normalized the schema to avoid redundancy and improve query performance.

**Data Manipulation & Queries:**
Wrote complex SQL queries to extract insights, such as:
Top-selling medicines
Revenue per product
Medicines never sold or prescribed
Doctor-wise patient counts
Sales trends by city and date
Performed operations to detect expired medicines, low stock items, and high-frequency prescriptions.

**Triggers:
Created triggers to:**
Automatically update stock levels after a sale.
Log restock alerts when inventory drops below a threshold.
Update the last prescribed date of medicines.

**Stored Procedures:
Developed reusable stored procedures to:**
Add new prescriptions involving multiple medicines.
Generate patient bills with line items and totals.
Summarize doctor-patient interactions.
Move expired medicines to a log table for historical tracking.
Generate category-based sales reports for any date range.

**Advanced Operations:**
Implemented business logic to detect:
Patients buying unprescribed medicines
Doctors with the most prescriptions
Prescriptions containing more than 3 medicines
Medicines prescribed but never sold (and vice versa)

**Outcome & Impact:**
Built a scalable, relational system to simulate real-world pharmacy operations.
Automated critical business workflows like restocking, billing, and sales tracking using SQL triggers and procedures.
Enabled comprehensive data analysis and reporting for better business decisions in pharmaceutical retail.
