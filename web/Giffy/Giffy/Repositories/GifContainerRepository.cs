using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using Giffy.Models;
using Giffy.Models.Gifs;
using Giffy.Utilities;

namespace Giffy.Repositories
{
    public class GifContainerRepository : Repository<GifContainer>
    {
        protected override DbContext GetContext()
        {
            return RequestData.Instance.Models;
        }

        protected override DbSet<GifContainer> GetModels()
        {
            return RequestData.Instance.Models.GifContainers;
        }
    }
}