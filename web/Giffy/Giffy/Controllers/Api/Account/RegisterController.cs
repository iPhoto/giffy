using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Security;
using Giffy.Filters;
using Giffy.Models;
using Giffy.Utilities;
using WebMatrix.WebData;

namespace Giffy.Controllers.Api.Account
{
    [AllowAnonymous]
    [InitializeApiMembershipAttribute]
    public class RegisterController : ApiController
    {
        [HttpPost]
        [AllowAnonymous]
        public object Post(RegisterModel model)
        {
            if (!ModelState.IsValid)
                return new {
                    success = false,
                    data = new { }
                };

            try
            {
                WebSecurity.CreateUserAndAccount(model.UserName, model.Password);
                WebSecurity.Login(model.UserName, model.Password);

                return new { 
                    success = true,
                    data = new { } 
                };
            }
            catch (MembershipCreateUserException e)
            {
                return new
                {
                    success = false,
                    data = new
                    {
                        message = AccountErrors.ErrorCodeToString(e.StatusCode)
                    }
                };
            }
        }
    }
}
