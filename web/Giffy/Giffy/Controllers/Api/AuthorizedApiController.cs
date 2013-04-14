using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Giffy.Models;
using Giffy.Utilities;
using System.Net.Http.Formatting;
using Giffy.Filters;

namespace Giffy.Controllers
{
    [AuthorizeApi]
    public abstract class AuthorizedApiController : ApiControllerBase 
    {
        protected string UserName
        {
            get { return this.User.Identity.Name; }
        }
    }
}