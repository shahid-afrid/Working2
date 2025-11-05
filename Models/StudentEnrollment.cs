namespace TutorLiveMentor.Models
{
    public class StudentEnrollment
    {
        public int StudentEnrollmentId { get; set; }
        public string StudentId { get; set; } // Changed from int to string
        public Student Student { get; set; }
        public int AssignedSubjectId { get; set; }
        public AssignedSubject AssignedSubject { get; set; }
        
        // ?? PRECISE TIMESTAMP: First-come-first-served with millisecond precision
        public DateTime EnrolledAt { get; set; } = DateTime.UtcNow;
    }
}