# Quick Start - Testing Faculty Selection Schedule ?

## ?? 5-Minute Test Guide

### Prerequisites
? Database migrated (FacultySelectionSchedules table exists)
? Application running
? CSEDS admin account ready (cseds@rgmcet.edu.in / admin123)

---

## Test 1: Access the Feature (1 min)

### Steps:
1. **Login as CSEDS Admin**
   ```
   URL: http://localhost:5000/Admin/Login
   Email: cseds@rgmcet.edu.in
   Password: admin123
   ```

2. **Navigate to Dashboard**
   - You should see the CSEDS Dashboard
   - Look for the NEW card: "Faculty Selection Schedule"

3. **Click the Schedule Card**
   - Should navigate to: `/Admin/ManageFacultySelectionSchedule`
   - Should see the management interface

### ? Expected Result:
```
????????????????????????????????????
? ?? Faculty Selection Schedule    ?
?                                  ?
? ? Current Status: ACTIVE        ?
? Faculty selection is available   ?
?                                  ?
? [Master Control Section]         ?
? [Schedule Settings]              ?
? [Custom Message]                 ?
? [Impact Summary]                 ?
?                                  ?
? [?? Save Changes] [?? Reset]    ?
????????????????????????????????????
```

---

## Test 2: Toggle Master Switch (1 min)

### Steps:
1. **Find Master Control Section**
   - See toggle switch: "Faculty Selection"
   - Default should be ON

2. **Toggle to OFF**
   - Click the toggle switch
   - Switch should animate from ON to OFF

3. **Click Save Changes**
   - Should see loading spinner
   - Should see success message
   - Status banner should update to "DISABLED"

### ? Expected Result:
```
????????????????????????????????????
? ? Current Status: DISABLED      ?
? Faculty selection is disabled    ?
????????????????????????????????????

? Success!
Schedule updated successfully
```

4. **Toggle Back to ON**
   - Toggle switch back ON
   - Click Save
   - Status should return to "ACTIVE"

---

## Test 3: Set Time Schedule (2 mins)

### Steps:
1. **Enable Schedule Mode**
   - Toggle "Use Time-Based Schedule" to ON
   - Date/time fields should appear

2. **Set Future Dates**
   ```
   Start: Tomorrow at 9:00 AM
   End: Tomorrow at 5:00 PM
   ```

3. **Click Save**
   - Should save successfully
   - Status should show: "Opens: [Tomorrow date]"

4. **Check Status**
   ```
   ? Current Status: DISABLED
   Opens: Dec 11, 2024 09:00 AM
   ```

5. **Set Current Window**
   ```
   Start: Today at 8:00 AM (past time)
   End: Tomorrow at 11:59 PM (future time)
   ```

6. **Save Again**
   ```
   ? Current Status: ACTIVE
   Active until Dec 11, 2024 11:59 PM
   ```

---

## Test 4: Custom Message (30 sec)

### Steps:
1. **Find Custom Message Section**
   - See textarea with default message

2. **Change Message**
   ```
   Type: "Faculty selection will open on December 15th at 9:00 AM. 
   Please check your email for updates."
   ```

3. **Watch Character Counter**
   - Should show: "XX / 500 characters"

4. **Save Changes**
   - New message saved
   - Will be shown to students when disabled

---

## Test 5: Validation Testing (30 sec)

### Test Invalid Dates:
1. **Enable Schedule Mode**
2. **Set End Before Start**
   ```
   Start: Dec 20, 2024 10:00 AM
   End: Dec 15, 2024 10:00 AM
   ```
3. **Click Save**

### ? Expected Result:
```
? Error!
End date must be after start date
```

### Test Empty Dates:
1. **Enable Schedule Mode**
2. **Leave dates empty**
3. **Click Save**

### ? Expected Result:
```
? Error!
Start and end dates are required when using schedule
```

---

## Test 6: Impact Statistics (30 sec)

### Check Displayed Stats:
Should show three cards:
```
???????????  ???????????  ???????????
?   ###   ?  ?   ##    ?  ?   ###   ?
?Students ?  ?Subjects ?  ?Enrollmts?
???????????  ???????????  ???????????
```

These numbers come from your database:
- **Students:** Count of CSEDS students
- **Subjects:** Count of CSEDS subjects
- **Enrollments:** Count of CSEDS enrollments

---

## Test 7: Reset Functionality (30 sec)

### Steps:
1. **Make Some Changes**
   - Toggle a switch
   - Change message
   - Don't save

2. **Click Reset Button**
   - Should ask: "Are you sure you want to reset all changes?"
   - Click OK

### ? Expected Result:
- All fields revert to last saved values
- No changes saved to database

---

## Test 8: Mobile Responsiveness (1 min)

### Steps:
1. **Open Browser DevTools**
   - Press F12
   - Toggle device toolbar (Ctrl+Shift+M)

