import tkinter as tk
from tkinter import messagebox

from CollegeOfEngineering import CollegeOfEngineering
from CollegeOfMedicine import CollegeOfMedicine
from CollegeOfAI import CollegeOfAI
from Student import Student

# DATA
colleges = [
    CollegeOfEngineering(),
    CollegeOfMedicine(),
    CollegeOfAI()
]

selected_college = None
student_grade = None

# ROOT (hidden at start)
root = tk.Tk()
root.title("College System")
root.geometry("500x500")
root.configure(bg="#f0f4f7")

root.withdraw()

# FUNCTIONS

def check_colleges():
    global student_grade, selected_college
    try:
        selected_college = None
        student_grade = float(grade_entry.get())
        listbox.delete(0, tk.END)

        found = False
        for col in colleges:
            if student_grade >= col.get_min_grade():
                listbox.insert(tk.END, col.get_name())
                found = True

        if not found:
            messagebox.showinfo(
                "Result",
                "Your grade does not meet the requirements of any college"
            )

    except:
        messagebox.showerror("Error", "Enter valid grade")


def return_to_main_menu(window=None):
    global selected_college
    selected_college = None
    grade_entry.delete(0, tk.END)
    listbox.delete(0, tk.END)
    root.withdraw()

    if window is not None and window is not root and window.winfo_exists():
        window.destroy()

    main_menu()


def select_college():
    global selected_college
    try:
        selected_college = None

        if listbox.size() == 0:
            raise ValueError("No colleges available. Please check the grade first")

        if not listbox.curselection():
            raise ValueError("Please select a college first")

        index = listbox.curselection()[0]
        name = listbox.get(index)

        for col in colleges:
            if col.get_name() == name:
                selected_college = col
                break

        if selected_college is None:
            raise ValueError("Selected college not found")

        if not selected_college.check_capacity():
            raise ValueError("This college is full, please choose another college")

        root.withdraw()
        open_registration()

    except Exception as e:
        messagebox.showerror("Error", str(e))


# REGISTRATION
def open_registration():
    reg = tk.Toplevel()
    reg.title("Student Registration")
    reg.geometry("400x400")
    reg.configure(bg="#f0f4f7")

    def field(label):
        tk.Label(reg, text=label, bg="#f0f4f7", font=("Arial", 11)).pack(pady=(8, 2))
        e = tk.Entry(reg)
        e.pack()
        return e

    name = field("Name")
    national = field("National ID")
    age = field("Age")
    phone = field("Phone")

    def next_step():
        try:
            name_val = name.get().strip()

            name_clean = name_val.replace(" ", "")
            if not name_clean.isalpha():
                raise ValueError("Name must contain only letters and spaces")

            if not (national.get().isdigit() and len(national.get()) == 14):
                raise ValueError("National ID must be 14 digits")

            national_val = national.get()

            # age
            if not age.get().isdigit():
                raise ValueError("Age must be a number")

            age_val = int(age.get())
            if age_val < 18:
                raise ValueError("Age must be at least 18")

            # phone
            if not (phone.get().isdigit() and len(phone.get()) == 11):
                raise ValueError("Phone must be 11 digits")

            phone_val = phone.get()

            for col in colleges:
                for s in col.get_students().values():

                    if s.get_national_number() == national_val:
                        raise ValueError("This National ID is already registered")

                    if s.get_phone() == phone_val:
                        raise ValueError("This phone number is already registered")

            reg.destroy()

            open_subjects(
                name_val,
                national_val,
                age_val,
                phone_val
            )

        except Exception as e:
            messagebox.showerror("Error", str(e))

    tk.Button(
        reg,
        text="Next",
        bg="#2196F3",
        fg="white",
        font=("Arial", 12, "bold"),
        command=next_step
    ).pack(pady=20)

    tk.Button(
        reg,
        text="Back To Main Menu",
        bg="#9E9E9E",
        fg="white",
        font=("Arial", 11, "bold"),
        command=lambda: return_to_main_menu(reg)
    ).pack(pady=5)


