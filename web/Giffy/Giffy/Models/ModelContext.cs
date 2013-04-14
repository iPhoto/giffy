using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using Giffy.Models.Gifs;

namespace Giffy.Models
{
    public class ModelContext : DbContext
    {
        public ModelContext() : base("DefaultConnection") { }

        public DbSet<Authentication> Authentications { get; set; }
        public DbSet<GifComponent> GifComponents { get; set; }
        public DbSet<GifBuilder> GifBuilders { get; set; }
        public DbSet<GifContainer> GifContainers { get; set; }
    }

    public class ModelDatabaseInitializer : DropCreateDatabaseIfModelChanges<ModelContext>
    {
        protected override void Seed(ModelContext context)
        {
            
        }
    }
}