# Faculty Selection Schedule Feature - Implementation Complete

## ? Overview

This feature allows department admins (CSEDS) to control when students can select faculty members by:
1. **Toggle Selection ON/OFF** - Master switch to enable/disable faculty selection
2. **Set Time Periods** - Define start and end date/time for selection windows
3. **Department-Specific** - Settings only affect the CSEDS department

---

## ? What's Been Created

### 1. **Model** (`Models/FacultySelectionSchedule.cs`) ?
- `FacultySelectionSchedule` - Database entity
- `FacultySelectionScheduleViewModel` - View model for UI
- Properties:
  - `IsEnabled` - Master toggle
  - `UseSchedule` - Use time-based schedule or always available
  - `StartDateTime` - When selection opens
  - `EndDateTime` - When selection closes
  - `DisabledMessage` - Custom message for students
  - `IsCurrentlyAvailable` - Computed property checking all rules

### 2. **Database** ?
- Added `DbSet<FacultySelectionSchedule>` to AppDbContext
- Ready for migration (run: `dotnet ef migrations add AddFacultySelectionSchedule`)

---

## ???? Next Steps to Complete Implementation

### Step 1: Create Database Migration
```bash
dotnet ef migrations add AddFacultySelectionSchedule
dotnet ef database update
```

### Step 2: Add Controller Actions to `AdminController.cs`

Add these methods:

```csharp
/// <summary>
/// Get or create faculty selection schedule for CSEDS department
/// </summary>
[HttpGet]
public async Task<IActionResult> ManageFacultySelectionSchedule()
{
    var department = HttpContext.Session.GetString("AdminDepartment");
    if (!IsCSEDSDepartment(department))
        return RedirectToAction("Login");

    // Get or create schedule for CSEDS department
    var schedule = await _context.FacultySelectionSchedules
        .FirstOrDefaultAsync(s => s.Department == "CSEDS" || s.Department == "CSE(DS)");

    if (schedule == null)
    {
        // Create default schedule
        schedule = new FacultySelectionSchedule
        {
            Department = "CSEDS",
            IsEnabled = true,
            UseSchedule = false,
            DisabledMessage = "Faculty selection is currently disabled. Please check back later.",
            CreatedAt = DateTime.Now,
            UpdatedAt = DateTime.Now,
            UpdatedBy = HttpContext.Session.GetString("AdminEmail") ?? ""
        };
        _context.FacultySelectionSchedules.Add(schedule);
        await _context.SaveChangesAsync();
    }

    // Build view model
    var viewModel = new FacultySelectionScheduleViewModel
    {
        ScheduleId = schedule.ScheduleId,
        Department = schedule.Department,
        IsEnabled = schedule.IsEnabled,
        UseSchedule = schedule.UseSchedule,
        StartDateTime = schedule.StartDateTime,
        EndDateTime = schedule.EndDateTime,
        DisabledMessage = schedule.DisabledMessage,
        IsCurrentlyAvailable = schedule.IsCurrentlyAvailable,
        StatusDescription = schedule.StatusDescription,
        UpdatedAt = schedule.UpdatedAt,
        UpdatedBy = schedule.UpdatedBy,
        
        // Get affected counts
        AffectedStudents = await _context.Students
            .Where(s => s.Department == "CSEDS" || s.Department == "CSE(DS)")
            .CountAsync(),
        AffectedSubjects = await _context.Subjects
            .Where(s => s.Department == "CSEDS" || s.Department == "CSE(DS)")
            .CountAsync(),
        TotalEnrollments = await _context.StudentEnrollments
            .Include(se => se.Student)
            .Where(se => se.Student.Department == "CSEDS" || se.Student.Department == "CSE(DS)")
            .CountAsync()
    };

    return View(viewModel);
}

/// <summary>
/// Update faculty selection schedule
/// </summary>
[HttpPost]
public async Task<IActionResult> UpdateFacultySelectionSchedule([FromBody] FacultySelectionScheduleViewModel model)
{
    var department = HttpContext.Session.GetString("AdminDepartment");
    if (!IsCSEDSDepartment(department))
        return Json(new { success = false, message = "Unauthorized access" });

    try
    {
        var schedule = await _context.FacultySelectionSchedules
            .FirstOrDefaultAsync(s => s.ScheduleId == model.ScheduleId);

        if (schedule == null)
            return Json(new { success = false, message = "Schedule not found" });

        // Validate dates if using schedule
        if (model.UseSchedule)
        {
            if (!model.StartDateTime.HasValue || !model.EndDateTime.HasValue)
                return Json(new { success = false, message = "Start and end dates are required when using schedule" });

            if (model.EndDateTime <= model.StartDateTime)
                return Json(new { success = false, message = "End date must be after start date" });
        }

        // Update schedule
        schedule.IsEnabled = model.IsEnabled;
        schedule.UseSchedule = model.UseSchedule;
        schedule.StartDateTime = model.StartDateTime;
        schedule.EndDateTime = model.EndDateTime;
        schedule.DisabledMessage = model.DisabledMessage;
        schedule.UpdatedAt = DateTime.Now;
        schedule.UpdatedBy = HttpContext.Session.GetString("AdminEmail") ?? "";

        await _context.SaveChangesAsync();

        // Notify via SignalR if needed
        await _signalRService.NotifyUserActivity(
            schedule.UpdatedBy,
            "Admin",
            "Faculty Selection Schedule Updated",
            $"Faculty selection schedule updated for CSEDS department: {schedule.StatusDescription}"
        );

        return Json(new { 
            success = true, 
            message = "Schedule updated successfully",
            data = new {
                isCurrentlyAvailable = schedule.IsCurrentlyAvailable,
                statusDescription = schedule.StatusDescription
            }
        });
    }
    catch (Exception ex)
    {
        return Json(new { success = false, message = $"Error updating schedule: {ex.Message}" });
    }
}

/// <summary>
/// Get current schedule status (for students to check)
/// </summary>
[HttpGet]
public async Task<IActionResult> GetSelectionScheduleStatus(string department)
{
    try
    {
        var schedule = await _context.FacultySelectionSchedules
            .FirstOrDefaultAsync(s => s.Department == department);

        if (schedule == null)
        {
            return Json(new { 
                isAvailable = true, // Default: always available if no schedule set
                message = "Faculty selection is available"
            });
        }

        return Json(new {
            isAvailable = schedule.IsCurrentlyAvailable,
            message = schedule.IsCurrentlyAvailable ? "Faculty selection is currently available" : schedule.DisabledMessage,
            statusDescription = schedule.StatusDescription,
            startDateTime = schedule.StartDateTime,
            endDateTime = schedule.EndDateTime
        });
    }
    catch (Exception ex)
    {
        return Json(new { 
            isAvailable = true, // Fail-safe: allow selection if error
            message = "Faculty selection status check failed"
        });
    }
}
```