# SUBJECTS
def open_subjects(name, national, age, phone):
    win = tk.Toplevel()
    win.title("Subjects & Payment")
    win.geometry("400x400")
    win.configure(bg="#f0f4f7")

    tk.Label(
        win,
        text="Select Subjects",
        font=("Arial", 16, "bold"),
        bg="#f0f4f7"
    ).pack(pady=15)

    frame = tk.Frame(win, bg="#f0f4f7")
    frame.pack(pady=10)

    vars = []

    for s in selected_college.get_subjects():
        v = tk.IntVar()
        chk = tk.Checkbutton(
            frame,
            text=s,
            variable=v,
            font=("Arial", 12),
            bg="#f0f4f7"
        )
        chk.pack(anchor="w", pady=5)
        vars.append((s, v))

    total_label = tk.Label(
        win,
        text="",
        font=("Arial", 12),
        bg="#f0f4f7"
    )
    total_label.pack(pady=10)

    def calculate():
        selected = [s for s, v in vars if v.get() == 1]

        if not selected:
            messagebox.showerror("Error", "Select subjects first")
            return

        total = len(selected) * selected_college.get_price()
        total_label.config(text=f"Total Fees: {total} EGP")

    def pay():
        try:
            selected = [s for s, v in vars if v.get() == 1]

            if not selected:
                raise ValueError("Select subjects")

            for col in colleges:
                for s in col.get_students().values():

                    if s.get_national_number() == national:
                        raise ValueError("This National ID is already registered")

                    if s.get_phone() == phone:
                        raise ValueError("This phone number is already registered")

            student = Student(
                name,
                national,
                age,
                phone,
                selected_college,
                selected,
                0.0,
                1,
                student_grade
            )

            selected_college.add_student(student)

            messagebox.showinfo("Success", "Registration Completed Successfully")

            win.destroy()
            main_menu()

        except Exception as e:
            messagebox.showerror("Error", str(e))

    tk.Button(
        win,
        text="Calculate Fees",
        bg="#FFC107",
        font=("Arial", 11, "bold"),
        command=calculate
    ).pack(pady=5)

    tk.Button(
        win,
        text="Pay Fees",
        bg="#4CAF50",
        fg="white",
        font=("Arial", 12, "bold"),
        command=pay
    ).pack(pady=10)

    tk.Button(
        win,
        text="Back To Main Menu",
        bg="#9E9E9E",
        fg="white",
        font=("Arial", 11, "bold"),
        command=lambda: return_to_main_menu(win)
    ).pack(pady=5)

# DOCTOR PANEL
def doctor_dashboard():
    win = tk.Toplevel()
    win.title("Doctor Panel")
    win.geometry("550x500")

    tk.Label(win, text="Students List",
                font=("Arial", 14, "bold")).pack(pady=5)

    listbox_doc = tk.Listbox(win, width=60, height=12, font=("Arial", 11))
    listbox_doc.pack(pady=10)

    all_students = []

    def load_students():
        listbox_doc.delete(0, tk.END)
        all_students.clear()

        for col in colleges:
            for student in col.get_students().values():
                all_students.append(student)

                listbox_doc.insert(tk.END, student.get_name())
                listbox_doc.insert(
                    tk.END,
                    f"   ID: {student.get_id()} | GPA: {student.get_gpa()}"
                )
                listbox_doc.insert(tk.END, "----------------------")

        if not all_students:
            messagebox.showinfo("Info", "No students available")

    def update_gpa():
        try:
            if not listbox_doc.curselection():
                raise ValueError("Select a student")

            new_gpa = float(entry.get())

            if not (0 <= new_gpa <= 4):
                raise ValueError("Invalid GPA")

            index = listbox_doc.curselection()[0]
            student = all_students[index // 3]

            student.set_gpa(new_gpa)

            messagebox.showinfo("Success", "Updated successfully")
            load_students()

        except Exception as e:
            messagebox.showerror("Error", str(e))

    tk.Label(win, text="Enter New GPA (0 - 4):").pack()

    entry = tk.Entry(win)
    entry.pack()

    tk.Button(win, text="Load Students", command=load_students).pack(pady=5)
    tk.Button(win, text="Update GPA", command=update_gpa).pack(pady=5)
    tk.Button(
        win,
        text="Back To Main Menu",
        command=lambda: return_to_main_menu(win)
    ).pack(pady=10)


# MENU
def main_menu():
    menu = tk.Toplevel()
    menu.title("Choose User")
    menu.geometry("300x200")

    tk.Label(menu, text="Choose User Type",
                font=("Arial", 14, "bold")).pack(pady=20)

    tk.Button(menu, text="Student",
                width=20,
                command=lambda: [menu.destroy(), root.deiconify()]
                ).pack(pady=10)

    tk.Button(menu, text="Doctor",
                width=20,
                command=lambda: [menu.destroy(), doctor_dashboard()]
                ).pack(pady=10)


# MAIN UI (Student)
tk.Label(root, text="College Admission System",
            font=("Arial", 18, "bold"),
            bg="#f0f4f7").pack(pady=10)

tk.Label(root, text="Enter High School Grade",
            font=("Arial", 12),
            bg="#f0f4f7").pack()

grade_entry = tk.Entry(root, font=("Arial", 12))
grade_entry.pack(pady=5)

tk.Button(root, text="Check Colleges",
            command=check_colleges).pack(pady=10)

listbox = tk.Listbox(root, width=40, height=6, font=("Arial", 12))
listbox.pack(pady=10)

tk.Button(root, text="Select College",
            command=select_college).pack(pady=10)

tk.Button(root, text="Back To Main Menu",
            command=lambda: return_to_main_menu(root)).pack(pady=5)

# START APP
main_menu()
root.mainloop()
