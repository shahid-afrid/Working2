using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TutorLiveMentor.Models;
using System.Linq;
using System.Collections.Generic;

namespace TutorLiveMentor.Controllers
{
    public class FacultyController : Controller
    {
        private readonly AppDbContext _context;

        public FacultyController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Login(FacultyLoginViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            var faculty = _context.Faculties.FirstOrDefault(f =>
                f.Email == model.Email && f.Password == model.Password);

            if (faculty == null)
            {
                ModelState.AddModelError("", "Invalid credentials!");
                return View(model);
            }

            TempData["FacultyId"] = faculty.FacultyId;
            return RedirectToAction("Dashboard");
        }

        [HttpGet]
        public IActionResult Dashboard()
        {
            if (TempData["FacultyId"] == null) return RedirectToAction("Login");

            int facultyId = (int)TempData["FacultyId"];
            var faculty = _context.Faculties
                .Include(f => f.AssignedSubjects)
                .FirstOrDefault(f => f.FacultyId == facultyId);

            TempData.Keep("FacultyId");
            return View(faculty);
        }

        [HttpGet]
        public IActionResult Profile()
        {
            if (TempData["FacultyId"] == null) return RedirectToAction("Login");

            int facultyId = (int)TempData["FacultyId"];
            var faculty = _context.Faculties.FirstOrDefault(f => f.FacultyId == facultyId);
            TempData.Keep("FacultyId");
            return View(faculty);
        }

        // ----------- EDIT PROFILE ----------
        [HttpGet]
        public IActionResult EditProfile()
        {
            if (TempData["FacultyId"] == null) return RedirectToAction("Login");
            int facultyId = (int)TempData["FacultyId"];
            var faculty = _context.Faculties.FirstOrDefault(f => f.FacultyId == facultyId);
            TempData.Keep("FacultyId");
            return View(faculty);
        }

        [HttpPost]
        public IActionResult EditProfile(Faculty model)
        {
            if (!ModelState.IsValid)
            {
                TempData.Keep("FacultyId");
                return View(model);
            }

            var faculty = _context.Faculties.FirstOrDefault(f => f.FacultyId == model.FacultyId);
            if (faculty == null)
            {
                TempData.Keep("FacultyId");
                return RedirectToAction("Profile");
            }

            // Update properties
            faculty.Name = model.Name;
            faculty.Email = model.Email;
            // Add other properties you want editable...

            _context.SaveChanges();
            TempData.Keep("FacultyId");
            return RedirectToAction("Profile");
        }

        [HttpGet]
        public IActionResult AssignedSubjects()
        {
            if (TempData["FacultyId"] == null) return RedirectToAction("Login");
            int facultyId = (int)TempData["FacultyId"];
            var subjects = _context.AssignedSubjects
                .Include(a => a.Subject)
                .Where(x => x.FacultyId == facultyId)
                .ToList();
            TempData.Keep("FacultyId");
            return View(subjects);
        }

        [HttpGet]
        public IActionResult StudentsEnrolled(string subject = null)
        {
            if (TempData["FacultyId"] == null) return RedirectToAction("Login");

            int facultyId = (int)TempData["FacultyId"];
            var subjects = _context.AssignedSubjects
                .Include(a => a.Subject)
                .Where(x => x.FacultyId == facultyId)
                .ToList();

            ViewBag.Subjects = subjects;
            ViewBag.SelectedSubject = subject;

            List<Student> students = new List<Student>();
            if (!string.IsNullOrEmpty(subject))
            {
                var validSubjectYears = subjects
                    .Where(subj => subj.Subject.Name == subject)
                    .Select(subj => subj.Year.ToString())
                    .ToList();

                students = _context.Students
                    .Where(s => s.SelectedSubject == subject && validSubjectYears.Contains(s.Year))
                    .ToList();
            }

            TempData.Keep("FacultyId");
            return View(students);
        }
    }
}
