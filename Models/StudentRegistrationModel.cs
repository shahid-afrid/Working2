using System.ComponentModel.DataAnnotations;

namespace TutorLiveMentor.Models
{
    public class StudentRegistrationModel
    {
        [Required]
        public string FullName { get; set; }

        [Required]
        [StringLength(10, MinimumLength = 10, ErrorMessage = "Regd Number must be exactly 10 characters.")]
        public string RegdNumber { get; set; }

        [Required]
        public string Year { get; set; }

        [Required]
        public string Department { get; set; }

        [Required]
        [RegularExpression(@"^[a-zA-Z0-9._%+-]+@rgmcet\.edu\.in$", ErrorMessage = "Email must end with @rgmcet.edu.in")]
        public string Email { get; set; }

        [Required]
        [MinLength(8, ErrorMessage = "Password must be at least 8 characters.")]
        [RegularExpression(@"^(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d\s:]).{8,}$", ErrorMessage = "Password must have at least 1 uppercase letter, 1 digit, and 1 special character.")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
    }
}
