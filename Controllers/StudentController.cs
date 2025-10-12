using Microsoft.AspNetCore.Mvc;
using TutorLiveMentor.Models;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Linq;

namespace TutorLiveMentor.Controllers
{
    public class StudentController : Controller
    {
        private readonly AppDbContext _context;

        public StudentController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Register(StudentRegistrationModel model)
        {
            if (ModelState.IsValid)
            {
                if (_context.Students.Any(s => s.Email == model.Email))
                {
                    ModelState.AddModelError("Email", "Email is already registered.");
                    return View(model);
                }

                var student = new Student
                {
                    FullName = model.FullName,
                    RegdNumber = model.RegdNumber,
                    Year = model.Year,
                    Department = model.Department,
                    Email = model.Email,
                    Password = model.Password
                };

                _context.Students.Add(student);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Registration successful! Please log in now.";
                return RedirectToAction("Login");
            }
            return View(model);
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var student = await _context.Students.FirstOrDefaultAsync(s => s.Email == model.Email);
            if (student == null || student.Password != model.Password)
            {
                ModelState.AddModelError(string.Empty, "Invalid Email or Password.");
                return View(model);
            }

            // After login, go to MainDashboard with big icon menu
            return RedirectToAction("MainDashboard");
        }

        [HttpGet]
        public IActionResult MainDashboard()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> Dashboard()
        {
            var student = await _context.Students.FirstOrDefaultAsync();
            if (student == null)
                return RedirectToAction("Login");

            return View(student);
        }

        [HttpGet]
        public async Task<IActionResult> Edit()
        {
            var student = await _context.Students.FirstOrDefaultAsync();
            if (student == null)
                return RedirectToAction("Login");
            return View(student);
        }

        [HttpPost]
        public async Task<IActionResult> Edit(Student model)
        {
            if (ModelState.IsValid)
            {
                var student = await _context.Students.FindAsync(model.Id);
                if (student == null)
                    return RedirectToAction("Login");

                student.FullName = model.FullName;
                student.Year = model.Year;
                student.Department = model.Department;

                _context.Students.Update(student);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Profile updated!";
                return RedirectToAction("Dashboard");
            }
            return View(model);
        }

        [HttpGet]
        public IActionResult Logout()
        {
            return RedirectToAction("Login");
        }
    }
}
