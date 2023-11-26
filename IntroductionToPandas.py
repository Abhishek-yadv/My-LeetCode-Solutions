##########################################
######## #*(Create-a-DataFrame-from-list)
# a.Questions (Create-a-DataFrame-from-list): Write a solution to create a DataFrame from a 2D list called student_data. This 2D list contains the IDs and ages of some students.
import pandas as pd
def create_dataframe(student_data):
    return pd.DataFrame(student_data, columns = ['student_id', 'age'])


########################################
################## # *(Data Inspection)
# a.Questions (Get the Size of a DataFrame): Write a solution to calculate and display the number of rows and columns of players.
    df = pd.DataFrame(players)
    return list(df.shape)

# b.Questions (Display the First Three Rows): Write a solution to calculate and display the number of rows and columns of players.
def selectFirstRows(employees: pd.DataFrame) -> pd.DataFrame:
    results = employees.head(3)
    return results


#######################################
################## # *(Data Selecting)
# a.Questions (Select Data): Write a solution to select the name and age of the student with student_id = 101.
def selectData(students: pd.DataFrame) -> pd.DataFrame:
    # return students.query('student_id == 101')[['name','age']]
    # return students[students['student_id'] == 101][['name','age']]
    return students.loc[students['student_id'] == 101, ['name', 'age']]


# b.Questions (Create a New Column): Write a solution to create a new column name bonus that contains the doubled values of the salary column.
def createBonusColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees['salary']*2
    return employees


#######################################
################## # *(Data Cleaning)
# a.Questions (Drop Duplicate Rows): Write a solution to remove these duplicate rows and keep only the first occurrence.
def dropDuplicateEmails(customers: pd.DataFrame) -> pd.DataFrame:
    return customers[~customers['email'].duplicated()]
    # return df.drop_duplicates(subset=['email'])

# b.Questions (Drop Missing Data): Write a solution to remove the rows with missing values.The result format is in the following example.
def dropMissingData(students: pd.DataFrame) -> pd.DataFrame:
    # result = students[~pd.isna(students['name'])]
    # result = students[~pd.isnull(students['name'])]
    # result = students[~students['name'].isna()]
    # result = students[~students['name'].isnull()]
    # result = students[students['name'].notna()]
    result = students[students['name'].notnull()]
    return result

# c.Questions (Modify Columns): Write a solution to modify the salary column by multiplying each salary by 2.
def modifySalaryColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['salary'] = employees['salary'].apply(lambda x: x * 2)
    employees['salary'] = employees['salary'] * 2
    return employees


# d.Questions (Rename Columns): Write a solution to modify the salary column by multiplying each salary by 2.
def renameColumns(students: pd.DataFrame) -> pd.DataFrame:
    students.rename(columns={'id': 'student_id', 'first': 'first_name',
                    'last': 'last_name', 'age': 'age_in_years'}, inplace=True)
    return students
"""strg = "id to student_id first to first_name last to last_name age to age_in_years"
m = [st for st in strg.split() if st != 'to']
my_dict = dict(zip(m[::2], m[1::2]))
print(my_dict) """

# e.Questions (Change Data Type): Write a solution to correct the errors: The grade column is stored as floats, convert it to integers.
def changeDatatype(students: pd.DataFrame) -> pd.DataFrame:
    students['grade'] = students['grade'].astype(int)
    return students


# 2nd method
def changeDatatype(students: pd.DataFrame) -> pd.DataFrame:
    students['grade'] = pd.to_numeric(students['grade'], errors='coerce')
    return students


# f.Questions (Fill Missing Data): Write a solution to fill in the missing value as 0 in the quantity column.
def fillMissingValues(products: pd.DataFrame) -> pd.DataFrame:
    products['quantity'].fillna(0, inplace=True)
    return products


########################################
################## # *(Table Reshaping)
# a.Questions (Table Reshaping): Write a solution to concatenate these two DataFrames vertically into one DataFrame.
def concatenateTables(df1: pd.DataFrame, df2: pd.DataFrame) -> pd.DataFrame:
    result = pd.concat([df1, df2])
    return result

# b.Questions (Reshape Data: Pivot): Write a solution to pivot the data so that each row represents temperatures for a specific month, and each city is a separate column.
def pivotTable(weather: pd.DataFrame) -> pd.DataFrame:
    return weather.pivot_table(columns = 'city',index='month', values = 'temperature', aggfunc='max')


# c.Questions (Reshape Data: Melt): Write a solution to reshape the data so that each row represents sales data for a product in a specific quarter.
def meltTable(report: pd.DataFrame) -> pd.DataFrame:
    return report.melt(id_vars = ['product'], var_name = 'quarter', value_name = 'sales' )


############################################
################## # *(Advanced Techniques)
def findHeavyAnimals(animals: pd.DataFrame) -> pd.DataFrame:
    return animals[animals['weight'] > 100].sort_values(by='weight', ascending=False)[['name']]

# 2nd method by using query
def findHeavyAnimals(animals: pd.DataFrame) -> pd.DataFrame:
    return animals.query('weight > 100').sort_values(by='weight', ascending=False)[['name']]
