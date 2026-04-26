from Person import Person

class Student(Person):
    def __init__(self, name, national_number, age, phone, college, subjects, gpa, academic_year, high_school_grade):
        super().__init__(name, national_number, age, phone, college)
        self.__subjects = subjects
        self.__gpa = gpa
        self.__academic_year = academic_year
        self.__high_school_grade = high_school_grade

    def get_high_school_grade(self):
        return self.__high_school_grade
    
    def set_gpa(self, gpa):
        self.__gpa = gpa
    
    def get_gpa(self):
        return self.__gpa
    
    def get_national_number(self):
        return self._national_number

    def get_phone(self):
        return self._phone

    def display_info(self):
        print(f"""
Name: {self._name}
ID: {self._id}
National Number: {self._national_number}
Age: {self._age}
Phone: {self._phone}
College: {self._college}
Year: {self.__academic_year}
Subjects: {self.__subjects}
GPA: {self.__gpa}
""")

    def update_info(self, phone=None, subjects=None):
        if phone is not None:
            self._phone = phone

        if subjects is not None:
            if not isinstance(subjects, list):
                raise ValueError("Subjects must be a list")
            self.__subjects = subjects