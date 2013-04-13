using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace Giffy.Models
{
    public class ModelContext : DbContext
    {
        public ModelContext() : base("DefaultConnection") { }
    }

    public class ModelDatabaseInitializer : DropCreateDatabaseAlways<ModelContext>
    {
        protected override void Seed(ModelContext context)
        {
            
        }
    }
}