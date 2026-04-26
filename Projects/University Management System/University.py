from abc import ABC, abstractmethod

class University(ABC):
    # Info about College 
    def __init__(self, college_name, college_subjects, subject_price, college_no_of_students, min_grade):
        self._college_name = college_name
        self._college_subjects = college_subjects
        self._college_price = subject_price
        self._college_no_of_students = college_no_of_students
        self._students = {}
        self._min_grade = min_grade

    # Check Capacity
    def check_capacity(self):
        return self.get_students_count() < self._college_no_of_students

    def get_capacity(self):
        return self._college_no_of_students

    def get_students_count(self):
        return len(self._students)

    # Student Management
    def find_student(self, student_id):
        return self._students.get(student_id)

    @abstractmethod
    def add_student(self, student):
        pass

    def remove_student(self, student_id):
        if student_id in self._students:
            del self._students[student_id]
        else:
            raise ValueError("Student not found")

    def get_students(self):
        return self._students.copy()

    def calc_gpa(self, final_degree, midterm_degree, quizzes_degree, attend_degree, subjects, hours):

        if not (len(final_degree) == len(midterm_degree) == len(quizzes_degree) == len(attend_degree) == len(subjects) == len(hours)):
            raise ValueError("All lists must have the same length")

        total_points = 0
        total_hours = 0

        for i in range(len(subjects)):
            total_degree =  (final_degree[i] * 0.5) + \
                            (midterm_degree[i] * 0.2) + \
                            (quizzes_degree[i] * 0.2) + \
                            (attend_degree[i] * 0.1)

            if total_degree >= 90:
                gpa = 4.0
            elif total_degree >= 80:
                gpa = 3.0
            elif total_degree >= 70:
                gpa = 2.0
            elif total_degree >= 60:
                gpa = 1.0
            else:
                gpa = 0.0

            total_points += gpa * hours[i]
            total_hours += hours[i]

        if total_hours == 0:
            return 0

        return total_points / total_hours

    
    # Caclulate AVerage of student's grades
    def avg(self):
        if not self._students:
            return 0
        
        total = 0

        for student in self._students.values():
            total += student.get_gpa()

        return total / len(self._students)
    
    def is_eligible(self, student):
        return student.get_high_school_grade() >= self._min_grade

    # getters
    def get_name(self):
        return self._college_name
    
    def get_subjects(self):
        return self._college_subjects
    
    def get_min_grade(self):
        return self._min_grade

    def get_price(self):
        return self._college_price

    def __str__(self):
        return (
            f"Name of College: {self._college_name}\n"
            f"Capacity: {self._college_no_of_students}\n"
            f"Subjects: {self._college_subjects}\n"
            f"Price Per Subject: {self._college_price}\n"
            f"Min Grade: {self._min_grade}"
        )
