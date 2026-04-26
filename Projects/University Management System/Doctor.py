from Person import Person

class Doctor(Person):
    def __init__(self, name, national_number, age, phone, college, salary, subjects):
        super().__init__(name, national_number, age, phone, college)
        self.__salary = salary
        self.__subjects = subjects


    def display_info(self):
        print(f"""
Name: {self._name}
National Number: {self._national_number}
ID: {self._id}
Age: {self._age}
Phone: {self._phone}
College: {self._college}
Salary: {self.__salary}
Subjects: {self.__subjects}
""")
        
    def update_info(self, phone=None, subjects=None):
        if phone is not None:
            self._phone = phone

        if subjects is not None:
            if not isinstance(subjects, list):
                raise ValueError("Subjects must be a list")
            self.__subjects = subjects

    # Modify student grades
    def modify_student_grades(self, student, new_gpa):
        if not hasattr(student, "set_gpa"):
            raise ValueError("Invalid student object")
        
        student.set_gpa(new_gpa)


