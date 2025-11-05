using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TutorLiveMentor.Models;

namespace TutorLiveMentor.Controllers
{
    public class DiagnosticController : Controller
    {
        private readonly AppDbContext _context;

        public DiagnosticController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> CheckScheduleStatus()
        {
            var studentId = HttpContext.Session.GetString("StudentId");
            
            if (string.IsNullOrEmpty(studentId))
            {
                return Json(new { error = "Not logged in" });
            }

            var student = await _context.Students.FindAsync(studentId);
            if (student == null)
            {
                return Json(new { error = "Student not found" });
            }

            // Get all schedules
            var allSchedules = await _context.FacultySelectionSchedules
                .Select(s => new {
                    s.ScheduleId,
                    s.Department,
                    s.IsEnabled,
                    s.UseSchedule,
                    s.StartDateTime,
                    s.EndDateTime,
                    s.DisabledMessage,
                    IsCurrentlyAvailable = s.IsCurrentlyAvailable,
                    StatusDescription = s.StatusDescription
                })
                .ToListAsync();

            // Get the schedule for this student's department
            var schedule = await _context.FacultySelectionSchedules
                .FirstOrDefaultAsync(s => s.Department == student.Department);

            var result = new
            {
                student = new {
                    student.Id,
                    student.FullName,
                    student.Department,
                    student.Email
                },
                allSchedules = allSchedules,
                matchingSchedule = schedule == null ? null : new {
                    schedule.ScheduleId,
                    schedule.Department,
                    schedule.IsEnabled,
                    schedule.UseSchedule,
                    schedule.StartDateTime,
                    schedule.EndDateTime,
                    schedule.DisabledMessage,
                    IsCurrentlyAvailable = schedule.IsCurrentlyAvailable,
                    StatusDescription = schedule.StatusDescription
                },
                isAvailable = schedule == null || schedule.IsCurrentlyAvailable,
                message = schedule == null ? "No schedule found for department" : 
                         schedule.IsCurrentlyAvailable ? "Faculty selection is available" : 
                         "Faculty selection is DISABLED"
            };

            return Json(result);
        }

        [HttpGet]
        public async Task<IActionResult> CheckAllSchedules()
        {
            var allSchedules = await _context.FacultySelectionSchedules
                .Select(s => new {
                    s.ScheduleId,
                    s.Department,
                    s.IsEnabled,
                    s.UseSchedule,
                    s.StartDateTime,
                    s.EndDateTime,
                    s.DisabledMessage,
                    s.CreatedAt,
                    s.UpdatedAt,
                    s.UpdatedBy,
                    IsCurrentlyAvailable = s.IsCurrentlyAvailable,
                    StatusDescription = s.StatusDescription
                })
                .ToListAsync();

            var allStudents = await _context.Students
                .Where(s => s.Department == "CSEDS" || s.Department == "CSE(DS)")
                .Select(s => new { s.Id, s.FullName, s.Department, s.Email })
                .ToListAsync();

            return Json(new {
                totalSchedules = allSchedules.Count,
                schedules = allSchedules,
                csedstudents = allStudents,
                currentTime = DateTime.Now,
                message = "All schedule data"
            });
        }
    }
}
