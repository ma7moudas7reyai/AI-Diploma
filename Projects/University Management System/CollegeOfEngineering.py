from University import University

class CollegeOfEngineering(University):
    def __init__(self):
        super().__init__(
            "College Of Engineering",
            ["Math", "Physics"],
            2000,
            3,
            90
        )


    def add_student(self, student):
        if not self.check_capacity():
            raise ValueError("College is Full")
                
        if not self.is_eligible(student):
            raise ValueError("Student does not meet requirements")
        
        if student.get_id() in self._students:
            raise ValueError("Student already exists")
        
        self._students[student.get_id()] = student
