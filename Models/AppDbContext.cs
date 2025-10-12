using Microsoft.EntityFrameworkCore;

namespace TutorLiveMentor.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Student> Students { get; set; }
        public DbSet<Faculty> Faculties { get; set; }
        public DbSet<Subject> Subjects { get; set; }
        public DbSet<AssignedSubject> AssignedSubjects { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // AssignedSubject -> Subject (many-to-one)
            modelBuilder.Entity<AssignedSubject>()
                .HasOne(a => a.Subject)
                .WithMany(s => s.AssignedSubjects)
                .HasForeignKey(a => a.SubjectId);

            // AssignedSubject -> Faculty (many-to-one)
            modelBuilder.Entity<AssignedSubject>()
                .HasOne(a => a.Faculty)
                .WithMany(f => f.AssignedSubjects)
                .HasForeignKey(a => a.FacultyId);

            // Student -> AssignedSubject (many-to-one, optional)
            modelBuilder.Entity<Student>()
                .HasOne(s => s.AssignedSubject)
                .WithMany(a => a.Students)
                .HasForeignKey(s => s.AssignedSubjectId)
                .OnDelete(DeleteBehavior.SetNull);

            // (Optional) Add indexes for performance
            modelBuilder.Entity<AssignedSubject>()
                .HasIndex(a => new { a.SubjectId, a.Department, a.Year });
            modelBuilder.Entity<Student>()
                .HasIndex(s => new { s.Department, s.Year });
        }
    }
}
