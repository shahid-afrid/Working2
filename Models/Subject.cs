using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TutorLiveMentor.Models
{
    public class Subject
    {
        public int SubjectId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Department { get; set; }

        // Navigation property
        public virtual ICollection<AssignedSubject> AssignedSubjects { get; set; }
    }
}
