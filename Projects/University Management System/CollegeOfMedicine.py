from University import University

class CollegeOfMedicine(University):
    def __init__(self):
        super().__init__(
            "College Of Medicine",
            ["Biology", "Anatomy"],
            3000,
            2,
            95
        )

    def add_student(self, student):
        if not self.check_capacity():
            raise ValueError("College is Full")
                
        if not self.is_eligible(student):
            raise ValueError("Student does not meet requirements")
        
        if student.get_id() in self._students:
            raise ValueError("Student already exists")
        
        self._students[student.get_id()] = student