from abc import ABC, abstractmethod

class Person(ABC):
    _id_counter = 1
    def __init__(self, name, national_number, age, phone, college):
        self._id = Person._id_counter
        Person._id_counter += 1

        if age < 0:
            raise ValueError("Age cannot be negative")
        
        self._name = name
        self._national_number = national_number
        self._age = age
        self._phone = phone
        self._college = college

    def get_id(self):
        return self._id

    def get_name(self):
        return self._name
    
    @abstractmethod
    def display_info(self):
        pass
    
    @abstractmethod
    def update_info(self, phone = None):
        pass

    def __str__(self):
        return f"Name: {self._name}, ID: {self._id}, Age: {self._age}, Phone: {self._phone}"