2. **Select Mobile Device**
   - iPhone 12 Pro or similar
   - 390px width

3. **Navigate Pages**
   - Dashboard should stack cards vertically
   - Management page should be single-column
   - All controls should be touch-friendly

### ? Expected Result:
- No horizontal scrolling
- Readable text
- Tappable buttons
- Smooth scrolling

---

## Test 9: API Endpoint (30 sec)

### Test Schedule Status API:
1. **Open Browser Console**
2. **Run This Command:**
   ```javascript
   fetch('/Admin/GetSelectionScheduleStatus?department=CSEDS')
     .then(r => r.json())
     .then(data => console.log(data));
   ```

### ? Expected Result:
```json
{
  "isAvailable": true,
  "message": "Faculty selection is currently available",
  "statusDescription": "Always Available",
  "startDateTime": null,
  "endDateTime": null
}
```

---

## Test 10: Audit Trail (30 sec)

### Check Audit Info:
At bottom of management page, should see:
```
???????????????????????????????????????
? ?? Last Updated: Dec 10, 2024 3:45 PM?
? ?? Updated By: cseds@rgmcet.edu.in   ?
???????????????????????????????????????
```

After any save:
- Timestamp updates
- Email shows who made change

---

## Common Issues & Fixes

### Issue 1: Card Not Showing
**Problem:** Schedule card not visible on dashboard
**Fix:** 
- Clear browser cache
- Hard refresh (Ctrl+F5)
- Check you're logged in as CSEDS admin

### Issue 2: Save Button Disabled
**Problem:** Can't click save button
**Fix:**
- Check browser console for errors
- Make sure changes were made
- Verify network connection

### Issue 3: Status Not Updating
**Problem:** Status banner shows old info
**Fix:**
- Refresh the page
- Check database directly
- Clear application cache

### Issue 4: Database Error
**Problem:** Error accessing database
**Fix:**
- Verify migration was applied
- Check connection string
- Restart application

---

## Database Verification

### Check Schedule in Database:
```sql
-- View all schedules
SELECT * FROM FacultySelectionSchedules;

-- Check CSEDS schedule
SELECT * FROM FacultySelectionSchedules 
WHERE Department = 'CSEDS' OR Department = 'CSE(DS)';

-- Manually update if needed
UPDATE FacultySelectionSchedules
SET IsEnabled = 1,
    UseSchedule = 0,
    UpdatedAt = GETDATE()
WHERE Department = 'CSEDS';
```

---

## Success Criteria ?

After running all tests, you should have:

? **Accessed the feature** - Can navigate to management page
? **Toggled master switch** - ON/OFF works correctly
? **Set time schedule** - Dates save and display properly
? **Changed message** - Custom message updates
? **Validated inputs** - Errors show for invalid data
? **Viewed statistics** - Impact numbers display
? **Reset form** - Reset button works
? **Mobile tested** - Responsive on small screens
? **API works** - Endpoint returns correct data
? **Audit tracked** - Changes logged with timestamp

---

## Next Steps

### For Full Integration:
1. **Add schedule checks to StudentController:**
   - SelectSubject action
   - EnrollSubject action

2. **Test with student account:**
   - Try accessing when disabled
   - Try accessing during schedule window
   - Verify error messages display

3. **Production Deployment:**
   - Backup database
   - Deploy updated code
   - Verify in production
   - Notify admins of new feature

---

## Quick Reference

### Default Settings:
```
IsEnabled: true
UseSchedule: false
DisabledMessage: "Faculty selection is currently disabled. Please check back later."
```

### URLs:
```
Dashboard: /Admin/CSEDSDashboard
Management: /Admin/ManageFacultySelectionSchedule
API: /Admin/GetSelectionScheduleStatus?department=CSEDS
```

### Keyboard Shortcuts:
```
Ctrl+S: (Future) Quick save
Escape: Close alerts
Tab: Navigate controls
Enter: Submit form
```

---

## Testing Checklist

Print this and check off as you test:

- [ ] Login as CSEDS admin
- [ ] Navigate to schedule management
- [ ] Toggle master switch OFF
- [ ] Toggle master switch ON
- [ ] Enable schedule mode
- [ ] Set future dates
- [ ] Set current date window
- [ ] Change custom message
- [ ] Test invalid date validation
- [ ] Test empty date validation
- [ ] View impact statistics
- [ ] Use reset button
- [ ] Test on mobile device
- [ ] Call API endpoint
- [ ] Verify audit trail
- [ ] Save multiple times
- [ ] Refresh page and verify settings persist

---

## Support

If you encounter issues:

1. **Check browser console** (F12)
2. **Review server logs**
3. **Verify database state**
4. **Test with fresh login**
5. **Clear all caches**

---

**Happy Testing!** ??

The feature is ready to use. Follow this guide to verify everything works as expected!
