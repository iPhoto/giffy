using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Giffy.Filters;
using WebMatrix.WebData;

namespace Giffy.Controllers.Api
{
    [InitializeApiMembershipAttribute]
    public class LogoutController : ApiController
    {
        [AllowAnonymous]
        public void Post()
        {
            WebSecurity.Logout();
        }
    }
}