### Step 3: Add New Dashboard Card to `CSEDSDashboard.cshtml`

Add this card in the management-container section (after Reports card):

```html
<!-- Faculty Selection Schedule -->
<div class="management-card schedule-card" onclick="window.location.href='@Url.Action("ManageFacultySelectionSchedule", "Admin")'">
    <i class="fas fa-clock management-icon"></i>
    <div class="management-title">Faculty Selection Schedule</div>
    <div class="management-desc">Control when students can select faculty. Toggle selection on/off or set specific time periods for faculty selection windows.</div>
    <button class="glass-btn">
        <i class="fas fa-calendar-alt"></i> Manage Schedule
    </button>
</div>
```

Add CSS for the new card:

```css
.management-card.schedule-card::before {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
}

.schedule-card .management-icon { color: #e74c3c; }
```

### Step 4: Create View (`Views/Admin/ManageFacultySelectionSchedule.cshtml`)

Create a new view with toggle switches, date/time pickers, and real-time status display. The view should show:

1. **Current Status Badge** - Shows if selection is currently available
2. **Master Toggle** - Enable/Disable selection completely
3. **Schedule Mode Toggle** - Use time-based schedule or always available
4. **Date/Time Pickers** - Set start and end date/time
5. **Custom Message Input** - Message to show students when disabled
6. **Impact Summary** - Shows how many students/subjects affected
7. **Preview Section** - Shows what students will see

---

## ? User Interface Features

### Dashboard Card
```
??????????????????????????????????
?  ?  Faculty Selection        ?
?     Schedule                 ?
?                              ?
? Control when students can    ?
? select faculty. Toggle       ?
? selection on/off or set      ?
? specific time periods.       ?
?                              ?
?  [? Manage Schedule]         ?
??????????????????????????????????
```

### Management Page Features

#### 1. Status Display
```
Current Status: ? ACTIVE
Selection is available from Dec 15, 2024 10:00 AM to Dec 31, 2024 11:59 PM
```

#### 2. Master Toggle
```
Faculty Selection: [ON] OFF
? Selection is enabled for CSEDS department
```

