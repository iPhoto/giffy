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
    public class RegisterController : ApiControllerBase
    {
        [HttpPost]
        [AllowAnonymous]
        [ActionName("Default")]
        public ApiResult<bool> Post(RegisterModel model)
        {
            if (!ModelState.IsValid)
                return Failure<bool>("The data is not in the correct format");

            try
            {
                WebSecurity.CreateUserAndAccount(model.UserName, model.Password);
                WebSecurity.Login(model.UserName, model.Password);

                return Success(true);
            }
            catch (MembershipCreateUserException e)
            {
                return Failure<bool>(AccountErrors.ErrorCodeToString(e.StatusCode));
            }
        }
    }
}
