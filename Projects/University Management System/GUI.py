import tkinter as tk
from tkinter import messagebox, ttk

from CollegeOfAI import CollegeOfAI
from CollegeOfEngineering import CollegeOfEngineering
from CollegeOfMedicine import CollegeOfMedicine
from Doctor import Doctor
from Student import Student


COLORS = {
    "bg": "#111827",
    "surface": "#1f2937",
    "surface_2": "#273449",
    "text": "#f9fafb",
    "muted": "#cbd5e1",
    "primary": "#22d3ee",
    "primary_dark": "#0891b2",
    "success": "#34d399",
    "warning": "#fbbf24",
    "danger": "#fb7185",
    "border": "#475569",
    "card_blue": "#123047",
    "card_green": "#12382d",
    "card_purple": "#2b2146",
    "card_gold": "#3b2f17",
}

FONT = "Segoe UI"


class UniversityApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("University Management System")
        self.geometry("1180x760")
        self.minsize(1080, 680)
        self.configure(bg=COLORS["bg"])

        self.colleges = [
            CollegeOfEngineering(),
            CollegeOfMedicine(),
            CollegeOfAI(),
        ]
        self.doctors = [
            Doctor("Dr. Omar Hassan", "29901011234567", 45, "01012345678", self.colleges[0], 18000, self.colleges[0].get_subjects()),
            Doctor("Dr. Salma Adel", "28802021234567", 50, "01112345678", self.colleges[1], 26000, self.colleges[1].get_subjects()),
            Doctor("Dr. Karim Nabil", "29203031234567", 42, "01212345678", self.colleges[2], 22000, self.colleges[2].get_subjects()),
        ]

        self.selected_college = None
        self.subject_vars = {}
        self.student_row_ids = []
        self.grade_entries = {}

        self._configure_styles()
        self._build_layout()
        self.refresh_all()

    def _configure_styles(self):
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure(".", font=(FONT, 10), background=COLORS["bg"], foreground=COLORS["text"])
        style.configure("TFrame", background=COLORS["bg"])
        style.configure("Surface.TFrame", background=COLORS["surface"])
        style.configure("Soft.TFrame", background=COLORS["surface_2"])
        style.configure("MetricBlue.TFrame", background=COLORS["card_blue"])
        style.configure("MetricGreen.TFrame", background=COLORS["card_green"])
        style.configure("MetricPurple.TFrame", background=COLORS["card_purple"])
        style.configure("MetricGold.TFrame", background=COLORS["card_gold"])
        style.configure("TLabel", background=COLORS["bg"], foreground=COLORS["text"])
        style.configure("Surface.TLabel", background=COLORS["surface"], foreground=COLORS["text"])
        style.configure("Muted.TLabel", background=COLORS["surface"], foreground=COLORS["muted"])
        style.configure("MetricBlueMuted.TLabel", background=COLORS["card_blue"], foreground=COLORS["muted"])
        style.configure("MetricGreenMuted.TLabel", background=COLORS["card_green"], foreground=COLORS["muted"])
        style.configure("MetricPurpleMuted.TLabel", background=COLORS["card_purple"], foreground=COLORS["muted"])
        style.configure("MetricGoldMuted.TLabel", background=COLORS["card_gold"], foreground=COLORS["muted"])
        style.configure("Title.TLabel", font=(FONT, 22, "bold"), background=COLORS["bg"], foreground=COLORS["text"])
        style.configure("Section.TLabel", font=(FONT, 13, "bold"), background=COLORS["surface"], foreground=COLORS["text"])
        style.configure("Metric.TLabel", font=(FONT, 20, "bold"), background=COLORS["surface"], foreground=COLORS["text"])
        style.configure("MetricBlue.TLabel", font=(FONT, 20, "bold"), background=COLORS["card_blue"], foreground=COLORS["primary"])
        style.configure("MetricGreen.TLabel", font=(FONT, 20, "bold"), background=COLORS["card_green"], foreground=COLORS["success"])
        style.configure("MetricPurple.TLabel", font=(FONT, 20, "bold"), background=COLORS["card_purple"], foreground="#c4b5fd")
        style.configure("MetricGold.TLabel", font=(FONT, 20, "bold"), background=COLORS["card_gold"], foreground=COLORS["warning"])
        style.configure("TButton", font=(FONT, 10, "bold"), padding=(12, 8), borderwidth=0)
        style.map("TButton", background=[("active", COLORS["border"])])
        style.configure("Primary.TButton", background=COLORS["primary"], foreground=COLORS["bg"])
        style.map("Primary.TButton", background=[("active", COLORS["primary_dark"])])
        style.configure("Success.TButton", background=COLORS["success"], foreground=COLORS["bg"])
        style.configure("Warning.TButton", background=COLORS["warning"], foreground=COLORS["bg"])
        style.configure("Danger.TButton", background=COLORS["danger"], foreground="white")
        style.configure("TNotebook", background=COLORS["bg"], borderwidth=0)
        style.configure("TNotebook.Tab", font=(FONT, 10, "bold"), padding=(18, 10), background=COLORS["surface_2"])
        style.map("TNotebook.Tab", background=[("selected", COLORS["surface"])], foreground=[("selected", COLORS["primary"])])
        style.configure("Treeview", rowheight=31, fieldbackground=COLORS["surface"], background=COLORS["surface"], foreground=COLORS["text"], bordercolor=COLORS["border"])
        style.map("Treeview", background=[("selected", COLORS["primary"])], foreground=[("selected", COLORS["bg"])])
        style.configure("Treeview.Heading", font=(FONT, 10, "bold"), background=COLORS["surface_2"], foreground=COLORS["text"])
        style.configure("TEntry", padding=7, fieldbackground=COLORS["surface_2"], foreground=COLORS["text"], insertcolor=COLORS["text"], bordercolor=COLORS["border"])
        style.configure("TCombobox", padding=7, fieldbackground=COLORS["surface_2"], background=COLORS["surface_2"], foreground=COLORS["text"], bordercolor=COLORS["border"], arrowcolor=COLORS["primary"])
        style.configure("TLabelframe", background=COLORS["surface"], bordercolor=COLORS["border"])
        style.configure("TLabelframe.Label", font=(FONT, 11, "bold"), background=COLORS["surface"], foreground=COLORS["text"])
        style.configure("TCheckbutton", background=COLORS["surface"], foreground=COLORS["text"], padding=4)

    def _build_layout(self):
        header = ttk.Frame(self, padding=(24, 18, 24, 8))
        header.pack(fill="x")

        ttk.Label(header, text="University Management System", style="Title.TLabel").pack(anchor="w")
        ttk.Label(
            header,
            text="Admissions, student records, doctor tools, fees, capacity, and GPA calculations in one workspace.",
            foreground=COLORS["muted"],
        ).pack(anchor="w", pady=(4, 0))

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill="both", expand=True, padx=24, pady=(8, 24))

        self.overview_tab = ttk.Frame(self.notebook, padding=16)
        self.register_tab = ttk.Frame(self.notebook, padding=16)
        self.students_tab = ttk.Frame(self.notebook, padding=16)
        self.doctor_tab = ttk.Frame(self.notebook, padding=16)

        self.notebook.add(self.overview_tab, text="Overview")
        self.notebook.add(self.register_tab, text="Student Registration")
        self.notebook.add(self.students_tab, text="Student Records")
        self.notebook.add(self.doctor_tab, text="Doctor Panel")

        self._build_overview()
        self._build_registration()
        self._build_student_management()
        self._build_doctor_panel()

    def _surface(self, parent, padding=16):
        frame = ttk.Frame(parent, style="Surface.TFrame", padding=padding)
        return frame

    def _build_overview(self):
        metrics = ttk.Frame(self.overview_tab)
        metrics.pack(fill="x")

        self.total_students_value = self._metric_card(metrics, "Total Students", "0", 0)
        self.open_seats_value = self._metric_card(metrics, "Open Seats", "0", 1)
        self.avg_gpa_value = self._metric_card(metrics, "Average GPA", "0.00", 2)
        self.total_revenue_value = self._metric_card(metrics, "Collected Fees", "0 EGP", 3)

        college_box = self._surface(self.overview_tab)
        college_box.pack(fill="both", expand=True, pady=(16, 0))
        ttk.Label(college_box, text="Colleges", style="Section.TLabel").pack(anchor="w")

        columns = ("name", "subjects", "price", "min_grade", "capacity", "students", "avg")
        self.college_tree = ttk.Treeview(college_box, columns=columns, show="headings", height=10)
        headings = {
            "name": "College",
            "subjects": "Subjects",
            "price": "Subject Price",
            "min_grade": "Min Grade",
            "capacity": "Capacity",
            "students": "Students",
            "avg": "Avg GPA",
        }
        widths = {"name": 260, "subjects": 230, "price": 110, "min_grade": 90, "capacity": 90, "students": 90, "avg": 90}
        for key, title in headings.items():
            self.college_tree.heading(key, text=title)
            self.college_tree.column(key, width=widths[key], anchor="w")
        self.college_tree.pack(fill="both", expand=True, pady=(12, 0))

    def _metric_card(self, parent, title, value, column):
        variants = ("MetricBlue", "MetricGreen", "MetricPurple", "MetricGold")
        variant = variants[column % len(variants)]
        card = ttk.Frame(parent, style=f"{variant}.TFrame", padding=14)
        card.grid(row=0, column=column, sticky="ew", padx=(0 if column == 0 else 10, 0))
        parent.columnconfigure(column, weight=1)
        ttk.Label(card, text=title, style=f"{variant}Muted.TLabel").pack(anchor="w")
        label = ttk.Label(card, text=value, style=f"{variant}.TLabel")
        label.pack(anchor="w", pady=(8, 0))
        return label

    def _build_registration(self):
        left = self._surface(self.register_tab)
        left.pack(side="left", fill="both", expand=True, padx=(0, 10))
        right = self._surface(self.register_tab)
        right.pack(side="right", fill="both", expand=True, padx=(10, 0))

        ttk.Label(left, text="Admission Check", style="Section.TLabel").pack(anchor="w")
        self.grade_var = tk.StringVar()
        self._field(left, "High School Grade", self.grade_var)
        ttk.Button(left, text="Check Eligible Colleges", style="Primary.TButton", command=self.check_colleges).pack(fill="x", pady=(8, 14))

        columns = ("name", "min", "capacity", "price")
        self.eligible_tree = ttk.Treeview(left, columns=columns, show="headings", height=8)
        for key, title, width in (
            ("name", "College", 250),
            ("min", "Min", 70),
            ("capacity", "Seats", 80),
            ("price", "Price", 90),
        ):
            self.eligible_tree.heading(key, text=title)
            self.eligible_tree.column(key, width=width, anchor="w")
        self.eligible_tree.pack(fill="both", expand=True)
        self.eligible_tree.bind("<<TreeviewSelect>>", self.on_college_select)

        self.college_details_var = tk.StringVar(value="Select a college to view subjects and fees.")
        ttk.Label(left, textvariable=self.college_details_var, style="Muted.TLabel", wraplength=480, justify="left").pack(anchor="w", pady=(12, 0))

        ttk.Label(right, text="Student Information", style="Section.TLabel").pack(anchor="w")
        self.reg_name_var = tk.StringVar()
        self.reg_national_var = tk.StringVar()
        self.reg_age_var = tk.StringVar()
        self.reg_phone_var = tk.StringVar()
        self._field(right, "Full Name", self.reg_name_var)
        self._field(right, "National ID", self.reg_national_var)
        self._field(right, "Age", self.reg_age_var)
        self._field(right, "Phone", self.reg_phone_var)

        ttk.Label(right, text="Subjects", style="Section.TLabel").pack(anchor="w", pady=(16, 6))
        self.subjects_frame = ttk.Frame(right, style="Surface.TFrame")
        self.subjects_frame.pack(fill="x")
        self.fees_var = tk.StringVar(value="Fees: 0 EGP")
        ttk.Label(right, textvariable=self.fees_var, style="Muted.TLabel").pack(anchor="w", pady=(10, 0))

        buttons = ttk.Frame(right, style="Surface.TFrame")
        buttons.pack(fill="x", pady=(16, 0))
        ttk.Button(buttons, text="Calculate Fees", style="Warning.TButton", command=self.calculate_fees).pack(side="left", fill="x", expand=True, padx=(0, 6))
        ttk.Button(buttons, text="Register Student", style="Success.TButton", command=self.register_student).pack(side="left", fill="x", expand=True, padx=(6, 0))

    def _build_student_management(self):
        left = self._surface(self.students_tab)
        left.pack(side="left", fill="both", expand=True, padx=(0, 10))
        right = self._surface(self.students_tab)
        right.pack(side="right", fill="y", padx=(10, 0))

        top = ttk.Frame(left, style="Surface.TFrame")
        top.pack(fill="x")
        ttk.Label(top, text="Students", style="Section.TLabel").pack(side="left")
        ttk.Button(top, text="Refresh", command=self.refresh_all).pack(side="right")

        columns = ("id", "name", "college", "grade", "gpa", "phone")
        self.students_tree = ttk.Treeview(left, columns=columns, show="headings", height=17)
        for key, title, width in (
            ("id", "ID", 60),
            ("name", "Name", 180),
            ("college", "College", 260),
            ("grade", "HS Grade", 80),
            ("gpa", "GPA", 70),
            ("phone", "Phone", 120),
        ):
            self.students_tree.heading(key, text=title)
            self.students_tree.column(key, width=width, anchor="w")
        self.students_tree.pack(fill="both", expand=True, pady=(12, 0))
        self.students_tree.bind("<<TreeviewSelect>>", self.on_student_select)

        ttk.Label(right, text="Student Details", style="Section.TLabel").pack(anchor="w")
        self.student_details_var = tk.StringVar(value="Select a student.")
        ttk.Label(right, textvariable=self.student_details_var, style="Muted.TLabel", wraplength=320, justify="left").pack(anchor="w", pady=(8, 14))

        self.search_id_var = tk.StringVar()
        self._field(right, "Find Student By ID", self.search_id_var)
        ttk.Button(right, text="Find", style="Primary.TButton", command=self.find_student).pack(fill="x", pady=(4, 14))

        ttk.Label(
            right,
            text="Student records are read-only here. Doctors can edit or remove students from the Doctor Panel.",
            style="Muted.TLabel",
            wraplength=320,
            justify="left",
        ).pack(anchor="w", pady=(8, 0))

    def _build_doctor_student_admin(self, parent):
        ttk.Label(parent, text="Student Administration", style="Section.TLabel").pack(anchor="w", pady=(18, 0))
        self.admin_student_var = tk.StringVar()
        self.admin_student_combo = ttk.Combobox(parent, textvariable=self.admin_student_var, state="readonly")
        self.admin_student_combo.pack(fill="x", pady=(8, 0))
        self.admin_student_combo.bind("<<ComboboxSelected>>", self.on_admin_student_select)

        self.admin_student_details_var = tk.StringVar(value="Select a student to edit.")
        ttk.Label(parent, textvariable=self.admin_student_details_var, style="Muted.TLabel", wraplength=500, justify="left").pack(anchor="w", pady=(8, 0))

        self.update_phone_var = tk.StringVar()
        self._field(parent, "Update Student Phone", self.update_phone_var)
        ttk.Label(parent, text="Update Student Subjects", style="Surface.TLabel").pack(anchor="w", pady=(8, 4))
        self.manage_subjects_frame = ttk.Frame(parent, style="Surface.TFrame")
        self.manage_subjects_frame.pack(fill="x")
        self.manage_subject_vars = {}

        buttons = ttk.Frame(parent, style="Surface.TFrame")
        buttons.pack(fill="x", pady=(14, 0))
        ttk.Button(buttons, text="Update Student", style="Success.TButton", command=self.update_student).pack(side="left", fill="x", expand=True, padx=(0, 6))
        ttk.Button(buttons, text="Remove Student", style="Danger.TButton", command=self.remove_student).pack(side="left", fill="x", expand=True, padx=(6, 0))

    def _build_doctor_panel(self):
        left = self._surface(self.doctor_tab)
        left.pack(side="left", fill="both", expand=True, padx=(0, 10))
        right = self._surface(self.doctor_tab)
        right.pack(side="right", fill="both", expand=True, padx=(10, 0))

        ttk.Label(left, text="Doctor Workspace", style="Section.TLabel").pack(anchor="w")
        self.doctor_var = tk.StringVar()
        self.doctor_combo = ttk.Combobox(left, textvariable=self.doctor_var, state="readonly")
        self.doctor_combo.pack(fill="x", pady=(8, 10))
        self.doctor_combo.bind("<<ComboboxSelected>>", self.on_doctor_select)
        self.doctor_details_var = tk.StringVar()
        ttk.Label(left, textvariable=self.doctor_details_var, style="Muted.TLabel", wraplength=500, justify="left").pack(anchor="w")

        self.doctor_phone_var = tk.StringVar()
        self._field(left, "Doctor Phone", self.doctor_phone_var)
        ttk.Label(left, text="Doctor Subjects", style="Surface.TLabel").pack(anchor="w", pady=(8, 4))
        self.doctor_subjects_frame = ttk.Frame(left, style="Surface.TFrame")
        self.doctor_subjects_frame.pack(fill="x")
        self.doctor_subject_vars = {}
        ttk.Button(left, text="Update Doctor Info", style="Primary.TButton", command=self.update_doctor).pack(fill="x", pady=(14, 20))

        self._build_doctor_student_admin(left)

        ttk.Label(left, text="Manual GPA Update", style="Section.TLabel").pack(anchor="w")
        self.new_gpa_var = tk.StringVar()
        self._field(left, "New GPA (0 - 4)", self.new_gpa_var)
        ttk.Button(left, text="Apply GPA With Doctor Permission", style="Success.TButton", command=self.update_gpa_manual).pack(fill="x", pady=(8, 0))

        ttk.Label(right, text="GPA Calculator", style="Section.TLabel").pack(anchor="w")
        ttk.Label(right, text="Select a student, enter grades per subject, then calculate weighted GPA.", style="Muted.TLabel").pack(anchor="w", pady=(4, 12))
        self.gpa_student_var = tk.StringVar()
        self.gpa_student_combo = ttk.Combobox(right, textvariable=self.gpa_student_var, state="readonly")
        self.gpa_student_combo.pack(fill="x")
        self.gpa_student_combo.bind("<<ComboboxSelected>>", self.build_grade_rows)

        self.grades_frame = ttk.Frame(right, style="Surface.TFrame")
        self.grades_frame.pack(fill="both", expand=True, pady=(14, 8))
        self.calculated_gpa_var = tk.StringVar(value="Calculated GPA: --")
        ttk.Label(right, textvariable=self.calculated_gpa_var, style="Metric.TLabel").pack(anchor="w", pady=(4, 10))
        ttk.Button(right, text="Calculate And Save GPA", style="Success.TButton", command=self.calculate_and_save_gpa).pack(fill="x")

    def _field(self, parent, label, variable):
        ttk.Label(parent, text=label, style="Surface.TLabel").pack(anchor="w", pady=(10, 4))
        entry = ttk.Entry(parent, textvariable=variable)
        entry.pack(fill="x")
        return entry

    def refresh_all(self):
        self.refresh_overview()
        self.refresh_students()
        self.refresh_doctors()
        self.refresh_admin_students()
        self.refresh_gpa_students()

    def refresh_overview(self):
        total_students = sum(col.get_students_count() for col in self.colleges)
        total_capacity = sum(col.get_capacity() for col in self.colleges)
        total_revenue = 0
        gpas = []

        self.college_tree.delete(*self.college_tree.get_children())
        for col in self.colleges:
            students = list(col.get_students().values())
            total_revenue += sum(len(self._student_subjects(st)) * col.get_price() for st in students)
            gpas.extend(st.get_gpa() for st in students)
            self.college_tree.insert(
                "",
                "end",
                values=(
                    col.get_name(),
                    ", ".join(col.get_subjects()),
                    f"{col.get_price()} EGP",
                    col.get_min_grade(),
                    col.get_capacity(),
                    col.get_students_count(),
                    f"{col.avg():.2f}",
                ),
            )

        self.total_students_value.config(text=str(total_students))
        self.open_seats_value.config(text=str(total_capacity - total_students))
        self.avg_gpa_value.config(text=f"{(sum(gpas) / len(gpas)):.2f}" if gpas else "0.00")
        self.total_revenue_value.config(text=f"{total_revenue:,} EGP")

    def refresh_students(self):
        self.students_tree.delete(*self.students_tree.get_children())
        self.student_row_ids.clear()
        for col in self.colleges:
            for student in col.get_students().values():
                row_id = f"{col.get_name()}::{student.get_id()}"
                self.student_row_ids.append(row_id)
                self.students_tree.insert(
                    "",
                    "end",
                    iid=row_id,
                    values=(
                        student.get_id(),
                        student.get_name(),
                        col.get_name(),
                        student.get_high_school_grade(),
                        f"{student.get_gpa():.2f}",
                        student.get_phone(),
                    ),
                )

    def refresh_doctors(self):
        values = [f"{doctor.get_id()} - {doctor.get_name()}" for doctor in self.doctors]
        self.doctor_combo["values"] = values
        if values and not self.doctor_var.get():
            self.doctor_var.set(values[0])
            self.on_doctor_select()

    def refresh_admin_students(self):
        if not hasattr(self, "admin_student_combo"):
            return
        values = [self._student_option(student, col) for student, col in self._doctor_students()]
        current = self.admin_student_var.get()
        self.admin_student_combo["values"] = values
        if current in values:
            self.admin_student_var.set(current)
        else:
            self.admin_student_var.set("")
            self.admin_student_details_var.set("Select a student to edit.")
            self.update_phone_var.set("")
            self._render_manage_subjects([], [])

    def refresh_gpa_students(self):
        values = [self._student_option(student, col) for student, col in self._doctor_students()]
        self.gpa_student_combo["values"] = values
        if self.gpa_student_var.get() not in values:
            self.gpa_student_var.set("")
            self.clear_grade_rows()

    def check_colleges(self):
        try:
            grade = self._parse_float(self.grade_var.get(), "High school grade")
            if not 0 <= grade <= 100:
                raise ValueError("High school grade must be between 0 and 100")
        except ValueError as exc:
            messagebox.showerror("Invalid grade", str(exc))
            return

        self.eligible_tree.delete(*self.eligible_tree.get_children())
        self.selected_college = None
        self._render_subject_checks([])
        for col in self.colleges:
            if grade >= col.get_min_grade() and col.check_capacity():
                self.eligible_tree.insert(
                    "",
                    "end",
                    iid=col.get_name(),
                    values=(col.get_name(), col.get_min_grade(), f"{col.get_students_count()}/{col.get_capacity()}", f"{col.get_price()} EGP"),
                )

        if not self.eligible_tree.get_children():
            messagebox.showinfo("Admission Result", "No available college matches this grade right now.")

    def on_college_select(self, _event=None):
        selected = self.eligible_tree.selection()
        if not selected:
            return
        name = selected[0]
        self.selected_college = self._college_by_name(name)
        subjects = self.selected_college.get_subjects()
        self.college_details_var.set(
            f"{self.selected_college.get_name()} | Subjects: {', '.join(subjects)} | "
            f"Price per subject: {self.selected_college.get_price()} EGP | "
            f"Capacity: {self.selected_college.get_students_count()}/{self.selected_college.get_capacity()}"
        )
        self._render_subject_checks(subjects)
        self.calculate_fees(silent=True)

    def _render_subject_checks(self, subjects):
        for child in self.subjects_frame.winfo_children():
            child.destroy()
        self.subject_vars = {}
        for subject in subjects:
            var = tk.BooleanVar(value=True)
            ttk.Checkbutton(self.subjects_frame, text=subject, variable=var, command=lambda: self.calculate_fees(silent=True)).pack(anchor="w")
            self.subject_vars[subject] = var

    def calculate_fees(self, silent=False):
        if self.selected_college is None:
            if not silent:
                messagebox.showerror("Missing college", "Select a college first.")
            return 0
        selected = self._selected_subjects(self.subject_vars)
        total = len(selected) * self.selected_college.get_price()
        self.fees_var.set(f"Fees: {total:,} EGP")
        if not selected and not silent:
            messagebox.showerror("Missing subjects", "Select at least one subject.")
        return total

    def register_student(self):
        try:
            if self.selected_college is None:
                raise ValueError("Select an eligible college first")
            grade = self._parse_float(self.grade_var.get(), "High school grade")
            name = self._valid_name(self.reg_name_var.get())
            national = self._valid_digits(self.reg_national_var.get(), "National ID", 14)
            age = self._parse_int(self.reg_age_var.get(), "Age")
            if age < 18:
                raise ValueError("Age must be at least 18")
            phone = self._valid_digits(self.reg_phone_var.get(), "Phone", 11)
            subjects = self._selected_subjects(self.subject_vars)
            if not subjects:
                raise ValueError("Select at least one subject")
            self._check_unique_student(national, phone)

            student = Student(name, national, age, phone, self.selected_college, subjects, 0.0, 1, grade)
            self.selected_college.add_student(student)

            messagebox.showinfo("Registration Complete", f"{name} registered successfully in {self.selected_college.get_name()}.")
            self.clear_registration()
            self.refresh_all()
        except Exception as exc:
            messagebox.showerror("Registration Error", str(exc))

    def clear_registration(self):
        for var in (self.grade_var, self.reg_name_var, self.reg_national_var, self.reg_age_var, self.reg_phone_var):
            var.set("")
        self.eligible_tree.delete(*self.eligible_tree.get_children())
        self.selected_college = None
        self.college_details_var.set("Select a college to view subjects and fees.")
        self.fees_var.set("Fees: 0 EGP")
        self._render_subject_checks([])

    def on_student_select(self, _event=None):
        student, col = self._selected_student_from_tree()
        if student is None:
            return
        subjects = self._student_subjects(student)
        self.student_details_var.set(
            f"Name: {student.get_name()}\n"
            f"ID: {student.get_id()}\n"
            f"National ID: {student.get_national_number()}\n"
            f"College: {col.get_name()}\n"
            f"Subjects: {', '.join(subjects)}\n"
            f"GPA: {student.get_gpa():.2f}"
        )

    def _render_manage_subjects(self, college_subjects, selected_subjects):
        for child in self.manage_subjects_frame.winfo_children():
            child.destroy()
        self.manage_subject_vars = {}
        for subject in college_subjects:
            var = tk.BooleanVar(value=subject in selected_subjects)
            ttk.Checkbutton(self.manage_subjects_frame, text=subject, variable=var).pack(anchor="w")
            self.manage_subject_vars[subject] = var

    def on_admin_student_select(self, _event=None):
        student, col = self._student_from_admin_combo()
        if student is None:
            return
        subjects = self._student_subjects(student)
        self.admin_student_details_var.set(
            f"Name: {student.get_name()} | ID: {student.get_id()}\n"
            f"College: {col.get_name()}\n"
            f"Subjects: {', '.join(subjects)} | GPA: {student.get_gpa():.2f}"
        )
        self.update_phone_var.set(student.get_phone())
        self._render_manage_subjects(col.get_subjects(), subjects)

    def find_student(self):
        try:
            student_id = self._parse_int(self.search_id_var.get(), "Student ID")
            for col in self.colleges:
                student = col.find_student(student_id)
                if student is not None:
                    row_id = f"{col.get_name()}::{student_id}"
                    self.students_tree.selection_set(row_id)
                    self.students_tree.focus(row_id)
                    self.students_tree.see(row_id)
                    self.on_student_select()
                    return
            raise ValueError("Student not found")
        except Exception as exc:
            messagebox.showerror("Search Error", str(exc))

    def update_student(self):
        try:
            doctor = self._selected_doctor()
            student, _col = self._student_from_admin_combo()
            if doctor is None:
                raise ValueError("Select a doctor first")
            if student is None:
                raise ValueError("Select a student from Doctor Panel first")
            self._ensure_doctor_can_access_student(doctor, student)
            phone = self._valid_digits(self.update_phone_var.get(), "Phone", 11)
            subjects = self._selected_subjects(self.manage_subject_vars)
            if not subjects:
                raise ValueError("Select at least one subject")
            self._check_unique_student(student.get_national_number(), phone, ignore_student=student)
            student.update_info(phone=phone, subjects=subjects)
            self.refresh_all()
            self.on_admin_student_select()
            messagebox.showinfo("Updated", "Student information updated successfully.")
        except Exception as exc:
            messagebox.showerror("Update Error", str(exc))

    def remove_student(self):
        try:
            doctor = self._selected_doctor()
            student, col = self._student_from_admin_combo()
            if doctor is None:
                raise ValueError("Select a doctor first")
            if student is None:
                raise ValueError("Select a student from Doctor Panel first")
            self._ensure_doctor_can_access_student(doctor, student)
            if not messagebox.askyesno("Confirm Removal", f"Remove {student.get_name()} from {col.get_name()}?"):
                return
            col.remove_student(student.get_id())
            self.student_details_var.set("Select a student.")
            self.admin_student_details_var.set("Select a student to edit.")
            self.refresh_all()
        except Exception as exc:
            messagebox.showerror("Remove Error", str(exc))

    def on_doctor_select(self, _event=None):
        doctor = self._selected_doctor()
        if doctor is None:
            return
        subjects = self._doctor_subjects(doctor)
        self.doctor_details_var.set(
            f"Name: {doctor.get_name()}\n"
            f"ID: {doctor.get_id()}\n"
            f"College: {doctor._college.get_name()}\n"
            f"Subjects: {', '.join(subjects)}"
        )
        self.doctor_phone_var.set(doctor._phone)
        self._render_doctor_subjects(doctor._college.get_subjects(), subjects)
        self.refresh_admin_students()
        self.refresh_gpa_students()

    def _render_doctor_subjects(self, college_subjects, selected_subjects):
        for child in self.doctor_subjects_frame.winfo_children():
            child.destroy()
        self.doctor_subject_vars = {}
        for subject in college_subjects:
            var = tk.BooleanVar(value=subject in selected_subjects)
            ttk.Checkbutton(self.doctor_subjects_frame, text=subject, variable=var).pack(anchor="w")
            self.doctor_subject_vars[subject] = var

    def update_doctor(self):
        try:
            doctor = self._selected_doctor()
            if doctor is None:
                raise ValueError("Select a doctor first")
            phone = self._valid_digits(self.doctor_phone_var.get(), "Phone", 11)
            subjects = self._selected_subjects(self.doctor_subject_vars)
            if not subjects:
                raise ValueError("Select at least one subject")
            doctor.update_info(phone=phone, subjects=subjects)
            self.on_doctor_select()
            messagebox.showinfo("Updated", "Doctor information updated successfully.")
        except Exception as exc:
            messagebox.showerror("Doctor Update Error", str(exc))

    def update_gpa_manual(self):
        try:
            doctor = self._selected_doctor()
            student, _col = self._student_from_admin_combo()
            if doctor is None:
                raise ValueError("Select a doctor first")
            if student is None:
                raise ValueError("Select a student from Student Administration first")
            self._ensure_doctor_can_access_student(doctor, student)
            new_gpa = self._parse_float(self.new_gpa_var.get(), "GPA")
            if not 0 <= new_gpa <= 4:
                raise ValueError("GPA must be between 0 and 4")
            doctor.modify_student_grades(student, new_gpa)
            self.refresh_all()
            messagebox.showinfo("GPA Updated", f"{student.get_name()}'s GPA is now {new_gpa:.2f}.")
        except Exception as exc:
            messagebox.showerror("GPA Update Error", str(exc))

    def build_grade_rows(self, _event=None):
        self.clear_grade_rows()
        student, _col = self._student_from_combo()
        if student is None:
            return

        header = ttk.Frame(self.grades_frame, style="Surface.TFrame")
        header.pack(fill="x")
        for text, width in (("Subject", 18), ("Final /50", 9), ("Mid /20", 9), ("Quiz /20", 9), ("Attend /10", 10), ("Hours", 8)):
            ttk.Label(header, text=text, style="Surface.TLabel", width=width).pack(side="left", padx=3)

        self.grade_entries = {}
        for subject in self._student_subjects(student):
            row = ttk.Frame(self.grades_frame, style="Surface.TFrame")
            row.pack(fill="x", pady=3)
            ttk.Label(row, text=subject, style="Surface.TLabel", width=18).pack(side="left", padx=3)
            entries = {}
            for key, default in (("final", "0"), ("midterm", "0"), ("quizzes", "0"), ("attend", "0"), ("hours", "3")):
                var = tk.StringVar(value=default)
                ttk.Entry(row, textvariable=var, width=9).pack(side="left", padx=3)
                entries[key] = var
            self.grade_entries[subject] = entries

    def clear_grade_rows(self):
        for child in self.grades_frame.winfo_children():
            child.destroy()
        self.grade_entries = {}
        self.calculated_gpa_var.set("Calculated GPA: --")

    def calculate_and_save_gpa(self):
        try:
            student, col = self._student_from_combo()
            if student is None:
                raise ValueError("Select a student first")
            doctor = self._selected_doctor()
            if doctor is None:
                raise ValueError("Select a doctor first")
            self._ensure_doctor_can_access_student(doctor, student)
            if not self.grade_entries:
                raise ValueError("No subjects available for this student")

            subjects = []
            finals = []
            midterms = []
            quizzes = []
            attends = []
            hours = []
            for subject, entries in self.grade_entries.items():
                subjects.append(subject)
                finals.append(self._grade_component(entries["final"].get(), "Final", 50))
                midterms.append(self._grade_component(entries["midterm"].get(), "Midterm", 20))
                quizzes.append(self._grade_component(entries["quizzes"].get(), "Quizzes", 20))
                attends.append(self._grade_component(entries["attend"].get(), "Attendance", 10))
                hour = self._parse_float(entries["hours"].get(), "Hours")
                if hour <= 0:
                    raise ValueError("Hours must be greater than zero")
                hours.append(hour)

            gpa = col.calc_gpa(finals, midterms, quizzes, attends, subjects, hours)
            doctor.modify_student_grades(student, gpa)
            self.calculated_gpa_var.set(f"Calculated GPA: {gpa:.2f}")
            self.refresh_all()
            messagebox.showinfo("GPA Saved", f"{student.get_name()}'s GPA saved as {gpa:.2f}.")
        except Exception as exc:
            messagebox.showerror("GPA Calculation Error", str(exc))

    def _selected_student_from_tree(self):
        selected = self.students_tree.selection()
        if not selected:
            return None, None
        row_id = selected[0]
        college_name, student_id_text = row_id.split("::", 1)
        col = self._college_by_name(college_name)
        return col.find_student(int(student_id_text)), col

    def _student_from_combo(self):
        value = self.gpa_student_var.get()
        if not value:
            return None, None
        student_id = int(value.split(" - ", 1)[0])
        for col in self.colleges:
            student = col.find_student(student_id)
            if student is not None:
                return student, col
        return None, None

    def _student_from_admin_combo(self):
        value = self.admin_student_var.get()
        if not value:
            return None, None
        student_id = int(value.split(" - ", 1)[0])
        for col in self.colleges:
            student = col.find_student(student_id)
            if student is not None:
                return student, col
        return None, None

    def _student_option(self, student, col):
        return f"{student.get_id()} - {student.get_name()} ({col.get_name()})"

    def _doctor_students(self):
        doctor = self._selected_doctor()
        if doctor is None:
            return []
        college = doctor._college
        return [(student, college) for student in college.get_students().values()]

    def _ensure_doctor_can_access_student(self, doctor, student):
        if doctor._college.find_student(student.get_id()) is None:
            raise ValueError("This doctor can only manage students in their own college")

    def _selected_doctor(self):
        value = self.doctor_var.get()
        if not value:
            return None
        doctor_id = int(value.split(" - ", 1)[0])
        for doctor in self.doctors:
            if doctor.get_id() == doctor_id:
                return doctor
        return None

    def _college_by_name(self, name):
        for col in self.colleges:
            if col.get_name() == name:
                return col
        raise ValueError("College not found")

    def _check_unique_student(self, national, phone, ignore_student=None):
        for col in self.colleges:
            for student in col.get_students().values():
                if student is ignore_student:
                    continue
                if student.get_national_number() == national:
                    raise ValueError("This National ID is already registered")
                if student.get_phone() == phone:
                    raise ValueError("This phone number is already registered")

    def _student_subjects(self, student):
        return list(getattr(student, "_Student__subjects", []))

    def _doctor_subjects(self, doctor):
        return list(getattr(doctor, "_Doctor__subjects", []))

    def _selected_subjects(self, variables):
        return [subject for subject, var in variables.items() if var.get()]

    def _valid_name(self, value):
        value = value.strip()
        if not value or not value.replace(" ", "").isalpha():
            raise ValueError("Name must contain only letters and spaces")
        return value

    def _valid_digits(self, value, label, length):
        value = value.strip()
        if not value.isdigit() or len(value) != length:
            raise ValueError(f"{label} must be {length} digits")
        return value

    def _parse_int(self, value, label):
        try:
            return int(value)
        except ValueError:
            raise ValueError(f"{label} must be a number")

    def _parse_float(self, value, label):
        try:
            return float(value)
        except ValueError:
            raise ValueError(f"{label} must be a number")

    def _grade_component(self, value, label, max_score):
        grade = self._parse_float(value, label)
        if not 0 <= grade <= max_score:
            raise ValueError(f"{label} grade must be between 0 and {max_score}")
        return (grade / max_score) * 100


if __name__ == "__main__":
    app = UniversityApp()
    app.mainloop()
