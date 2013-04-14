using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Giffy.Filters;
using Giffy.Modules;
using WebMatrix.WebData;

namespace Giffy.Controllers.Api
{
    [InitializeApiMembershipAttribute]
    public class LogoutController : ApiControllerBase
    {
        [AllowAnonymous]
        [ActionName("Default")]
        public void Post()
        {
            new SecurityModule().DeleteToken(this.User.Identity.Name);
            WebSecurity.Logout();
        }
    }
}
