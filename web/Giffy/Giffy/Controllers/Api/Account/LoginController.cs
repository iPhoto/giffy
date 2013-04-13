using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Security;
using Giffy.Filters;
using Giffy.Models;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;

namespace Giffy.Controllers.Api
{
    [InitializeApiMembershipAttribute]
    public class LoginController : ApiController
    {
        [AllowAnonymous]
        public bool Post(LoginModel model)
        {
            if (ModelState.IsValid && WebSecurity.Login(model.UserName, model.Password))
            {
                FormsAuthentication.SetAuthCookie(model.UserName, false);
                return true;
            }

            return false;
        }
    }
}