#### 3. Schedule Mode
```
Use Time Schedule: [?] Yes    [ ] No (Always Available)
? Define specific time periods for selection windows
```

#### 4. Date/Time Settings
```
Start Date & Time:  [Dec 15, 2024] [10:00 AM]
End Date & Time:    [Dec 31, 2024] [11:59 PM]
```

#### 5. Custom Message
```
Message when disabled:
?????????????????????????????
? Faculty selection is    ?
? currently disabled.     ?
? Please check back later.?
?????????????????????????????
```

#### 6. Impact Summary
```
? Affected Statistics:
  - Students: 150
  - Subjects: 25
  - Current Enrollments: 450
```

---

## ? Validation Rules

### Frontend Validation
- Start date cannot be in the past
- End date must be after start date
- Message length: 10-500 characters
- Dates required when UseSchedule = true

### Backend Validation
- Verify admin has CSEDS department access
- Check date logic
- Prevent overlapping schedules (future enhancement)
- Log all changes with admin email

---

## ? Integration Points

### 1. Student SelectSubject Page
Add this check before showing subjects:

```csharp
// Check if faculty selection is currently available
var schedule = await _context.FacultySelectionSchedules
    .FirstOrDefaultAsync(s => s.Department == studentDepartment);

if (schedule != null && !schedule.IsCurrentlyAvailable)
{
    TempData["ErrorMessage"] = schedule.DisabledMessage;
    return RedirectToAction("MainDashboard");
}
```

### 2. Enrollment Controller
Add similar check before processing enrollment:

```csharp
var schedule = await _context.FacultySelectionSchedules
    .FirstOrDefaultAsync(s => s.Department == student.Department);

if (schedule != null && !schedule.IsCurrentlyAvailable)
{
    return Json(new { 
        success = false, 
        message = schedule.DisabledMessage 
    });
}
```

---

## ? Testing Scenarios

### Scenario 1: Toggle OFF
1. Admin sets IsEnabled = false
2. Students see error message
3. Cannot access faculty selection page
4. Cannot enroll in subjects

### Scenario 2: Schedule Mode
1. Admin sets UseSchedule = true
2. Sets dates: Dec 15 - Dec 31
3. Before Dec 15: Students blocked
4. Dec 15 - Dec 31: Students can select
5. After Dec 31: Students blocked again

### Scenario 3: Always Available
1. Admin sets IsEnabled = true
2. Sets UseSchedule = false
3. Students can always select faculty

---

## ? Benefits

1. **Control** - Admins control enrollment windows
2. **Flexibility** - Can toggle instantly or use schedules
3. **Communication** - Custom messages to students
4. **Department-Specific** - Only affects CSEDS
5. **Audit Trail** - Logs who made changes and when

---

## ? Quick Actions Reference

| Action | Steps |
|--------|-------|
| **Disable Selection** | Toggle IsEnabled to OFF ? Save |
| **Enable Always** | IsEnabled ON + UseSchedule OFF ? Save |
| **Set Time Period** | IsEnabled ON + UseSchedule ON + Set Dates ? Save |
| **Extend Period** | Update EndDateTime ? Save |
| **Emergency Close** | Toggle IsEnabled OFF (instant) |

---

## ? Database Schema

```sql
CREATE TABLE FacultySelectionSchedules (
    ScheduleId INT PRIMARY KEY IDENTITY(1,1),
    Department NVARCHAR(50) NOT NULL,
    IsEnabled BIT NOT NULL DEFAULT 1,
    UseSchedule BIT NOT NULL DEFAULT 0,
    StartDateTime DATETIME2 NULL,
    EndDateTime DATETIME2 NULL,
    DisabledMessage NVARCHAR(500) NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    UpdatedAt DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(100) NOT NULL
);
```

---

## ? Future Enhancements

1. **Email Notifications** - Notify students when schedule changes
2. **Recurring Schedules** - Repeat selection windows
3. **Multiple Windows** - Multiple selection periods per semester
4. **Auto-Close** - Automatically close after X enrollments
5. **Department Groups** - Manage multiple departments together
6. **Analytics** - Track selection activity during windows

---

## ? Summary

? **Status:** Implementation foundation complete
? **Next:** Add controller actions + create view
? **Time:** ~2 hours to complete full implementation
? **Priority:** Medium-High (improves admin control)

---

**Created:** [Current Date]
**Feature:** Faculty Selection Schedule Management
**Department:** CSEDS
**Status:** ? Ready for Controller & View Implementation
